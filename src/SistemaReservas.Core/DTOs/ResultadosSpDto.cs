using SistemaReservas.Core.Enums;

namespace SistemaReservas.Core.DTOs;

public class AlojamientoDisponibleDto
{
    public int Id { get; set; }
    public string Numero { get; set; } = string.Empty;
    public string Nombre { get; set; } = string.Empty;
    public TipoAlojamiento TipoAlojamiento { get; set; }
    public int CapacidadMaxima { get; set; }
    public int CapacidadIncluida { get; set; }
    public string Caracteristicas { get; set; } = string.Empty;
    public string NombreSede { get; set; } = string.Empty;
}

public class TotalReservaDto
{
    public decimal TotalAlojamiento { get; set; }
    public decimal TotalServicios { get; set; }
    public decimal TotalReserva { get; set; }
    public int NumeroNoches { get; set; }
}
