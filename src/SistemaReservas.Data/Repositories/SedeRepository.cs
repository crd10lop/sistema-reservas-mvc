using Microsoft.EntityFrameworkCore;
using SistemaReservas.Core.Entities;
using SistemaReservas.Core.Interfaces;
using SistemaReservas.Data.Context;

namespace SistemaReservas.Data.Repositories;

public class SedeRepository : ISedeRepository
{
    private readonly ApplicationDbContext _contexto;

    public SedeRepository(ApplicationDbContext contexto)
    {
        _contexto = contexto;
    }

    public async Task<IEnumerable<Sede>> ObtenerTodasAsync()
    {
        return await _contexto.Sedes.AsNoTracking().ToListAsync();
    }

    public async Task<Sede?> ObtenerPorIdAsync(int id)
    {
        return await _contexto.Sedes.FirstOrDefaultAsync(s => s.Id == id);
    }
}
