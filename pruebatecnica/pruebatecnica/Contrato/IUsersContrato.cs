using pruebatecnica.Models;

namespace pruebatecnica.Contrato
{
    public interface IUsersContrato
    {
        Task<List<Usuario>> ListarTodos();
        Task<Usuario?> ObtenerById(int id);
        Task<Usuario?> ObtenerByNombre(string nombre);
        Task<bool> Insertar(Usuario usuario);
        Task<bool> Modificar(Usuario usuario, int id);
        Task<bool> Delete(int id);
        Task<Usuario?> ObtenerByFirebaseUid(string firebaseUid);

    }
}