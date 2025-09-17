-- Configurar zona horaria
SET timezone = 'America/Bogota';

-- Log de inicialización
DO $$
BEGIN
    -- Tabla de estados
    CREATE TABLE  IF NOT EXISTS estados (
    id_estado BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
    );

    -- Tabla de tipo_prestamo
    CREATE TABLE  IF NOT EXISTS tipo_prestamo (
    id_tipo_prestamo BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL UNIQUE,
    monto_maximo NUMERIC(15,2) NOT NULL,
    tasa_interes NUMERIC(5,2) NOT NULL,
    validacion_automatica BOOLEAN NOT NULL
    );

    -- Tabla de solicitud
    CREATE TABLE  IF NOT EXISTS solicitud (
    id_solicitud BIGSERIAL PRIMARY KEY,
    monto NUMERIC(15,2) NOT NULL,
    plazo INTEGER NOT NULL,
    email VARCHAR(150) NOT NULL,
    id_estado BIGINT NOT NULL REFERENCES estados(id_estado),
    id_tipo_prestamo BIGINT NOT NULL REFERENCES tipo_prestamo(id_tipo_prestamo)
    );

    -- Insertar datos iniciales en la tabla estados
    INSERT INTO estados (nombre, descripcion) VALUES
    ('PENDING', 'Pendiente de revisión'),
    ('REJECTED', 'Rechazadas'),
    ('MANUAL_REVIEW', 'Revision manual'),
    ('APPROVED', 'Aprobadas'),
    ('AUTO_REVIEW', 'En revisión automática')
    ON CONFLICT (nombre) DO NOTHING;

    -- Insertar datos iniciales en la tabla tipo_prestamo
    INSERT INTO tipo_prestamo (nombre, monto_maximo, tasa_interes, validacion_automatica) VALUES
    ('Personal', 50000.00, 12.50, true),
    ('Vehículo', 200000.00, 9.75, false),
    ('Hipotecario', 1000000.00, 7.20, false),
    ('Educativo', 80000.00, 10.00, true),
    ('Negocios', 300000.00, 11.00, true)
    ON CONFLICT (nombre) DO NOTHING;
    RAISE NOTICE 'Base de datos de Solicitudes inicializada correctamente en %', now();
END $$;
