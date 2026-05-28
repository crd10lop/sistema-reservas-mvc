using System.ComponentModel.DataAnnotations;
using SistemaReservas.Core.DTOs;
using SistemaReservas.Core.Entities;

namespace SistemaReservas.Web.Models;

public class BuscarDisponibilidadViewModel
{
    [Required(ErrorMessage = "Seleccione una sede")]
    [Display(Name = "Sede")]
    public int SedeId { get; set; }

    [Required]
    [Display(Name = "Fecha de Ingreso")]
    [DataType(DataType.Date)]
    public DateTime FechaInicio { get; set; } = DateTime.Today.AddDays(1);

    [Required]
    [Display(Name = "Fecha de Salida")]
    [DataType(DataType.Date)]
    public DateTime FechaFin { get; set; } = DateTime.Today.AddDays(3);

    [Required]
    [Range(1, 20, ErrorMessage = "El número de personas debe ser entre 1 y 20")]
    [Display(Name = "Número de Personas")]
    public int NumeroPersonas { get; set; } = 2;

    public IEnumerable<Sede>? SedesDisponibles { get; set; }
}

public class ResultadosDisponibilidadViewModel
{
    public BuscarDisponibilidadViewModel ParametrosBusqueda { get; set; } = new();
    public IEnumerable<AlojamientoDisponibleDto> Alojamientos { get; set; } = new List<AlojamientoDisponibleDto>();
}

public class ConfirmarReservaViewModel
{
    public int AlojamientoId { get; set; }
    public int SedeId { get; set; }
    public DateTime FechaInicio { get; set; }
    public DateTime FechaFin { get; set; }
    public int NumeroPersonas { get; set; }
    public bool IncluyeLavanderia { get; set; }

    [Display(Name = "Costo Alojamiento")]
    public decimal TotalAlojamiento { get; set; }

    [Display(Name = "Costo Servicios")]
    public decimal TotalServicios { get; set; }

    [Display(Name = "Total a Pagar")]
    public decimal TotalReserva { get; set; }
}
