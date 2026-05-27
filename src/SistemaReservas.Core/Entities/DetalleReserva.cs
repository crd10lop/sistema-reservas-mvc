using System.ComponentModel.DataAnnotations.Schema;

namespace SistemaReservas.Core.Entities;

public class DetalleReserva
{
    public int Id { get; set; }

    public int ReservaId { get; set; }

    public int AlojamientoId { get; set; }

    [Column(TypeName = "decimal(18,2)")]
    public decimal PrecioPorNoche { get; set; }

    public int NumeroNoches { get; set; }

    [Column(TypeName = "decimal(18,2)")]
    public decimal Subtotal { get; set; }

    public Reserva Reserva { get; set; } = null!;

    public Alojamiento Alojamiento { get; set; } = null!;
}
