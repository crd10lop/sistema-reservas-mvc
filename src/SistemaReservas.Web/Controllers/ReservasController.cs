using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using SistemaReservas.Core.Interfaces;
using SistemaReservas.Data.Identity;
using SistemaReservas.Web.Models;

namespace SistemaReservas.Web.Controllers;

[Authorize]
public class ReservasController : Controller
{
    private readonly IServicioReservas _servicioReservas;
    private readonly ISedeRepository _repositorioSede;
    private readonly UserManager<ApplicationUser> _gestorUsuarios;

    public ReservasController(
        IServicioReservas servicioReservas,
        ISedeRepository repositorioSede,
        UserManager<ApplicationUser> gestorUsuarios)
    {
        _servicioReservas = servicioReservas;
        _repositorioSede = repositorioSede;
        _gestorUsuarios = gestorUsuarios;
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
        if (!ModelState.IsValid || modelo.FechaFin <= modelo.FechaInicio)
        {
            if (modelo.FechaFin <= modelo.FechaInicio)
                ModelState.AddModelError(string.Empty, "La fecha de salida debe ser mayor a la fecha de ingreso.");
            modelo.SedesDisponibles = await _repositorioSede.ObtenerTodasAsync();
            return View(modelo);
        }

        var disponibles = await _servicioReservas.BuscarAlojamientosDisponiblesAsync(
            modelo.SedeId, modelo.FechaInicio, modelo.FechaFin, modelo.NumeroPersonas);

        return View("Resultados", new ResultadosDisponibilidadViewModel
        {
            ParametrosBusqueda = modelo,
            Alojamientos = disponibles
        });
    }

    [HttpGet]
    public async Task<IActionResult> Confirmar(
        int alojamientoId, int sedeId, DateTime fechaInicio, DateTime fechaFin,
        int numeroPersonas, bool incluyeLavanderia = false)
    {
        var cotizacion = await _servicioReservas.CotizarReservaAsync(
            alojamientoId, numeroPersonas, fechaInicio, fechaFin, incluyeLavanderia);

        if (cotizacion == null) return RedirectToAction(nameof(BuscarDisponibilidad));

        var modelo = new ConfirmarReservaViewModel
        {
            AlojamientoId = alojamientoId,
            SedeId = sedeId,
            FechaInicio = fechaInicio,
            FechaFin = fechaFin,
            NumeroPersonas = numeroPersonas,
            IncluyeLavanderia = incluyeLavanderia,
            TotalAlojamiento = cotizacion.TotalAlojamiento,
            TotalServicios = cotizacion.TotalServicios,
            TotalReserva = cotizacion.TotalReserva
        };
        return View(modelo);
    }

    [HttpPost]
    public async Task<IActionResult> ProcesarReserva(ConfirmarReservaViewModel modelo)
    {
        var usuarioId = _gestorUsuarios.GetUserId(User);
        if (usuarioId == null) return RedirectToAction("IniciarSesion", "Cuenta");

        var exito = await _servicioReservas.CrearReservaAsync(
            modelo.AlojamientoId, modelo.SedeId, usuarioId,
            modelo.FechaInicio, modelo.FechaFin, modelo.NumeroPersonas, modelo.IncluyeLavanderia);

        if (exito) return RedirectToAction(nameof(MisReservas));

        ModelState.AddModelError("", "Ocurrió un error al procesar su reserva.");
        return View("Confirmar", modelo);
    }

    [HttpGet]
    public async Task<IActionResult> MisReservas()
    {
        var usuarioId = _gestorUsuarios.GetUserId(User);
        if (usuarioId == null) return RedirectToAction("IniciarSesion", "Cuenta");

        var reservas = await _servicioReservas.ObtenerMisReservasAsync(usuarioId);
        return View(reservas);
    }
}
