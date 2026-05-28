using SistemaReservas.Core.DTOs;
using SistemaReservas.Core.Interfaces;

namespace SistemaReservas.Web.Services;

public class ServicioReservas : IServicioReservas
{
    private readonly IDisponibilidadRepository _repositorioDisponibilidad;

    public ServicioReservas(IDisponibilidadRepository repositorioDisponibilidad)
    {
        _repositorioDisponibilidad = repositorioDisponibilidad;
    }

    public async Task<IEnumerable<AlojamientoDisponibleDto>> BuscarAlojamientosDisponiblesAsync(
        int sedeId, DateTime fechaInicio, DateTime fechaFin, int numeroPersonas)
    {
        if (fechaInicio < DateTime.Today || fechaFin <= fechaInicio)
            throw new ArgumentException("Fechas inválidas para la reserva.");

        if (numeroPersonas <= 0)
            throw new ArgumentException("El número de personas debe ser mayor a cero.");

        return await _repositorioDisponibilidad.ConsultarDisponibilidadAsync(sedeId, fechaInicio, fechaFin, numeroPersonas);
    }

    public async Task<TotalReservaDto?> CotizarReservaAsync(
        int alojamientoId, int numeroPersonas, DateTime fechaInicio, DateTime fechaFin, bool incluyeLavanderia)
    {
        if (fechaInicio < DateTime.Today || fechaFin <= fechaInicio)
            throw new ArgumentException("Fechas inválidas para la cotización.");

        return await _repositorioDisponibilidad.CalcularTotalReservaAsync(alojamientoId, numeroPersonas, fechaInicio, fechaFin, incluyeLavanderia);
    }
}
