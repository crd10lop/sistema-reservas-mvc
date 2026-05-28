using Microsoft.EntityFrameworkCore;
using SistemaReservas.Core.Entities;
using SistemaReservas.Core.Interfaces;
using SistemaReservas.Data.Context;

namespace SistemaReservas.Data.Repositories;

public class ReservaRepository : IReservaRepository
{
    private readonly ApplicationDbContext _contexto;

    public ReservaRepository(ApplicationDbContext contexto)
    {
        _contexto = contexto;
    }

    public async Task<Reserva> CrearAsync(Reserva reserva)
    {
        _contexto.Reservas.Add(reserva);
        await _contexto.SaveChangesAsync();
        return reserva;
    }

    public async Task<IEnumerable<Reserva>> ObtenerPorUsuarioAsync(string usuarioId)
    {
        return await _contexto.Reservas
            .Include(r => r.DetallesReserva)
                .ThenInclude(d => d.Alojamiento)
                    .ThenInclude(a => a.Sede)
            .Where(r => r.UsuarioId == usuarioId)
            .OrderByDescending(r => r.FechaInicio)
            .AsNoTracking()
            .ToListAsync();
    }
}
