using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace pruebatecnica.Models
{
    [Table("usuario")]
    public class Usuario
    {
        [Key]
        [Column("idusuario")]
        public int IdUsuario { get; set; }

        [Column("usuarionombre")]
        public string? UsuarioNombre { get; set; }

        [Column("usuarioclave")]
        public string? UsuarioClave { get; set; }

        [Column("usuarioemail")]
        public string? UsuarioEmail { get; set; }

        [Column("idpersona")]
        public int? IdPersona { get; set; }

        [Column("usuariocondicion")]
        public short? UsuarioCondicion { get; set; }

        [Column("idrol")]
        public int? IdRol { get; set; }


        [Column("firebaseuid")]
        public string? FirebaseUid { get; set; }

        [ForeignKey("IdPersona")]
        public virtual Persona? Persona { get; set; }
    }
}