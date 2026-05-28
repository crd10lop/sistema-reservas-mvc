using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using SistemaReservas.Core.Entities;
using SistemaReservas.Data.Identity;

namespace SistemaReservas.Data.Context;

public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }

    public DbSet<Sede> Sedes => Set<Sede>();
    public DbSet<Alojamiento> Alojamientos => Set<Alojamiento>();
    public DbSet<Temporada> Temporadas => Set<Temporada>();
    public DbSet<Tarifa> Tarifas => Set<Tarifa>();
    public DbSet<Servicio> Servicios => Set<Servicio>();
    public DbSet<Reserva> Reservas => Set<Reserva>();
    public DbSet<DetalleReserva> DetallesReserva => Set<DetalleReserva>();
    public DbSet<ReservaServicio> ReservasServicios => Set<ReservaServicio>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Sede
        modelBuilder.Entity<Sede>()
            .HasMany(s => s.Alojamientos)
            .WithOne(a => a.Sede)
            .HasForeignKey(a => a.SedeId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Sede>()
            .HasMany<Reserva>()
            .WithOne(r => r.Sede)
            .HasForeignKey(r => r.SedeId)
            .OnDelete(DeleteBehavior.Restrict);

        // Alojamiento
        modelBuilder.Entity<Alojamiento>()
            .HasMany(a => a.Tarifas)
            .WithOne(t => t.Alojamiento)
            .HasForeignKey(t => t.AlojamientoId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Alojamiento>()
            .HasMany(a => a.DetallesReserva)
            .WithOne(d => d.Alojamiento)
            .HasForeignKey(d => d.AlojamientoId)
            .OnDelete(DeleteBehavior.Restrict);

        // Temporada
        modelBuilder.Entity<Temporada>()
            .HasMany(t => t.Tarifas)
            .WithOne(ta => ta.Temporada)
            .HasForeignKey(ta => ta.TemporadaId)
            .OnDelete(DeleteBehavior.Restrict);

        // Reserva
        modelBuilder.Entity<Reserva>()
            .HasMany(r => r.DetallesReserva)
            .WithOne(d => d.Reserva)
            .HasForeignKey(d => d.ReservaId)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<Reserva>()
            .HasMany(r => r.ServiciosReserva)
            .WithOne(rs => rs.Reserva)
            .HasForeignKey(rs => rs.ReservaId)
            .OnDelete(DeleteBehavior.Cascade);

        // Servicio
        modelBuilder.Entity<Servicio>()
            .HasMany(s => s.ReservasServicios)
            .WithOne(rs => rs.Servicio)
            .HasForeignKey(rs => rs.ServicioId)
            .OnDelete(DeleteBehavior.Restrict);

        // FK a ApplicationUser sin propiedad de navegación
        modelBuilder.Entity<Reserva>()
            .HasOne<ApplicationUser>()
            .WithMany()
            .HasForeignKey(r => r.UsuarioId)
            .OnDelete(DeleteBehavior.Restrict);

        // Índices
        modelBuilder.Entity<Reserva>().HasIndex(r => r.UsuarioId);
        modelBuilder.Entity<Reserva>().HasIndex(r => r.FechaInicio);
        modelBuilder.Entity<Reserva>().HasIndex(r => r.FechaFin);
        modelBuilder.Entity<Reserva>().HasIndex(r => r.SedeId);

        modelBuilder.Entity<DetalleReserva>().HasIndex(d => d.AlojamientoId);
        modelBuilder.Entity<DetalleReserva>().HasIndex(d => d.ReservaId);

        modelBuilder.Entity<Tarifa>().HasIndex(t => t.AlojamientoId);
        modelBuilder.Entity<Tarifa>().HasIndex(t => t.TemporadaId);

        modelBuilder.Entity<Temporada>().HasIndex(t => t.FechaInicio);
        modelBuilder.Entity<Temporada>().HasIndex(t => t.FechaFin);

        modelBuilder.Entity<ApplicationUser>()
            .HasIndex(u => u.NumeroDocumento)
            .IsUnique();
    }
}
