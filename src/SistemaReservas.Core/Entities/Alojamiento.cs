using System.ComponentModel.DataAnnotations;
using SistemaReservas.Core.Enums;

namespace SistemaReservas.Core.Entities;

public class Alojamiento
{
    public int Id { get; set; }

    public int SedeId { get; set; }

    [Required]
    [MaxLength(50)]
    public string Numero { get; set; } = string.Empty;

    [MaxLength(150)]
    public string Nombre { get; set; } = string.Empty;

    public TipoAlojamiento TipoAlojamiento { get; set; }

    public int CapacidadMaxima { get; set; }

    // Personas cubiertas por la tarifa base
    public int CapacidadIncluida { get; set; }

    public int NumeroHabitacionesInternas { get; set; }

    [MaxLength(500)]
    public string Descripcion { get; set; } = string.Empty;

    [MaxLength(500)]
    public string Caracteristicas { get; set; } = string.Empty;

    public bool EstaActivo { get; set; } = true;

    public Sede Sede { get; set; } = null!;

    public ICollection<Tarifa> Tarifas { get; set; } = new List<Tarifa>();

    public ICollection<DetalleReserva> DetallesReserva { get; set; } = new List<DetalleReserva>();
}
