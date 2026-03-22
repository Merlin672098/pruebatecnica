using pruebatecnica.Contrato;
using pruebatecnica.Models;
using Microsoft.AspNetCore.Mvc;

namespace pruebatecnica.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProductosController : ControllerBase
    {
        private readonly IProductsContrato _productosLogic;

        public ProductosController(IProductsContrato productosLogic)
        {
            _productosLogic = productosLogic;
        }

        // GET api/productos
        [HttpGet]
        public async Task<IActionResult> ListarTodos()
        {
            try
            {
                var productos = await _productosLogic.ListarTodos();
                return Ok(productos);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { mensaje = "Error interno", detalle = ex.Message });
            }
        }

        // GET api/productos/buscar?texto=auricular
        [HttpGet("buscar")]
        public async Task<IActionResult> Buscar([FromQuery] string texto)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(texto))
                    return BadRequest(new { mensaje = "El texto de búsqueda no puede estar vacío" });

                var productos = await _productosLogic.Buscar(texto);

                if (!productos.Any())
                    return NotFound(new { mensaje = "No se encontraron productos" });

                return Ok(productos);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { mensaje = "Error interno", detalle = ex.Message });
            }
        }

        // GET api/productos/5
        [HttpGet("{id}")]
        public async Task<IActionResult> ObtenerById(int id)
        {
            try
            {
                var producto = await _productosLogic.ObtenerById(id);

                if (producto == null)
                    return NotFound(new { mensaje = $"Producto con id {id} no encontrado" });

                return Ok(producto);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { mensaje = "Error interno", detalle = ex.Message });
            }
        }

        // PATCH api/productos/5/precio
        [HttpPatch("{id}/precio")]
        public async Task<IActionResult> ActualizarPrecio(int id, [FromBody] ActualizarPrecioDto dto)
        {
            try
            {
                if (dto.Precio <= 0)
                    return BadRequest(new { mensaje = "El precio debe ser mayor a 0" });

                var existe = await _productosLogic.ObtenerById(id);
                if (existe == null)
                    return NotFound(new { mensaje = $"Producto con id {id} no encontrado" });

                bool resultado = await _productosLogic.ActualizarPrecio(id, dto.Precio);

                if (!resultado)
                    return StatusCode(500, new { mensaje = "No se pudo actualizar el precio" });

                return Ok(new { mensaje = "Precio actualizado correctamente", idProducto = id, nuevoPrecio = dto.Precio });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { mensaje = "Error interno", detalle = ex.Message });
            }
        }
    }

    public class ActualizarPrecioDto
    {
        public decimal Precio { get; set; }
    }
}