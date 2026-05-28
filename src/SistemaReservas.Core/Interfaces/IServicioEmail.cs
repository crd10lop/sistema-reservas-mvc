namespace SistemaReservas.Core.Interfaces;

public interface IServicioEmail
{
    Task EnviarEmailAsync(string destinatario, string asunto, string mensajeHTML);
}
