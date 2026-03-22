using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace pruebatecnica.Models
{
    [Table("producto")]
    public class Producto
    {
        [Key]
        [Column("idproducto")]
        public int IdProducto { get; set; }

        [Column("sku")]
        public string? Sku { get; set; }

        [Column("nombre")]
        public string? Nombre { get; set; }

        [Column("precio")]
        public decimal Precio { get; set; }

        [Column("moneda")]
        public string? Moneda { get; set; }

        [Column("stock")]
        public int Stock { get; set; }
    }
}