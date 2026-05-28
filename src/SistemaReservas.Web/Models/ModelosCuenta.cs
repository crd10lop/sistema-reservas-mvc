using System.ComponentModel.DataAnnotations;

namespace SistemaReservas.Web.Models;

public class ModeloRegistro
{
    [Required(ErrorMessage = "El documento es obligatorio")]
    public string Documento { get; set; } = string.Empty;

    [Required(ErrorMessage = "El nombre completo es obligatorio")]
    public string NombreCompleto { get; set; } = string.Empty;

    [Required(ErrorMessage = "El correo es obligatorio")]
    [EmailAddress(ErrorMessage = "Formato de correo inválido")]
    public string Correo { get; set; } = string.Empty;

    [Required(ErrorMessage = "El celular es obligatorio")]
    public string Celular { get; set; } = string.Empty;

    [Required(ErrorMessage = "La contraseña es obligatoria")]
    [DataType(DataType.Password)]
    public string Clave { get; set; } = string.Empty;

    [DataType(DataType.Date)]
    public DateTime FechaNacimiento { get; set; }
}

public class ModeloLogin
{
    [Required(ErrorMessage = "El correo es obligatorio")]
    [EmailAddress]
    public string Correo { get; set; } = string.Empty;

    [Required(ErrorMessage = "La contraseña es obligatoria")]
    [DataType(DataType.Password)]
    public string Clave { get; set; } = string.Empty;

    public bool Recordarme { get; set; }
}

public class ModeloRecuperarClave
{
    [Required(ErrorMessage = "El correo es obligatorio")]
    [EmailAddress]
    public string Correo { get; set; } = string.Empty;
}

public class ModeloRestablecerClave
{
    [Required]
    public string Token { get; set; } = string.Empty;

    [Required]
    [EmailAddress]
    public string Correo { get; set; } = string.Empty;

    [Required(ErrorMessage = "La nueva contraseña es obligatoria")]
    [DataType(DataType.Password)]
    public string NuevaClave { get; set; } = string.Empty;

    [DataType(DataType.Password)]
    [Compare("NuevaClave", ErrorMessage = "Las contraseñas no coinciden.")]
    public string ConfirmarClave { get; set; } = string.Empty;
}
