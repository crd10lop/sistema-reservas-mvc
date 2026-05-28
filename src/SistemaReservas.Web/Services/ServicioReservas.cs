using SistemaReservas.Core.DTOs;
using SistemaReservas.Core.Entities;
using SistemaReservas.Core.Enums;
using SistemaReservas.Core.Interfaces;

namespace SistemaReservas.Web.Services;

public class ServicioReservas : IServicioReservas
{
    private readonly IDisponibilidadRepository _repositorioDisponibilidad;
    private readonly IReservaRepository _repositorioReserva;

    public ServicioReservas(IDisponibilidadRepository repositorioDisponibilidad, IReservaRepository repositorioReserva)
    {
        _repositorioDisponibilidad = repositorioDisponibilidad;
        _repositorioReserva = repositorioReserva;
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
            return null;

        return await _repositorioDisponibilidad.CalcularTotalReservaAsync(alojamientoId, numeroPersonas, fechaInicio, fechaFin, incluyeLavanderia);
    }

    public async Task<bool> CrearReservaAsync(
        int alojamientoId, int sedeId, string usuarioId,
        DateTime fechaInicio, DateTime fechaFin, int numeroPersonas, bool incluyeLavanderia)
    {
        var cotizacion = await CotizarReservaAsync(alojamientoId, numeroPersonas, fechaInicio, fechaFin, incluyeLavanderia);
        if (cotizacion == null) return false;

        var precioPorNoche = cotizacion.NumeroNoches > 0
            ? cotizacion.TotalAlojamiento / cotizacion.NumeroNoches
            : 0;

        var reserva = new Reserva
        {
            UsuarioId = usuarioId,
            SedeId = sedeId,
            FechaInicio = fechaInicio,
            FechaFin = fechaFin,
            NumeroPersonas = numeroPersonas,
            NumeroNoches = cotizacion.NumeroNoches,
            TotalAlojamiento = cotizacion.TotalAlojamiento,
            TotalServicios = cotizacion.TotalServicios,
            TotalReserva = cotizacion.TotalReserva,
            Estado = EstadoReserva.Pendiente,
            DetallesReserva = new List<DetalleReserva>
            {
                new DetalleReserva
                {
                    AlojamientoId = alojamientoId,
                    PrecioPorNoche = precioPorNoche,
                    NumeroNoches = cotizacion.NumeroNoches,
                    Subtotal = cotizacion.TotalAlojamiento
                }
            }
        };

        await _repositorioReserva.CrearAsync(reserva);
        return true;
    }

    public async Task<IEnumerable<Reserva>> ObtenerMisReservasAsync(string usuarioId)
    {
        return await _repositorioReserva.ObtenerPorUsuarioAsync(usuarioId);
    }
}
