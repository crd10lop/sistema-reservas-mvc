using MailKit.Net.Smtp;
using MailKit.Security;
using MimeKit;
using SistemaReservas.Core.Interfaces;

namespace SistemaReservas.Web.Services;

public class ServicioEmail : IServicioEmail
{
    private readonly IConfiguration _configuracion;

    public ServicioEmail(IConfiguration configuracion)
    {
        _configuracion = configuracion;
    }

    public async Task EnviarEmailAsync(string destinatario, string asunto, string mensajeHTML)
    {
        var email = new MimeMessage();
        email.From.Add(new MailboxAddress(
            _configuracion["ConfiguracionEmail:Remitente"],
            _configuracion["ConfiguracionEmail:Usuario"]!));

        email.To.Add(new MailboxAddress("", destinatario));
        email.Subject = asunto;

        var constructorCuerpo = new BodyBuilder { HtmlBody = mensajeHTML };
        email.Body = constructorCuerpo.ToMessageBody();

        using var clienteSmtp = new SmtpClient();
        await clienteSmtp.ConnectAsync(
            _configuracion["ConfiguracionEmail:ServidorSmtp"]!,
            int.Parse(_configuracion["ConfiguracionEmail:Puerto"]!),
            SecureSocketOptions.StartTls);

        await clienteSmtp.AuthenticateAsync(
            _configuracion["ConfiguracionEmail:Usuario"]!,
            _configuracion["ConfiguracionEmail:Clave"]!);

        await clienteSmtp.SendAsync(email);
        await clienteSmtp.DisconnectAsync(true);
    }
}
