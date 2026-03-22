using Microsoft.EntityFrameworkCore;
using pruebatecnica.Models;
using System.Collections.Generic;
using System.Reflection.Emit;

namespace pruebatecnica.Contexto
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public virtual DbSet<Persona> Personas { get; set; }
        public virtual DbSet<Usuario> Usuarios { get; set; }
        public virtual DbSet<Producto> Productos { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Usuario>()
                .HasOne(u => u.Persona)
                .WithOne(p => p.Usuario)
                .HasForeignKey<Usuario>(u => u.IdPersona);
        }
    }
}