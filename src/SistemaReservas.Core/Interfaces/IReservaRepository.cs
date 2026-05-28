using SistemaReservas.Core.Entities;

namespace SistemaReservas.Core.Interfaces;

public interface IReservaRepository
{
    Task<Reserva> CrearAsync(Reserva reserva);
    Task<IEnumerable<Reserva>> ObtenerPorUsuarioAsync(string usuarioId);
}
