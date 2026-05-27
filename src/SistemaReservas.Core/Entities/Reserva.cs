using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using SistemaReservas.Core.Enums;

namespace SistemaReservas.Core.Entities;

public class Reserva
{
    public int Id { get; set; }

    [Required]
    public string UsuarioId { get; set; } = string.Empty;

    public int SedeId { get; set; }

    public DateTime FechaCreacion { get; set; } = DateTime.UtcNow;

    public DateTime FechaInicio { get; set; }

    public DateTime FechaFin { get; set; }

    public int NumeroPersonas { get; set; }

    public int NumeroNoches { get; set; }

    [Column(TypeName = "decimal(18,2)")]
    public decimal TotalAlojamiento { get; set; }

    [Column(TypeName = "decimal(18,2)")]
    public decimal TotalServicios { get; set; } = 0;

    [Column(TypeName = "decimal(18,2)")]
    public decimal TotalReserva { get; set; }

    public EstadoReserva Estado { get; set; } = EstadoReserva.Pendiente;

    [MaxLength(500)]
    public string? Observaciones { get; set; }

    public Sede Sede { get; set; } = null!;

    public ICollection<DetalleReserva> DetallesReserva { get; set; } = new List<DetalleReserva>();

    public ICollection<ReservaServicio> ServiciosReserva { get; set; } = new List<ReservaServicio>();
}
