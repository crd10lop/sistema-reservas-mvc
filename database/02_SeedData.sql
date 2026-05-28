USE SistemaReservas;
SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    -- Limpiar en orden inverso de dependencias
    DELETE FROM ReservasServicios;
    DELETE FROM DetallesReserva;
    DELETE FROM Reservas;
    DELETE FROM Tarifas;
    DELETE FROM Alojamientos;
    DELETE FROM Sedes;
    DELETE FROM Servicios;
    DELETE FROM Temporadas;

    -- Resetear identidades
    DBCC CHECKIDENT('ReservasServicios', RESEED, 0);
    DBCC CHECKIDENT('DetallesReserva',   RESEED, 0);
    DBCC CHECKIDENT('Reservas',          RESEED, 0);
    DBCC CHECKIDENT('Tarifas',           RESEED, 0);
    DBCC CHECKIDENT('Alojamientos',      RESEED, 0);
    DBCC CHECKIDENT('Sedes',             RESEED, 0);
    DBCC CHECKIDENT('Servicios',         RESEED, 0);
    DBCC CHECKIDENT('Temporadas',        RESEED, 0);

    -- =============================================
    -- TEMPORADAS 2026
    -- =============================================
    INSERT INTO Temporadas (Nombre, TipoTemporada, FechaInicio, FechaFin, [Año], Descripcion, EstaActiva) VALUES
        ('Temporada Baja 2026',            0, '2026-01-16', '2026-06-14', 2026, NULL, 1),
        ('Temporada Alta Inicio Año 2026', 1, '2026-01-01', '2026-01-15', 2026, NULL, 1),
        ('Temporada Alta Mitad Año 2026',  1, '2026-06-15', '2026-07-15', 2026, NULL, 1),
        ('Temporada Alta Fin Año 2026',    1, '2026-12-15', '2026-12-31', 2026, NULL, 1);

    -- TEMPORADAS 2027
    INSERT INTO Temporadas (Nombre, TipoTemporada, FechaInicio, FechaFin, [Año], Descripcion, EstaActiva) VALUES
        ('Temporada Baja 2027',            0, '2027-01-16', '2027-06-14', 2027, NULL, 1),
        ('Temporada Alta Inicio Año 2027', 1, '2027-01-01', '2027-01-15', 2027, NULL, 1),
        ('Temporada Alta Mitad Año 2027',  1, '2027-06-15', '2027-07-15', 2027, NULL, 1),
        ('Temporada Alta Fin Año 2027',    1, '2027-12-15', '2027-12-31', 2027, NULL, 1);

    -- =============================================
    -- SERVICIOS
    -- =============================================
    INSERT INTO Servicios (Nombre, Descripcion, Precio, EstaActivo) VALUES
        ('Servicio de Lavandería', '', 18000, 1);

    -- =============================================
    -- SEDE 1: Sede Recreativa Villeta
    -- =============================================
    DECLARE @SedeVilleta INT;
    INSERT INTO Sedes (Nombre, TipoSede, Ciudad, Departamento, Direccion, Descripcion, CapacidadTotal, ImagenUrl, EstaActiva, FechaCreacion)
    VALUES ('Sede Recreativa Villeta', 0, 'Villeta', 'Cundinamarca', 'Barrio San Jorge, Villeta',
            'Sede recreativa en el barrio San Jorge a poca distancia de la plaza central de Villeta en la Provincia del Gualivá, Cundinamarca. 8 habitaciones, capacidad total hasta 32 personas.',
            32, NULL, 1, GETUTCDATE());
    SET @SedeVilleta = SCOPE_IDENTITY();

    INSERT INTO Alojamientos (SedeId, Numero, Nombre, TipoAlojamiento, CapacidadMaxima, CapacidadIncluida, NumeroHabitacionesInternas, Descripcion, Caracteristicas, EstaActivo) VALUES
        (@SedeVilleta, 'Habitación 1', 'Habitación 1 de Villeta', 0, 4, 4, 1, 'Alcoba con cama doble y un camarote', 'Cama doble, camarote, baño, nevera, televisor, terraza cubierta', 1),
        (@SedeVilleta, 'Habitación 2', 'Habitación 2 de Villeta', 0, 4, 4, 1, 'Alcoba con cama doble y un camarote', 'Cama doble, camarote, baño, nevera, televisor, terraza cubierta', 1),
        (@SedeVilleta, 'Habitación 3', 'Habitación 3 de Villeta', 0, 4, 4, 1, 'Alcoba con cama doble y un camarote', 'Cama doble, camarote, baño, nevera, televisor, terraza cubierta', 1),
        (@SedeVilleta, 'Habitación 4', 'Habitación 4 de Villeta', 0, 4, 4, 1, 'Alcoba con cama doble y un camarote', 'Cama doble, camarote, baño, nevera, televisor, terraza cubierta', 1),
        (@SedeVilleta, 'Habitación 5', 'Habitación 5 de Villeta', 0, 4, 4, 1, 'Alcoba con cama doble y un camarote', 'Cama doble, camarote, baño, nevera, televisor, terraza cubierta', 1),
        (@SedeVilleta, 'Habitación 6', 'Habitación 6 de Villeta', 0, 4, 4, 1, 'Alcoba con cama doble y un camarote', 'Cama doble, camarote, baño, nevera, televisor, terraza cubierta', 1),
        (@SedeVilleta, 'Habitación 7', 'Habitación 7 de Villeta', 0, 4, 4, 1, 'Alcoba con cama doble y un camarote', 'Cama doble, camarote, baño, nevera, televisor, terraza cubierta', 1),
        (@SedeVilleta, 'Habitación 8', 'Habitación 8 de Villeta', 0, 4, 4, 1, 'Alcoba con cama doble y un camarote', 'Cama doble, camarote, baño, nevera, televisor, terraza cubierta', 1);

    -- =============================================
    -- SEDE 2: Sede Recreativa El Placer
    -- =============================================
    DECLARE @SedePlacer INT;
    INSERT INTO Sedes (Nombre, TipoSede, Ciudad, Departamento, Direccion, Descripcion, CapacidadTotal, ImagenUrl, EstaActiva, FechaCreacion)
    VALUES ('Sede Recreativa El Placer', 0, 'Fusagasugá', 'Cundinamarca', 'Vereda El Placer, Fusagasugá',
            'Sede recreativa en la vereda El Placer del municipio de Fusagasugá, a unos 10 minutos del casco urbano. Cuenta con 4 alojamientos y 4 cabañas. Capacidad total hasta 34 personas.',
            34, NULL, 1, GETUTCDATE());
    SET @SedePlacer = SCOPE_IDENTITY();

    INSERT INTO Alojamientos (SedeId, Numero, Nombre, TipoAlojamiento, CapacidadMaxima, CapacidadIncluida, NumeroHabitacionesInternas, Descripcion, Caracteristicas, EstaActivo) VALUES
        (@SedePlacer, 'Alojamiento 1', 'Alojamiento 1 de El Placer', 3, 5, 4, 2, 'Dos habitaciones, baño, televisor. Cama doble, cama sencilla y cama sencilla.',        'Cama doble, 2 camas sencillas, baño, televisor', 1),
        (@SedePlacer, 'Alojamiento 2', 'Alojamiento 2 de El Placer', 3, 6, 4, 2, 'Dos habitaciones, baño, televisor. Cama doble y 4 camas sencillas.',                   'Cama doble, 4 camas sencillas, baño, televisor', 1),
        (@SedePlacer, 'Alojamiento 3', 'Alojamiento 3 de El Placer', 3, 4, 4, 1, 'Una habitación, cama doble y 2 sencillas, baño, televisor.',                           'Cama doble, 2 camas sencillas, baño, televisor', 1),
        (@SedePlacer, 'Alojamiento 4', 'Alojamiento 4 de El Placer', 3, 4, 4, 2, 'Dos habitaciones, baño, televisor. Cama doble, cama sencilla y cama sencilla.',        'Cama doble, 2 camas sencillas, baño, televisor', 1),
        (@SedePlacer, 'Cabaña 5',      'Cabaña 5 de El Placer',      1, 4, 4, 1, 'Sala con sofá cama, baño, habitación con cama doble y sencilla, cocineta, nevera, terraza comedor.', 'Sofá cama, cama doble, cama sencilla, baño, cocineta, nevera, terraza comedor', 1),
        (@SedePlacer, 'Cabaña 6',      'Cabaña 6 de El Placer',      1, 4, 4, 1, 'Sala con sofá cama, baño, habitación con cama doble y sencilla, cocineta, nevera, terraza comedor.', 'Sofá cama, cama doble, cama sencilla, baño, cocineta, nevera, terraza comedor', 1),
        (@SedePlacer, 'Cabaña 7',      'Cabaña 7 de El Placer',      1, 4, 4, 1, 'Sala con sofá cama, baño, habitación con cama doble y sencilla, cocineta, nevera, terraza comedor.', 'Sofá cama, cama doble, cama sencilla, baño, cocineta, nevera, terraza comedor', 1),
        (@SedePlacer, 'Cabaña 8',      'Cabaña 8 de El Placer',      1, 4, 4, 1, 'Sala con sofá cama, baño, habitación con cama doble y sencilla, cocineta, nevera, terraza comedor.', 'Sofá cama, cama doble, cama sencilla, baño, cocineta, nevera, terraza comedor', 1);

    -- =============================================
    -- SEDE 3: Sede Recreativa Gonzalo Morante
    -- =============================================
    DECLARE @SedeMorante INT;
    INSERT INTO Sedes (Nombre, TipoSede, Ciudad, Departamento, Direccion, Descripcion, CapacidadTotal, ImagenUrl, EstaActiva, FechaCreacion)
    VALUES ('Sede Recreativa Gonzalo Morante', 0, 'Chinchiná', 'Caldas', 'Chinchiná, Caldas',
            'Sede recreativa Gonzalo Morante en Chinchiná. Cuenta con alojamientos tipo A y tipo B. Capacidad total hasta 30 personas.',
            30, NULL, 1, GETUTCDATE());
    SET @SedeMorante = SCOPE_IDENTITY();

    INSERT INTO Alojamientos (SedeId, Numero, Nombre, TipoAlojamiento, CapacidadMaxima, CapacidadIncluida, NumeroHabitacionesInternas, Descripcion, Caracteristicas, EstaActivo) VALUES
        (@SedeMorante, 'Alojamiento 1', 'Alojamiento 1 de Gonzalo Morante',          3, 6, 4, 2, 'Cocineta, baño, televisor, 2 habitaciones.',                          'Cocineta, baño, televisor', 1),
        (@SedeMorante, 'Alojamiento 2', 'Alojamiento 2 de Gonzalo Morante',          3, 8, 4, 2, 'Cocineta, baño, televisor, 2 habitaciones.',                          'Cocineta, baño, televisor', 1),
        (@SedeMorante, 'Alojamiento 3', 'Alojamiento 3 de Gonzalo Morante (Tipo A)', 3, 6, 4, 2, 'Cocineta, 2 baños, sala comedor, televisor, 2 habitaciones.',         'Cocineta, 2 baños, sala comedor, televisor', 1),
        (@SedeMorante, 'Alojamiento 4', 'Alojamiento 4 de Gonzalo Morante',          3, 3, 3, 1, 'Cocineta, baño, televisor, 1 habitación con cama doble y sencilla.', 'Cama doble, cama sencilla, cocineta, baño, televisor', 1),
        (@SedeMorante, 'Cabaña 5',      'Cabaña 5 de Gonzalo Morante (Tipo B)',      1, 3, 3, 1, 'Cocineta, baño, sala con sofá, televisor, 1 habitación.',             'Sofá, cocineta, baño, televisor', 1),
        (@SedeMorante, 'Cabaña 6',      'Cabaña 6 de Gonzalo Morante (Tipo B)',      1, 3, 3, 1, 'Cocineta, baño, sala con sofá, televisor, 1 habitación.',             'Sofá, cocineta, baño, televisor', 1);

    -- =============================================
    -- SEDE 4: Sede Recreativa Tablones
    -- =============================================
    DECLARE @SedeTablones INT;
    INSERT INTO Sedes (Nombre, TipoSede, Ciudad, Departamento, Direccion, Descripcion, CapacidadTotal, ImagenUrl, EstaActiva, FechaCreacion)
    VALUES ('Sede Recreativa Tablones', 0, 'Palmira', 'Valle del Cauca', 'Palmira, Valle del Cauca',
            'Sede recreativa Tablones en Palmira. Cuenta con 4 alojamientos. Capacidad total hasta 24 personas.',
            24, NULL, 1, GETUTCDATE());
    SET @SedeTablones = SCOPE_IDENTITY();

    INSERT INTO Alojamientos (SedeId, Numero, Nombre, TipoAlojamiento, CapacidadMaxima, CapacidadIncluida, NumeroHabitacionesInternas, Descripcion, Caracteristicas, EstaActivo) VALUES
        (@SedeTablones, 'Alojamiento 1', 'Alojamiento 1 de Tablones', 3, 4, 4, 1, '1 habitación con cama doble y camarote, televisor, baño, cocineta.', 'Cama doble, camarote, televisor, baño, cocineta', 1),
        (@SedeTablones, 'Alojamiento 2', 'Alojamiento 2 de Tablones', 3, 4, 4, 1, '1 habitación con cama doble y camarote, televisor, baño, cocineta.', 'Cama doble, camarote, televisor, baño, cocineta', 1),
        (@SedeTablones, 'Alojamiento 3', 'Alojamiento 3 de Tablones', 3, 8, 4, 2, '2 habitaciones (cama doble+camarote y dos camarotes), televisor, baño, cocineta.', 'Cama doble, 3 camarotes, televisor, baño, cocineta', 1),
        (@SedeTablones, 'Alojamiento 4', 'Alojamiento 4 de Tablones', 3, 8, 4, 2, '2 habitaciones (cama doble+camarote y dos camarotes), televisor, baño, cocineta.', 'Cama doble, 3 camarotes, televisor, baño, cocineta', 1);

    -- =============================================
    -- SEDE 5: Sede Recreativa Manguruma
    -- =============================================
    DECLARE @SedeManguruma INT;
    INSERT INTO Sedes (Nombre, TipoSede, Ciudad, Departamento, Direccion, Descripcion, CapacidadTotal, ImagenUrl, EstaActiva, FechaCreacion)
    VALUES ('Sede Recreativa Manguruma', 0, 'Santa Fe de Antioquia', 'Antioquia', 'Santa Fe de Antioquia',
            'Sede recreativa Manguruma en Santa Fe de Antioquia. Cuenta con alojamientos tradicionales y un bloque nuevo. Capacidad total hasta 46 personas.',
            46, NULL, 1, GETUTCDATE());
    SET @SedeManguruma = SCOPE_IDENTITY();

    INSERT INTO Alojamientos (SedeId, Numero, Nombre, TipoAlojamiento, CapacidadMaxima, CapacidadIncluida, NumeroHabitacionesInternas, Descripcion, Caracteristicas, EstaActivo) VALUES
        (@SedeManguruma, 'Alojamiento 1',  'Alojamiento 1 de Manguruma',  3, 4, 4, 1, 'Cama doble y camarote, baño, terraza, televisor.',                              'Cama doble, camarote, baño, terraza, televisor', 1),
        (@SedeManguruma, 'Alojamiento 2',  'Alojamiento 2 de Manguruma',  3, 5, 4, 1, 'Cama doble, camarote y sofá cama, baño, terraza, televisor.',                   'Cama doble, camarote, sofá cama, baño, terraza, televisor', 1),
        (@SedeManguruma, 'Alojamiento 3',  'Alojamiento 3 de Manguruma',  3, 5, 4, 1, 'Cama doble, camarote y sofá cama, baño, terraza, televisor.',                   'Cama doble, camarote, sofá cama, baño, terraza, televisor', 1),
        (@SedeManguruma, 'Bloque Nuevo 1', 'Bloque Nuevo 1 de Manguruma', 3, 4, 4, 1, '2 camas gemelas y camarote, baño, terraza comedor, cocina, nevera, televisor.', '2 camas gemelas, camarote, baño, terraza comedor, cocina, nevera, televisor', 1),
        (@SedeManguruma, 'Bloque Nuevo 2', 'Bloque Nuevo 2 de Manguruma', 3, 4, 4, 1, '2 camas gemelas y camarote, baño, terraza comedor, cocina, nevera, televisor.', '2 camas gemelas, camarote, baño, terraza comedor, cocina, nevera, televisor', 1),
        (@SedeManguruma, 'Bloque Nuevo 3', 'Bloque Nuevo 3 de Manguruma', 3, 4, 4, 1, '2 camas gemelas y camarote, baño, terraza comedor, cocina, nevera, televisor.', '2 camas gemelas, camarote, baño, terraza comedor, cocina, nevera, televisor', 1),
        (@SedeManguruma, 'Bloque Nuevo 4', 'Bloque Nuevo 4 de Manguruma', 3, 4, 4, 1, '2 camas gemelas y camarote, baño, terraza comedor, cocina, nevera, televisor.', '2 camas gemelas, camarote, baño, terraza comedor, cocina, nevera, televisor', 1),
        (@SedeManguruma, 'Bloque Nuevo 5', 'Bloque Nuevo 5 de Manguruma', 3, 4, 4, 1, '2 camas gemelas y camarote, baño, terraza comedor, cocina, nevera, televisor.', '2 camas gemelas, camarote, baño, terraza comedor, cocina, nevera, televisor', 1),
        (@SedeManguruma, 'Bloque Nuevo 6', 'Bloque Nuevo 6 de Manguruma', 3, 4, 4, 1, '2 camas gemelas y camarote, baño, terraza comedor, cocina, nevera, televisor.', '2 camas gemelas, camarote, baño, terraza comedor, cocina, nevera, televisor', 1),
        (@SedeManguruma, 'Bloque Nuevo 7', 'Bloque Nuevo 7 de Manguruma', 3, 4, 4, 1, '2 camas gemelas y camarote, baño, terraza comedor, cocina, nevera, televisor.', '2 camas gemelas, camarote, baño, terraza comedor, cocina, nevera, televisor', 1),
        (@SedeManguruma, 'Bloque Nuevo 8', 'Bloque Nuevo 8 de Manguruma', 3, 4, 4, 1, '2 camas gemelas y camarote, baño, terraza comedor, cocina, nevera, televisor.', '2 camas gemelas, camarote, baño, terraza comedor, cocina, nevera, televisor', 1);

    -- =============================================
    -- SEDE 6: Sede Federman Bogotá
    -- =============================================
    DECLARE @SedeFederman INT;
    INSERT INTO Sedes (Nombre, TipoSede, Ciudad, Departamento, Direccion, Descripcion, CapacidadTotal, ImagenUrl, EstaActiva, FechaCreacion)
    VALUES ('Sede Federman Bogotá', 0, 'Bogotá', 'Cundinamarca', 'Bogotá',
            'Sede en Bogotá con zona húmeda, gimnasio, sala de masajes, billar, juegos de mesa, sala social. Cuenta con 8 habitaciones, 4 disponibles para alojamiento.',
            16, NULL, 1, GETUTCDATE());
    SET @SedeFederman = SCOPE_IDENTITY();

    INSERT INTO Alojamientos (SedeId, Numero, Nombre, TipoAlojamiento, CapacidadMaxima, CapacidadIncluida, NumeroHabitacionesInternas, Descripcion, Caracteristicas, EstaActivo) VALUES
        (@SedeFederman, 'Habitación 1', 'Habitación 1 de Federman', 0, 2, 2, 1, 'Habitación con acceso a los servicios de la sede.', 'Habitación con servicios de la sede (zona húmeda, gimnasio, billar)', 1),
        (@SedeFederman, 'Habitación 2', 'Habitación 2 de Federman', 0, 2, 2, 1, 'Habitación con acceso a los servicios de la sede.', 'Habitación con servicios de la sede (zona húmeda, gimnasio, billar)', 1),
        (@SedeFederman, 'Habitación 3', 'Habitación 3 de Federman', 0, 2, 2, 1, 'Habitación con acceso a los servicios de la sede.', 'Habitación con servicios de la sede (zona húmeda, gimnasio, billar)', 1),
        (@SedeFederman, 'Habitación 4', 'Habitación 4 de Federman', 0, 2, 2, 1, 'Habitación con acceso a los servicios de la sede.', 'Habitación con servicios de la sede (zona húmeda, gimnasio, billar)', 1),
        (@SedeFederman, 'Habitación 5', 'Habitación 5 de Federman', 0, 2, 2, 1, 'Habitación con acceso a los servicios de la sede.', 'Habitación con servicios de la sede (zona húmeda, gimnasio, billar)', 1),
        (@SedeFederman, 'Habitación 6', 'Habitación 6 de Federman', 0, 2, 2, 1, 'Habitación con acceso a los servicios de la sede.', 'Habitación con servicios de la sede (zona húmeda, gimnasio, billar)', 1),
        (@SedeFederman, 'Habitación 7', 'Habitación 7 de Federman', 0, 2, 2, 1, 'Habitación con acceso a los servicios de la sede.', 'Habitación con servicios de la sede (zona húmeda, gimnasio, billar)', 1),
        (@SedeFederman, 'Habitación 8', 'Habitación 8 de Federman', 0, 2, 2, 1, 'Habitación con acceso a los servicios de la sede.', 'Habitación con servicios de la sede (zona húmeda, gimnasio, billar)', 1);

    -- =============================================
    -- SEDE 7: Edificio Suramericana, Medellín
    -- =============================================
    DECLARE @SedeSuramericana INT;
    INSERT INTO Sedes (Nombre, TipoSede, Ciudad, Departamento, Direccion, Descripcion, CapacidadTotal, ImagenUrl, EstaActiva, FechaCreacion)
    VALUES ('Edificio Suramericana', 1, 'Medellín', 'Antioquia', 'Calle 49 B N° 64B-15, Edificio Suramericana N° 6, Apartamento 1204',
            'Apartamento ubicado cerca del campus de la Universidad Nacional de Colombia. Cuenta con 5 habitaciones.',
            9, NULL, 1, GETUTCDATE());
    SET @SedeSuramericana = SCOPE_IDENTITY();

    INSERT INTO Alojamientos (SedeId, Numero, Nombre, TipoAlojamiento, CapacidadMaxima, CapacidadIncluida, NumeroHabitacionesInternas, Descripcion, Caracteristicas, EstaActivo) VALUES
        (@SedeSuramericana, 'Habitación 1', 'Habitación 1 Suramericana', 0, 2, 1, 1, '2 camas sencillas, baño privado.', '2 camas sencillas, baño privado', 1),
        (@SedeSuramericana, 'Habitación 2', 'Habitación 2 Suramericana', 0, 2, 1, 1, '2 camas sencillas.',              '2 camas sencillas',               1),
        (@SedeSuramericana, 'Habitación 3', 'Habitación 3 Suramericana', 0, 2, 1, 1, '2 camas sencillas.',              '2 camas sencillas',               1),
        (@SedeSuramericana, 'Habitación 4', 'Habitación 4 Suramericana', 0, 2, 1, 1, '2 camas sencillas.',              '2 camas sencillas',               1),
        (@SedeSuramericana, 'Habitación 5', 'Habitación 5 Suramericana', 0, 1, 1, 1, '1 cama sencilla, baño privado.', '1 cama sencilla, baño privado',   1);

    -- =============================================
    -- SEDE 8: Edificio Reina 1, Santa Marta
    -- =============================================
    DECLARE @SedeReina INT;
    INSERT INTO Sedes (Nombre, TipoSede, Ciudad, Departamento, Direccion, Descripcion, CapacidadTotal, ImagenUrl, EstaActiva, FechaCreacion)
    VALUES ('Edificio Reina 1', 1, 'Santa Marta', 'Magdalena', 'Carrera 3 número 7-85, El Rodadero',
            'Tres apartamentos en El Rodadero, a tres cuadras de la playa. Centro urbano y turístico.',
            20, NULL, 1, GETUTCDATE());
    SET @SedeReina = SCOPE_IDENTITY();

    INSERT INTO Alojamientos (SedeId, Numero, Nombre, TipoAlojamiento, CapacidadMaxima, CapacidadIncluida, NumeroHabitacionesInternas, Descripcion, Caracteristicas, EstaActivo) VALUES
        (@SedeReina, 'Apartamento 202', 'Apartamento 202 Reina 1', 2, 8, 8, 3, 'Sala comedor, cocina, 2 baños, 3 habitaciones, parqueo.', 'Sala comedor, cocina, 2 baños, 3 habitaciones, parqueo', 1),
        (@SedeReina, 'Apartamento 301', 'Apartamento 301 Reina 1', 2, 6, 6, 2, 'Sala comedor, cocina, 1 baño, 2 habitaciones, parqueo.',  'Sala comedor, cocina, 1 baño, 2 habitaciones, parqueo',  1),
        (@SedeReina, 'Apartamento 401', 'Apartamento 401 Reina 1', 2, 6, 6, 2, 'Sala comedor, cocina, 1 baño, 2 habitaciones, parqueo.',  'Sala comedor, cocina, 1 baño, 2 habitaciones, parqueo',  1);

    -- =============================================
    -- TARIFAS: Sedes Recreativas (TipoSede = 0)
    -- =============================================
    -- Regla de precio base:
    --   90000 si: NumHab >= 2, Cabaña de El Placer, o Bloque Nuevo de Manguruma
    --   70000 en los demás casos (1 habitación)
    -- PrecioDiaEspecial (tarifa L-J) solo en temporada Baja (TipoTemporada = 0)
    INSERT INTO Tarifas (AlojamientoId, TemporadaId, PrecioBase, CapacidadIncluida, PrecioPersonaAdicional, PrecioDiaEspecial, FechaInicioVigencia, FechaFinVigencia, EstaActiva)
    SELECT
        a.Id,
        t.Id,
        CASE
            WHEN a.NumeroHabitacionesInternas >= 2
                 OR (a.TipoAlojamiento = 1 AND s.Nombre = 'Sede Recreativa El Placer')
                 OR (a.Numero LIKE 'Bloque Nuevo%')
            THEN 90000
            ELSE 70000
        END,
        4,
        16000,
        CASE
            WHEN t.TipoTemporada <> 0 THEN NULL
            WHEN a.NumeroHabitacionesInternas >= 2
                 OR (a.TipoAlojamiento = 1 AND s.Nombre = 'Sede Recreativa El Placer')
                 OR (a.Numero LIKE 'Bloque Nuevo%')
            THEN 37000
            ELSE 27000
        END,
        '2026-01-01',
        NULL,
        1
    FROM Alojamientos a
    JOIN Sedes s ON s.Id = a.SedeId
    CROSS JOIN Temporadas t
    WHERE s.TipoSede = 0;

    -- =============================================
    -- TARIFAS: Edificio Suramericana
    -- =============================================
    -- Precio único sin distinción de temporada: base=63000, adicional=12000
    INSERT INTO Tarifas (AlojamientoId, TemporadaId, PrecioBase, CapacidadIncluida, PrecioPersonaAdicional, PrecioDiaEspecial, FechaInicioVigencia, FechaFinVigencia, EstaActiva)
    SELECT
        a.Id,
        t.Id,
        63000,
        1,
        12000,
        NULL,
        '2026-01-01',
        NULL,
        1
    FROM Alojamientos a
    JOIN Sedes s ON s.Id = a.SedeId
    CROSS JOIN Temporadas t
    WHERE s.Nombre = 'Edificio Suramericana';

    -- =============================================
    -- TARIFAS: Edificio Reina 1
    -- =============================================
    -- Apto 202 (3 hab): Baja=103000 / Alta=143000
    -- Aptos 301 y 401 (2 hab): Baja=89000 / Alta=124000
    INSERT INTO Tarifas (AlojamientoId, TemporadaId, PrecioBase, CapacidadIncluida, PrecioPersonaAdicional, PrecioDiaEspecial, FechaInicioVigencia, FechaFinVigencia, EstaActiva)
    SELECT
        a.Id,
        t.Id,
        CASE
            WHEN a.NumeroHabitacionesInternas = 3
            THEN CASE WHEN t.TipoTemporada = 0 THEN 103000 ELSE 143000 END
            ELSE CASE WHEN t.TipoTemporada = 0 THEN  89000 ELSE 124000 END
        END,
        a.CapacidadIncluida,
        0,
        NULL,
        '2026-01-01',
        NULL,
        1
    FROM Alojamientos a
    JOIN Sedes s ON s.Id = a.SedeId
    CROSS JOIN Temporadas t
    WHERE s.Nombre = 'Edificio Reina 1';

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;

-- Verificación de registros por tabla
SELECT 'Temporadas'   AS Tabla, COUNT(*) AS Registros FROM Temporadas   UNION ALL
SELECT 'Servicios',            COUNT(*)               FROM Servicios               UNION ALL
SELECT 'Sedes',                COUNT(*)               FROM Sedes                   UNION ALL
SELECT 'Alojamientos',         COUNT(*)               FROM Alojamientos             UNION ALL
SELECT 'Tarifas',              COUNT(*)               FROM Tarifas;
