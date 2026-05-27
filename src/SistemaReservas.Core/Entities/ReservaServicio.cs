using System.ComponentModel.DataAnnotations.Schema;

namespace SistemaReservas.Core.Entities;

public class ReservaServicio
{
    public int Id { get; set; }

    public int ReservaId { get; set; }

    public int ServicioId { get; set; }

    public int Cantidad { get; set; }

    [Column(TypeName = "decimal(18,2)")]
    public decimal PrecioUnitario { get; set; }

    [Column(TypeName = "decimal(18,2)")]
    public decimal Subtotal { get; set; }

    public Reserva Reserva { get; set; } = null!;

    public Servicio Servicio { get; set; } = null!;
}
