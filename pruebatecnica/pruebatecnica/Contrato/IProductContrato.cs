using pruebatecnica.Models;

namespace pruebatecnica.Contrato
{
    public interface IProductsContrato
    {
        Task<List<Producto>> ListarTodos();
        Task<List<Producto>> Buscar(string texto);
        Task<Producto?> ObtenerById(int id);
        Task<bool> ActualizarPrecio(int id, decimal precio);
    }
}