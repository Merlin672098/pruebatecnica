using pruebatecnica.Contexto;
using pruebatecnica.Contrato;
using pruebatecnica.Models;
using pruebatecnica.Middleware;
using Microsoft.EntityFrameworkCore;

namespace pruebatecnica.Implementacion
{
    public class UsuariosLogic : IUsersContrato
    {
        private readonly AppDbContext _context;

        public UsuariosLogic(AppDbContext context)
        {
            _context = context;
        }

        public async Task<List<Usuario>> ListarTodos()
        {
            return await _context.Usuarios
                .Include(u => u.Persona)
                .OrderByDescending(u => u.IdUsuario)
                .ToListAsync();
        }

        public async Task<Usuario?> ObtenerById(int id)
        {
            return await _context.Usuarios
                .Include(u => u.Persona)
                .FirstOrDefaultAsync(u => u.IdUsuario == id);
        }

        public async Task<Usuario?> ObtenerByNombre(string nombre)
        {
            return await _context.Usuarios
                .Include(u => u.Persona)
                .FirstOrDefaultAsync(u => u.UsuarioNombre == nombre);
        }

        public async Task<bool> Insertar(Usuario usuario)
        {
            bool sw = false;
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                if (!string.IsNullOrEmpty(usuario.UsuarioClave))
                {
                    usuario.UsuarioClave = PasswordHashHandler.HashPassword(usuario.UsuarioClave);
                }

                _context.ChangeTracker.LazyLoadingEnabled = false;
                _context.Usuarios.Add(usuario);
                int response = await _context.SaveChangesAsync();
                _context.ChangeTracker.LazyLoadingEnabled = true;

                if (response > 0)
                {
                    await transaction.CommitAsync();
                    sw = true;
                }
                else
                {
                    await transaction.RollbackAsync();
                }
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync();
                var innerMsg = ex.InnerException?.Message ?? ex.Message;
                throw new Exception(innerMsg);
            }
            return sw;
        }

        public async Task<bool> Modificar(Usuario usuario, int id)
        {
            bool sw = false;

            _context.ChangeTracker.LazyLoadingEnabled = false;

            var modificar = await _context.Usuarios
                .FirstOrDefaultAsync(u => u.IdUsuario == id);

            if (modificar != null)
            {
                if (!string.IsNullOrEmpty(usuario.UsuarioNombre))
                    modificar.UsuarioNombre = usuario.UsuarioNombre;

                if (!string.IsNullOrEmpty(usuario.UsuarioEmail))
                    modificar.UsuarioEmail = usuario.UsuarioEmail;

                modificar.IdRol = usuario.IdRol;
                modificar.UsuarioCondicion = usuario.UsuarioCondicion;

                if (!string.IsNullOrEmpty(usuario.UsuarioClave))
                    modificar.UsuarioClave = PasswordHashHandler.HashPassword(usuario.UsuarioClave);

                await _context.SaveChangesAsync();
                sw = true;
            }

            _context.ChangeTracker.LazyLoadingEnabled = true;

            return sw;
        }

        public async Task<bool> Delete(int id)
        {
            var eliminar = await _context.Usuarios.FirstOrDefaultAsync(u => u.IdUsuario == id);
            if (eliminar == null) return false;

            _context.Usuarios.Remove(eliminar);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<Usuario?> ObtenerByFirebaseUid(string firebaseUid)
        {
            return await _context.Usuarios
                .FirstOrDefaultAsync(u => u.FirebaseUid == firebaseUid);
        }
    }
}