using pruebatecnica.Middleware;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using pruebatecnica;
using pruebatecnica.Contexto;
using pruebatecnica.Contrato;
using pruebatecnica.Controllers;
using pruebatecnica.Implementacion;
using pruebatecnica.Models;
using System.Diagnostics.Contracts;
using System.Reflection;

namespace pruebatecnica.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UsuariosController : ControllerBase
    {
        private readonly IUsersContrato _usuariosLogic;

        public UsuariosController(IUsersContrato usuariosLogic)
        {
            _usuariosLogic = usuariosLogic;
        }

        // GET api/usuarios
        [HttpGet]
        public async Task<IActionResult> ListarTodos()
        {
            try
            {
                var usuarios = await _usuariosLogic.ListarTodos();
                return Ok(usuarios);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { mensaje = "Error interno", detalle = ex.Message });
            }
        }

        // GET api/usuarios/5
        [HttpGet("{id}")]
        public async Task<IActionResult> ObtenerById(int id)
        {
            try
            {
                var usuario = await _usuariosLogic.ObtenerById(id);

                if (usuario == null)
                    return NotFound(new { mensaje = $"Usuario con id {id} no encontrado" });

                return Ok(usuario);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { mensaje = "Error interno", detalle = ex.Message });
            }
        }

        // POST api/usuarios
        [HttpPost]
        public async Task<IActionResult> Insertar([FromBody] Usuario usuario)
        {
            try
            {
                if (usuario == null)
                    return BadRequest(new { mensaje = "Datos inválidos" });

                bool resultado = await _usuariosLogic.Insertar(usuario);

                if (!resultado)
                    return StatusCode(500, new { mensaje = "No se pudo insertar el usuario" });

                return StatusCode(201, new { mensaje = "Usuario creado correctamente" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { mensaje = "Error interno", detalle = ex.Message });
            }
        }

        // PUT api/usuarios/5
        [HttpPut("{id}")]
        public async Task<IActionResult> Modificar(int id, [FromBody] Usuario usuario)
        {
            try
            {
                bool resultado = await _usuariosLogic.Modificar(usuario, id);

                if (!resultado)
                    return NotFound(new { mensaje = $"Usuario con id {id} no encontrado" });

                return Ok(new { mensaje = "Usuario modificado correctamente" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { mensaje = "Error interno", detalle = ex.Message });
            }
        }

        // DELETE api/usuarios/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            try
            {
                bool resultado = await _usuariosLogic.Delete(id);

                if (!resultado)
                    return NotFound(new { mensaje = $"Usuario con id {id} no encontrado" });

                return Ok(new { mensaje = "Usuario eliminado correctamente" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { mensaje = "Error interno", detalle = ex.Message });
            }
        }

        // GET api/usuarios/firebase/{uid}
        [HttpGet("firebase/{uid}")]
        public async Task<IActionResult> ObtenerByFirebaseUid(string uid)
        {
            try
            {
                var usuario = await _usuariosLogic.ObtenerByFirebaseUid(uid);

                if (usuario == null)
                    return NotFound(new { mensaje = "Usuario no encontrado" });

                return Ok(usuario);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { mensaje = "Error interno", detalle = ex.Message });
            }
        }
    }
}