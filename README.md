# Sistema de Reservas FODUN - Prueba Técnica

Aplicación web desarrollada en ASP.NET Core 8 MVC utilizando Clean Architecture, Entity Framework Core y SQL Server, cumpliendo con los requerimientos técnicos establecidos.

## Tecnologías Utilizadas

- .NET 8 (C#)
- ASP.NET Core MVC
- Entity Framework Core (Code-First)
- ASP.NET Core Identity (Autenticación)
- MailKit (SMTP para recuperación de clave)
- SQL Server 2022 (Dockerizado)
- Bootstrap 5, Razor Views
- Stored Procedures para lógica de negocio

## Instrucciones de Ejecución (Docker)

El proyecto está completamente orquestado con Docker Compose. Asegúrese de tener Docker instalado y los puertos **1433** y **8080** disponibles.

### 1. Clonar el repositorio

```bash
git clone https://github.com/crd10lop/sistema-reservas-mvc.git
cd sistema-reservas-mvc
```

### 2. Levantar los servicios

```bash
docker compose up --build -d
```

La aplicación aplica automáticamente las migraciones de Entity Framework al iniciar.

### 3. Inyectar datos de prueba y Stored Procedures

Una vez que los contenedores estén corriendo (espere ~30 segundos para SQL Server):

```bash
docker cp database/02_SeedData.sql sistema-reservas-db:/tmp/02_SeedData.sql
docker cp database/03_StoredProcedures.sql sistema-reservas-db:/tmp/03_StoredProcedures.sql

docker exec -i sistema-reservas-db /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Reservas@2024#Xk9!' -C -d SistemaReservas -i /tmp/02_SeedData.sql
docker exec -i sistema-reservas-db /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Reservas@2024#Xk9!' -C -d SistemaReservas -i /tmp/03_StoredProcedures.sql
```

### 4. Acceder a la aplicación

Abra su navegador en: **http://localhost:8080**

## Arquitectura

La aplicación respeta la separación en capas:

| Capa | Proyecto | Responsabilidad |
|---|---|---|
| Core | `SistemaReservas.Core` | Entidades, interfaces, enums |
| Data | `SistemaReservas.Data` | DbContext, repositorios, migraciones |
| Web | `SistemaReservas.Web` | Controladores, vistas Razor, servicios, DI |

La cotización y disponibilidad de reservas son gestionadas por **Stored Procedures** que calculan dinámicamente el precio según temporada, personas adicionales y tarifas especiales de días de semana.
