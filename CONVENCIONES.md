# Sistema de Reservas - Documentación del Proyecto

## Resumen
Aplicación web para gestionar reservas de sedes recreativas y apartamentos. Arquitectura en capas con .NET 8, EF Core, ASP.NET Core Identity, SQL Server.

## Stack Tecnológico
- **.NET 8** (C#)
- **ASP.NET Core MVC 8**
- **Entity Framework Core 8** (SQL Server)
- **ASP.NET Core Identity 8**
- **SQL Server** (en Docker)
- **Bootstrap 5** (frontend)
- **MailKit** (notificaciones por email)
- **Serilog** (logging)
- **xUnit** (testing)
- **Swashbuckle.AspNetCore** (API documentation)

## Convenciones de Código

### Nomenclatura
- Todo en **español**: clases, métodos, propiedades, variables, enums
  - ✅ `ReservaService`, `calcularTotal()`, `numeroPersonas`, `EstadoReserva`
  - ❌ `ReservationService`, `calculateTotal()`, `numberOfPersons`

### Namespaces
```
SistemaReservas.{Capa}
- SistemaReservas.Core       (entidades, interfaces, servicios)
- SistemaReservas.Data       (contexto EF, repositorios)
- SistemaReservas.Web        (controllers, views, DTOs)
```

### Comentarios
- Solo donde aporten valor: por qué, no qué
- Cortos y en español
- ❌ No agregar comentarios obvios: `// constructor`, `// propiedades`
- ❌ No incluir comentarios autogenerados tipo "This file contains..."

### Formato de Código
- **Indentación**: 4 espacios
- **Saltos de línea**: LF
- **Using statements**: ordenados alfabéticamente
- **Preferencias**: `var` cuando el tipo es obvio

## Estructura de Capas

### Core (Dominio)
- Entidades del negocio
- Interfaces de servicios y repositorios
- Lógica de negocio
- Enums y value objects

### Data (Persistencia)
- DbContext de EF Core
- Migraciones
- Configuraciones de entidades
- Implementaciones de repositorios

### Web (Presentación)
- Controllers (ASP.NET Core MVC)
- Views (Razor)
- DTOs para entrada/salida
- Configuración de inyección de dependencias
- Autenticación/autorización
- Notificaciones

## Primeros Pasos

1. `cd src && dotnet build`
2. Configurar SQL Server en Docker (connection string en appsettings)
3. `dotnet ef migrations add Initial --project SistemaReservas.Data --startup-project SistemaReservas.Web`
4. `dotnet ef database update --startup-project SistemaReservas.Web`
