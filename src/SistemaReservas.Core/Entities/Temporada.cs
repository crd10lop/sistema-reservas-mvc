using System.ComponentModel.DataAnnotations;
using SistemaReservas.Core.Enums;

namespace SistemaReservas.Core.Entities;

public class Temporada
{
    public int Id { get; set; }

    [Required]
    [MaxLength(100)]
    public string Nombre { get; set; } = string.Empty;

    public TipoTemporada TipoTemporada { get; set; }

    public DateTime FechaInicio { get; set; }

    public DateTime FechaFin { get; set; }

    public int Año { get; set; }

    [MaxLength(250)]
    public string? Descripcion { get; set; }

    public bool EstaActiva { get; set; } = true;

    public ICollection<Tarifa> Tarifas { get; set; } = new List<Tarifa>();
}
