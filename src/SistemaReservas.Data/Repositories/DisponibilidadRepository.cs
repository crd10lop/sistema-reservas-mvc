using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using SistemaReservas.Core.DTOs;
using SistemaReservas.Core.Interfaces;
using SistemaReservas.Data.Context;

namespace SistemaReservas.Data.Repositories;

public class DisponibilidadRepository : IDisponibilidadRepository
{
    private readonly ApplicationDbContext _contexto;

    public DisponibilidadRepository(ApplicationDbContext contexto)
    {
        _contexto = contexto;
    }

    public async Task<IEnumerable<AlojamientoDisponibleDto>> ConsultarDisponibilidadAsync(
        int sedeId, DateTime fechaInicio, DateTime fechaFin, int numeroPersonas)
    {
        var pSedeId = new SqlParameter("@SedeId", sedeId);
        var pFechaInicio = new SqlParameter("@FechaInicio", fechaInicio);
        var pFechaFin = new SqlParameter("@FechaFin", fechaFin);
        var pNumeroPersonas = new SqlParameter("@NumeroPersonas", numeroPersonas);

        const string sql = "EXEC sp_HabitacionesDisponibles_PorFechaYPersonas @SedeId, @FechaInicio, @FechaFin, @NumeroPersonas";

        return await _contexto.Database
            .SqlQueryRaw<AlojamientoDisponibleDto>(sql, pSedeId, pFechaInicio, pFechaFin, pNumeroPersonas)
            .ToListAsync();
    }

    public async Task<TotalReservaDto?> CalcularTotalReservaAsync(
        int alojamientoId, int numeroPersonas, DateTime fechaInicio, DateTime fechaFin, bool incluyeLavanderia)
    {
        var pAlojamientoId = new SqlParameter("@AlojamientoId", alojamientoId);
        var pNumeroPersonas = new SqlParameter("@NumeroPersonas", numeroPersonas);
        var pFechaInicio = new SqlParameter("@FechaInicio", fechaInicio);
        var pFechaFin = new SqlParameter("@FechaFin", fechaFin);
        var pIncluyeLavanderia = new SqlParameter("@IncluyeLavanderia", incluyeLavanderia);

        const string sql = "EXEC sp_CalcularTotalReserva @AlojamientoId, @NumeroPersonas, @FechaInicio, @FechaFin, @IncluyeLavanderia";

        var resultado = await _contexto.Database
            .SqlQueryRaw<TotalReservaDto>(sql, pAlojamientoId, pNumeroPersonas, pFechaInicio, pFechaFin, pIncluyeLavanderia)
            .ToListAsync();

        return resultado.FirstOrDefault();
    }
}
