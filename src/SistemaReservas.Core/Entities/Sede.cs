using System.ComponentModel.DataAnnotations;
using SistemaReservas.Core.Enums;

namespace SistemaReservas.Core.Entities;

public class Sede
{
    public int Id { get; set; }

    [Required]
    [MaxLength(100)]
    public string Nombre { get; set; } = string.Empty;

    public TipoSede TipoSede { get; set; }

    [Required]
    [MaxLength(100)]
    public string Ciudad { get; set; } = string.Empty;

    [MaxLength(100)]
    public string Departamento { get; set; } = string.Empty;

    [MaxLength(200)]
    public string Direccion { get; set; } = string.Empty;

    [MaxLength(1000)]
    public string Descripcion { get; set; } = string.Empty;

    public int CapacidadTotal { get; set; }

    [MaxLength(250)]
    public string? ImagenUrl { get; set; }

    public bool EstaActiva { get; set; } = true;

    public DateTime FechaCreacion { get; set; } = DateTime.UtcNow;

    public ICollection<Alojamiento> Alojamientos { get; set; } = new List<Alojamiento>();
}
