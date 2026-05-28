USE SistemaReservas;
GO

SET NOCOUNT ON;

-- ==========================================================
-- SP 1: sp_HabitacionesDisponibles_PorFecha
-- Retorna alojamientos sin solapamiento en el rango de fechas
-- ==========================================================

DROP PROCEDURE IF EXISTS [dbo].[sp_HabitacionesDisponibles_PorFecha];
GO

CREATE PROCEDURE [dbo].[sp_HabitacionesDisponibles_PorFecha]
    @SedeId INT,
    @FechaInicio DATETIME2,
    @FechaFin DATETIME2
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT DISTINCT
            a.Id,
            a.Numero,
            a.Nombre,
            a.TipoAlojamiento,
            a.CapacidadMaxima,
            a.CapacidadIncluida,
            a.Caracteristicas,
            s.Nombre AS NombreSede
        FROM Alojamientos a
        INNER JOIN Sedes s ON s.Id = a.SedeId
        WHERE a.SedeId = @SedeId
            AND a.EstaActivo = 1
            AND a.Id NOT IN (
                SELECT DISTINCT dr.AlojamientoId
                FROM DetallesReserva dr
                INNER JOIN Reservas r ON r.Id = dr.ReservaId
                WHERE r.Estado IN (0, 1, 2, 3)
                    AND (r.FechaInicio < @FechaFin AND r.FechaFin > @FechaInicio)
            )
        ORDER BY a.Numero;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

-- ==========================================================
-- SP 2: sp_HabitacionesDisponibles_PorFechaYPersonas
-- Igual que SP1 pero filtra por capacidad
-- ==========================================================

DROP PROCEDURE IF EXISTS [dbo].[sp_HabitacionesDisponibles_PorFechaYPersonas];
GO

CREATE PROCEDURE [dbo].[sp_HabitacionesDisponibles_PorFechaYPersonas]
    @SedeId INT,
    @FechaInicio DATETIME2,
    @FechaFin DATETIME2,
    @NumeroPersonas INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT DISTINCT
            a.Id,
            a.Numero,
            a.Nombre,
            a.TipoAlojamiento,
            a.CapacidadMaxima,
            a.CapacidadIncluida,
            a.Caracteristicas,
            s.Nombre AS NombreSede
        FROM Alojamientos a
        INNER JOIN Sedes s ON s.Id = a.SedeId
        WHERE a.SedeId = @SedeId
            AND a.EstaActivo = 1
            AND a.CapacidadMaxima >= @NumeroPersonas
            AND a.Id NOT IN (
                SELECT DISTINCT dr.AlojamientoId
                FROM DetallesReserva dr
                INNER JOIN Reservas r ON r.Id = dr.ReservaId
                WHERE r.Estado IN (0, 1, 2, 3)
                    AND (r.FechaInicio < @FechaFin AND r.FechaFin > @FechaInicio)
            )
        ORDER BY a.Numero;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

-- ==========================================================
-- SP 3: sp_ConsultarTarifas
-- Itera noche por noche y retorna desglose de precios
-- ==========================================================

DROP PROCEDURE IF EXISTS [dbo].[sp_ConsultarTarifas];
GO

CREATE PROCEDURE [dbo].[sp_ConsultarTarifas]
    @AlojamientoId INT,
    @FechaInicio DATETIME2,
    @FechaFin DATETIME2,
    @NumeroPersonas INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @FechaActual DATETIME2 = @FechaInicio;
        DECLARE @NumeroNoches INT = DATEDIFF(DAY, @FechaInicio, @FechaFin);

        DECLARE @ResultadoTarifas TABLE (
            Fecha DATE,
            PrecioBase DECIMAL(18,2),
            PersonasAdicionales INT,
            PrecioPersonasAdicionales DECIMAL(18,2),
            PrecioAjustado DECIMAL(18,2),
            NombreTemporada NVARCHAR(100),
            EsCompra BIT
        );

        WHILE @FechaActual < @FechaFin
        BEGIN
            DECLARE @TarifaId INT;
            DECLARE @PrecioBase DECIMAL(18,2);
            DECLARE @CapacidadIncluida INT;
            DECLARE @PrecioPersonaAdicional DECIMAL(18,2);
            DECLARE @PrecioDiaEspecial DECIMAL(18,2);
            DECLARE @TemporadaNombre NVARCHAR(100);
            DECLARE @PersonasAdicionales INT = 0;
            DECLARE @PrecioPersonasAdicionales DECIMAL(18,2) = 0;
            DECLARE @PrecioAjustado DECIMAL(18,2);
            DECLARE @DiaActual INT = DATEPART(WEEKDAY, @FechaActual);

            SELECT TOP 1
                @TarifaId = t.Id,
                @PrecioBase = t.PrecioBase,
                @CapacidadIncluida = t.CapacidadIncluida,
                @PrecioPersonaAdicional = t.PrecioPersonaAdicional,
                @PrecioDiaEspecial = t.PrecioDiaEspecial,
                @TemporadaNombre = tmp.Nombre
            FROM Tarifas t
            INNER JOIN Temporadas tmp ON tmp.Id = t.TemporadaId
            WHERE t.AlojamientoId = @AlojamientoId
                AND @FechaActual >= tmp.FechaInicio
                AND @FechaActual <= tmp.FechaFin
                AND t.EstaActiva = 1
            ORDER BY t.FechaInicioVigencia DESC;

            IF @NumeroPersonas > @CapacidadIncluida
            BEGIN
                SET @PersonasAdicionales = @NumeroPersonas - @CapacidadIncluida;
                SET @PrecioPersonasAdicionales = @PersonasAdicionales * @PrecioPersonaAdicional;
            END

            -- Lunes-Jueves con PrecioDiaEspecial aplica precio de semana
            IF @DiaActual IN (2, 3, 4, 5) AND @PrecioDiaEspecial IS NOT NULL
            BEGIN
                SET @PrecioAjustado = @PrecioDiaEspecial + @PrecioPersonasAdicionales;
            END
            ELSE
            BEGIN
                SET @PrecioAjustado = @PrecioBase + @PrecioPersonasAdicionales;
            END

            INSERT INTO @ResultadoTarifas (Fecha, PrecioBase, PersonasAdicionales, PrecioPersonasAdicionales, PrecioAjustado, NombreTemporada, EsCompra)
            VALUES (CAST(@FechaActual AS DATE), @PrecioBase, @PersonasAdicionales, @PrecioPersonasAdicionales, @PrecioAjustado, @TemporadaNombre, 1);

            SET @FechaActual = DATEADD(DAY, 1, @FechaActual);
        END

        SELECT * FROM @ResultadoTarifas;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

-- ==========================================================
-- SP 4: sp_CalcularTotalReserva
-- Retorna el total de una reserva (suma de todas las noches)
-- ==========================================================

DROP PROCEDURE IF EXISTS [dbo].[sp_CalcularTotalReserva];
GO

CREATE PROCEDURE [dbo].[sp_CalcularTotalReserva]
    @AlojamientoId INT,
    @NumeroPersonas INT,
    @FechaInicio DATETIME2,
    @FechaFin DATETIME2,
    @IncluyeLavanderia BIT = 0
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @FechaActual DATETIME2 = @FechaInicio;
        DECLARE @NumeroNoches INT = DATEDIFF(DAY, @FechaInicio, @FechaFin);
        DECLARE @TotalAlojamiento DECIMAL(18,2) = 0;
        DECLARE @TotalServicios DECIMAL(18,2) = 0;
        DECLARE @TotalReserva DECIMAL(18,2) = 0;
        DECLARE @PrecioLavanderia DECIMAL(18,2) = 0;

        SELECT @PrecioLavanderia = Precio FROM Servicios WHERE Nombre = 'Servicio de Lavandería';

        WHILE @FechaActual < @FechaFin
        BEGIN
            DECLARE @PrecioBase DECIMAL(18,2);
            DECLARE @CapacidadIncluida INT;
            DECLARE @PrecioPersonaAdicional DECIMAL(18,2);
            DECLARE @PrecioDiaEspecial DECIMAL(18,2);
            DECLARE @PersonasAdicionales INT = 0;
            DECLARE @PrecioNoche DECIMAL(18,2) = 0;
            DECLARE @DiaActual INT = DATEPART(WEEKDAY, @FechaActual);

            SELECT TOP 1
                @PrecioBase = t.PrecioBase,
                @CapacidadIncluida = t.CapacidadIncluida,
                @PrecioPersonaAdicional = t.PrecioPersonaAdicional,
                @PrecioDiaEspecial = t.PrecioDiaEspecial
            FROM Tarifas t
            INNER JOIN Temporadas tmp ON tmp.Id = t.TemporadaId
            WHERE t.AlojamientoId = @AlojamientoId
                AND @FechaActual >= tmp.FechaInicio
                AND @FechaActual <= tmp.FechaFin
                AND t.EstaActiva = 1
            ORDER BY t.FechaInicioVigencia DESC;

            IF @NumeroPersonas > @CapacidadIncluida
            BEGIN
                SET @PersonasAdicionales = @NumeroPersonas - @CapacidadIncluida;
                SET @PrecioNoche = @PrecioBase + (@PersonasAdicionales * @PrecioPersonaAdicional);
            END
            ELSE
            BEGIN
                SET @PrecioNoche = @PrecioBase;
            END

            IF @DiaActual IN (2, 3, 4, 5) AND @PrecioDiaEspecial IS NOT NULL
            BEGIN
                SET @PrecioNoche = @PrecioDiaEspecial;
                IF @NumeroPersonas > @CapacidadIncluida
                BEGIN
                    SET @PrecioNoche = @PrecioDiaEspecial + (@PersonasAdicionales * @PrecioPersonaAdicional);
                END
            END

            SET @TotalAlojamiento = @TotalAlojamiento + @PrecioNoche;
            SET @FechaActual = DATEADD(DAY, 1, @FechaActual);
        END

        IF @IncluyeLavanderia = 1
        BEGIN
            SET @TotalServicios = @NumeroNoches * @PrecioLavanderia;
        END

        SET @TotalReserva = @TotalAlojamiento + @TotalServicios;

        SELECT
            @TotalAlojamiento AS TotalAlojamiento,
            @TotalServicios AS TotalServicios,
            @TotalReserva AS TotalReserva,
            @NumeroNoches AS NumeroNoches;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

PRINT 'Stored Procedures creados exitosamente.';
GO
