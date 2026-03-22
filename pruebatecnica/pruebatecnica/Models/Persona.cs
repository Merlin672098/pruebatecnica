using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace pruebatecnica.Models
{
    [Table("persona")]
    public class Persona
    {
        [Key]
        [Column("idpersona")]
        public int IdPersona { get; set; }

        [Column("personanombre")]
        public string? PersonaNombre { get; set; }

        [Column("personaap")]
        public string? PersonaAp { get; set; }

        [Column("personaci")]
        public string? PersonaCi { get; set; }

        [Column("idoficina")]
        public int? IdOficina { get; set; }

        [Column("idcargo")]
        public int? IdCargo { get; set; }

        [Column("personaimagen")]
        public string? PersonaImagen { get; set; }

        public virtual Usuario? Usuario { get; set; }
    }
}