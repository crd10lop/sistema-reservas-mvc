using SistemaReservas.Core.DTOs;
using SistemaReservas.Core.Entities;

namespace SistemaReservas.Core.Interfaces;

public interface ISedeRepository
{
    Task<IEnumerable<Sede>> ObtenerTodasAsync();
    Task<Sede?> ObtenerPorIdAsync(int id);
}

public interface IDisponibilidadRepository
{
    Task<IEnumerable<AlojamientoDisponibleDto>> ConsultarDisponibilidadAsync(int sedeId, DateTime fechaInicio, DateTime fechaFin, int numeroPersonas);
    Task<TotalReservaDto?> CalcularTotalReservaAsync(int alojamientoId, int numeroPersonas, DateTime fechaInicio, DateTime fechaFin, bool incluyeLavanderia);
}

public interface IServicioReservas
{
    Task<IEnumerable<AlojamientoDisponibleDto>> BuscarAlojamientosDisponiblesAsync(int sedeId, DateTime fechaInicio, DateTime fechaFin, int numeroPersonas);
    Task<TotalReservaDto?> CotizarReservaAsync(int alojamientoId, int numeroPersonas, DateTime fechaInicio, DateTime fechaFin, bool incluyeLavanderia);
}
