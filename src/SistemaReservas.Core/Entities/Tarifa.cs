using System.ComponentModel.DataAnnotations.Schema;

namespace SistemaReservas.Core.Entities;

public class Tarifa
{
    public int Id { get; set; }

    public int AlojamientoId { get; set; }

    public int TemporadaId { get; set; }

    [Column(TypeName = "decimal(18,2)")]
    public decimal PrecioBase { get; set; }

    public int CapacidadIncluida { get; set; }

    [Column(TypeName = "decimal(18,2)")]
    public decimal PrecioPersonaAdicional { get; set; } = 0;

    // Tarifa aplicable de lunes a jueves en sedes recreativas
    [Column(TypeName = "decimal(18,2)")]
    public decimal? PrecioDiaEspecial { get; set; }

    public DateTime FechaInicioVigencia { get; set; }

    public DateTime? FechaFinVigencia { get; set; }

    public bool EstaActiva { get; set; } = true;

    public Alojamiento Alojamiento { get; set; } = null!;

    public Temporada Temporada { get; set; } = null!;
}
