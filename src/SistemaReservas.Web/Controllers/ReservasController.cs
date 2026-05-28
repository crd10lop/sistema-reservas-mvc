using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SistemaReservas.Core.Interfaces;
using SistemaReservas.Web.Models;

namespace SistemaReservas.Web.Controllers;

[Authorize]
public class ReservasController : Controller
{
    private readonly IServicioReservas _servicioReservas;
    private readonly ISedeRepository _repositorioSede;

    public ReservasController(IServicioReservas servicioReservas, ISedeRepository repositorioSede)
    {
        _servicioReservas = servicioReservas;
        _repositorioSede = repositorioSede;
    }

    [HttpGet]
    public async Task<IActionResult> BuscarDisponibilidad()
    {
        var modelo = new BuscarDisponibilidadViewModel
        {
            SedesDisponibles = await _repositorioSede.ObtenerTodasAsync()
        };
        return View(modelo);
    }

    [HttpPost]
    public async Task<IActionResult> BuscarDisponibilidad(BuscarDisponibilidadViewModel modelo)
    {
        if (!ModelState.IsValid)
        {
            modelo.SedesDisponibles = await _repositorioSede.ObtenerTodasAsync();
            return View(modelo);
        }

        if (modelo.FechaFin <= modelo.FechaInicio)
        {
            ModelState.AddModelError(string.Empty, "La fecha de salida debe ser mayor a la fecha de ingreso.");
            modelo.SedesDisponibles = await _repositorioSede.ObtenerTodasAsync();
            return View(modelo);
        }

        var disponibles = await _servicioReservas.BuscarAlojamientosDisponiblesAsync(
            modelo.SedeId, modelo.FechaInicio, modelo.FechaFin, modelo.NumeroPersonas);

        var resultados = new ResultadosDisponibilidadViewModel
        {
            ParametrosBusqueda = modelo,
            Alojamientos = disponibles
        };

        return View("Resultados", resultados);
    }
}
