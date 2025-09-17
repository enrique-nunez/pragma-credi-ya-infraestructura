-- Configurar zona horaria
SET timezone = 'America/Bogota';

-- Log de inicialización
DO $$
BEGIN
    -- Crear tabla roles
    CREATE TABLE IF NOT EXISTS rol (
        id BIGSERIAL PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE,
        descripcion VARCHAR(255)
    );

    -- Insertar roles por defecto
    INSERT INTO rol (nombre, descripcion) VALUES
    ('ADMIN', 'Administrador del sistema'),
    ('USER', 'Usuario estándar'),
    ('MANAGER', 'Gerente')
    ON CONFLICT (nombre) DO NOTHING;

    -- Crear tabla usuario
    CREATE TABLE IF NOT EXISTS usuario (
        id BIGSERIAL PRIMARY KEY,
        nombres VARCHAR(100) NOT NULL,
        apellidos VARCHAR(100) NOT NULL,
        fecha_nacimiento DATE NOT NULL,
        direccion VARCHAR(255),
        telefono VARCHAR(20),
        correo_electronico VARCHAR(150) UNIQUE NOT NULL,
        salario_base DECIMAL(15,2),
        password VARCHAR(255) NOT NULL,
        fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        role_id BIGINT REFERENCES rol(id) DEFAULT 2
    );
    
    RAISE NOTICE 'Base de datos de Autenticación inicializada correctamente en %', now();
END $$;
