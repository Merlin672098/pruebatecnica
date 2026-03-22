using Microsoft.EntityFrameworkCore;
using pruebatecnica.Contexto;
using pruebatecnica.Contrato;
using pruebatecnica.Models;
using System.Reflection;

namespace pruebatecnica.Implementacion
{
    public class ProductosLogic : IProductsContrato
    {
        private readonly AppDbContext _context;

        public ProductosLogic(AppDbContext context)
        {
            _context = context;
        }

        public async Task<List<Producto>> ListarTodos()
        {
            return await _context.Productos
                .OrderBy(p => p.Nombre)
                .ToListAsync();
        }

        public async Task<List<Producto>> Buscar(string texto)
        {
            // Filtra por nombre o SKU — igual que pide la prueba
            return await _context.Productos
                .Where(p => p.Nombre!.Contains(texto) || p.Sku!.Contains(texto))
                .OrderBy(p => p.Nombre)
                .ToListAsync();
        }

        public async Task<Producto?> ObtenerById(int id)
        {
            return await _context.Productos
                .FirstOrDefaultAsync(p => p.IdProducto == id);
        }

        public async Task<bool> ActualizarPrecio(int id, decimal precio)
        {
            // Validación que pide la prueba: precio > 0
            if (precio <= 0) return false;

            var producto = await _context.Productos
                .FirstOrDefaultAsync(p => p.IdProducto == id);

            if (producto == null) return false;   // el controller devolverá 404

            producto.Precio = precio;
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
