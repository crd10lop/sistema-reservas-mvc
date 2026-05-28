using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using SistemaReservas.Core.Interfaces;
using SistemaReservas.Data.Identity;
using SistemaReservas.Web.Models;

namespace SistemaReservas.Web.Controllers;

[Authorize]
public class CuentaController : Controller
{
    private readonly UserManager<ApplicationUser> _gestorUsuarios;
    private readonly SignInManager<ApplicationUser> _gestorIniciosSesion;
    private readonly IServicioEmail _servicioEmail;

    public CuentaController(
        UserManager<ApplicationUser> gestorUsuarios,
        SignInManager<ApplicationUser> gestorIniciosSesion,
        IServicioEmail servicioEmail)
    {
        _gestorUsuarios = gestorUsuarios;
        _gestorIniciosSesion = gestorIniciosSesion;
        _servicioEmail = servicioEmail;
    }

    [AllowAnonymous]
    [HttpGet]
    public IActionResult Registrar() => View();

    [AllowAnonymous]
    [HttpPost]
    public async Task<IActionResult> Registrar(ModeloRegistro modelo)
    {
        if (ModelState.IsValid)
        {
            var usuario = new ApplicationUser
            {
                UserName = modelo.Correo,
                Email = modelo.Correo,
                NumeroDocumento = modelo.Documento,
                NombreCompleto = modelo.NombreCompleto,
                Celular = modelo.Celular,
                FechaNacimiento = modelo.FechaNacimiento
            };

            var resultado = await _gestorUsuarios.CreateAsync(usuario, modelo.Clave);

            if (resultado.Succeeded)
            {
                await _gestorIniciosSesion.SignInAsync(usuario, isPersistent: false);
                return RedirectToAction("Index", "Home");
            }

            foreach (var error in resultado.Errors)
                ModelState.AddModelError(string.Empty, error.Description);
        }
        return View(modelo);
    }

    [AllowAnonymous]
    [HttpGet]
    public IActionResult IniciarSesion() => View();

    [AllowAnonymous]
    [HttpPost]
    public async Task<IActionResult> IniciarSesion(ModeloLogin modelo)
    {
        if (ModelState.IsValid)
        {
            var resultado = await _gestorIniciosSesion.PasswordSignInAsync(
                modelo.Correo, modelo.Clave, modelo.Recordarme, lockoutOnFailure: false);

            if (resultado.Succeeded)
                return RedirectToAction("Index", "Home");

            ModelState.AddModelError(string.Empty, "Intento de inicio de sesión inválido.");
        }
        return View(modelo);
    }

    [HttpPost]
    public async Task<IActionResult> CerrarSesion()
    {
        await _gestorIniciosSesion.SignOutAsync();
        return RedirectToAction("Index", "Home");
    }

    [AllowAnonymous]
    [HttpGet]
    public IActionResult OlvidoClave() => View();

    [AllowAnonymous]
    [HttpPost]
    public async Task<IActionResult> OlvidoClave(ModeloRecuperarClave modelo)
    {
        if (ModelState.IsValid)
        {
            var usuario = await _gestorUsuarios.FindByEmailAsync(modelo.Correo);
            if (usuario != null)
            {
                var token = await _gestorUsuarios.GeneratePasswordResetTokenAsync(usuario);
                var enlaceRecuperacion = Url.Action("RestablecerClave", "Cuenta",
                    new { correo = usuario.Email, token }, Request.Scheme);

                var cuerpo = $"<p>Para restablecer tu contraseña, haz clic <a href='{enlaceRecuperacion}'>aquí</a>.</p>";
                await _servicioEmail.EnviarEmailAsync(modelo.Correo, "Restablecer Contraseña - FODUN", cuerpo);
            }
            return View("ConfirmacionOlvidoClave");
        }
        return View(modelo);
    }

    [AllowAnonymous]
    [HttpGet]
    public IActionResult RestablecerClave(string correo, string token)
    {
        if (correo == null || token == null) return BadRequest("Token o correo inválido.");
        return View(new ModeloRestablecerClave { Correo = correo, Token = token });
    }

    [AllowAnonymous]
    [HttpPost]
    public async Task<IActionResult> RestablecerClave(ModeloRestablecerClave modelo)
    {
        if (!ModelState.IsValid) return View(modelo);

        var usuario = await _gestorUsuarios.FindByEmailAsync(modelo.Correo);
        if (usuario == null) return RedirectToAction("IniciarSesion", "Cuenta");

        var resultado = await _gestorUsuarios.ResetPasswordAsync(usuario, modelo.Token, modelo.NuevaClave);
        if (resultado.Succeeded) return RedirectToAction("IniciarSesion", "Cuenta");

        foreach (var error in resultado.Errors)
            ModelState.AddModelError(string.Empty, error.Description);

        return View(modelo);
    }
}
