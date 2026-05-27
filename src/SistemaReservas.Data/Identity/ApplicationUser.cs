using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Identity;

namespace SistemaReservas.Data.Identity;

public class ApplicationUser : IdentityUser
{
    [Required]
    [MaxLength(20)]
    public string NumeroDocumento { get; set; } = string.Empty;

    [Required]
    [MaxLength(200)]
    public string NombreCompleto { get; set; } = string.Empty;

    public DateTime FechaNacimiento { get; set; }

    [MaxLength(20)]
    public string? Celular { get; set; }

    [MaxLength(100)]
    public string Departamento { get; set; } = string.Empty;

    [MaxLength(100)]
    public string Municipio { get; set; } = string.Empty;

    [MaxLength(150)]
    public string Barrio { get; set; } = string.Empty;

    [MaxLength(250)]
    public string DireccionResidencia { get; set; } = string.Empty;

    [MaxLength(20)]
    public string? TelefonoResidencia { get; set; }

    public bool AutorizaEnvioCorreo { get; set; } = false;

    public bool AutorizaEnvioCelular { get; set; } = false;

    public DateTime FechaRegistro { get; set; } = DateTime.UtcNow;

    public bool EstaActivo { get; set; } = true;
}
