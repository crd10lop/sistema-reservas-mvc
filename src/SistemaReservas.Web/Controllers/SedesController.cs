using Microsoft.AspNetCore.Mvc;
using SistemaReservas.Core.Interfaces;

namespace SistemaReservas.Web.Controllers;

public class SedesController : Controller
{
    private readonly ISedeRepository _repositorioSede;

    public SedesController(ISedeRepository repositorioSede)
    {
        _repositorioSede = repositorioSede;
    }

    public async Task<IActionResult> Index()
    {
        var sedes = await _repositorioSede.ObtenerTodasAsync();
        return View(sedes);
    }
}
