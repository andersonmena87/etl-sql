DROP TABLE Encuesta;

CREATE TABLE Encuesta (
	SubjectID int NULL,
	DPEncargado nvarchar(500) NULL,
	EstadoTicket nvarchar(500) NULL,
	JobId int NULL,
	IdPropuesta int NULL,
	Gerente nvarchar(500) NULL,
	Muestra int NULL,
	PaisEjecucion nvarchar(500) NULL,
	PaisVenta nvarchar(500) NULL,
	TipoEstudio nvarchar(50) NULL,
	Tecnica nvarchar(50) NULL,
	Plataforma nvarchar(500) NULL,
	Programa nvarchar(500) NULL,
	Entrevistador nvarchar(50) NULL,
	DiaCarga datetime NULL,
	Dia int NULL,
	Mes int NULL,
	Ano int NULL,
	EstatusEncuesta nvarchar(500) NULL,
	Test int NULL,
	VisitStart datetime NULL,
	VisitEnd datetime NULL,
	QualityControlFlag nvarchar(50) NULL,
	IsFiltered int NULL,
	Cancelada int NULL,
	Expirada int NULL,
	Validadas int NULL,
	GPSValidation int NULL,
	Descartadas int NULL,
	ClientDuration datetime NULL,
	TiempoEntreEncuesta int NULL,
	DuracionMinutos int NULL,
	IncidenciaFiltro int NULL,
	CuentasClave nvarchar(300) NULL,
);

--CONSULTA INDICADORES

select Entrevistador, PaisEjecucion, SUM( GPSValidation / Descartadas * 100) indicadorGPS from Encuesta
where GPSValidation = 1
and Descartadas > 0
group by Entrevistador, PaisEjecucion
order by PaisEjecucion;

select Entrevistador, PaisEjecucion, SUM( (1-(Expirada/Validadas))*100) indicadorExpiradas from Encuesta
where Validadas > 0
group by Entrevistador, PaisEjecucion
order by PaisEjecucion, indicadorExpiradas;


select Entrevistador, PaisEjecucion, SUM( (1-(Cancelada/Validadas))*100) indicadorCanceladas from Encuesta
where Validadas > 0
group by Entrevistador, PaisEjecucion
order by PaisEjecucion, indicadorCanceladas;


--Procedimiento almacenado

CREATE PROCEDURE CalcularIndicadores (@fechaInicio datetime, @fechaFin datetime, @pais varchar(50))
AS
BEGIN
  -- Insumo 1: Agrupado por Mes año, Eje y cálculo del indicador GPS
  SELECT YEAR(Fecha) AS Anio, MONTH(Fecha) AS Mes, Eje, 
  CAST(SUM(CASE WHEN GPSValidation = 1 AND Descartadas = 0 THEN 1 ELSE 0 END) AS FLOAT) / 
  COUNT(*) * 100 AS IndicadorGPS
  FROM Encuestas
  WHERE Fecha BETWEEN @fechaInicio AND @fechaFin
  GROUP BY YEAR(Fecha), MONTH(Fecha), Eje
  
  -- Insumo 2: País ejecución, Indicadores de Expiradas y Canceladas
  SELECT @pais AS Pais, 
  CAST(SUM(CASE WHEN Expirada = 1 AND Validada = 1 THEN 0 ELSE 1 END) AS FLOAT) / 
  COUNT(*) * 100 AS IndicadorExpiradas,
  CAST(SUM(CASE WHEN Cancelada = 1 AND Validada = 1 THEN 0 ELSE 1 END) AS FLOAT) / 
  COUNT(*) * 100 AS IndicadorCanceladas
  FROM Encuestas
  WHERE Fecha BETWEEN @fechaInicio AND @fechaFin AND Pais = @pais
  
  -- Insumo 3: Indicador de Calidad
  DECLARE @GPS INT, @Expiradas INT, @Canceladas INT, @Calidad FLOAT
  
  SELECT @GPS = CAST(SUM(CASE WHEN GPSValidation = 1 AND Descartadas = 0 THEN 1 ELSE 0 END) AS FLOAT) / 
  COUNT(*),
  @Expiradas = CAST(SUM(CASE WHEN Expirada = 1 AND Validada = 1 THEN 0 ELSE 1 END) AS FLOAT) / 
  COUNT(*),
  @Canceladas = CAST(SUM(CASE WHEN Cancelada = 1 AND Validada = 1 THEN 0 ELSE 1 END) AS FLOAT) / 
  COUNT(*)
  FROM Encuestas
  WHERE Fecha BETWEEN @fechaInicio AND @fechaFin AND Pais = @pais
  
  IF @GPS >= 0.9
    SET @Calidad = 0.25
  ELSE IF @GPS >= 0.7
    SET @Calidad = 1
  ELSE
    SET @Calidad = 0
  
  IF @Expiradas >= 0.85
    SET @Calidad = @Calidad + (1.575 * (@Expiradas - 0.85))
  
  IF EXISTS (SELECT * FROM Encuestas WHERE Cancelada = 1 AND Validada = 1)
    SET @Calidad = @Calidad * 0.5
  
  SELECT @pais AS Pais, @Calidad AS IndicadorCalidad
END

--PROCEDIMIENTO 2

CREATE PROCEDURE calcular_indicadores (@insumo INT)
AS
BEGIN
    SET NOCOUNT ON;
    IF @insumo = 1
    BEGIN
        SELECT YEAR(Encuesta.Fecha) AS Anio, MONTH(Encuesta.Fecha) AS Mes, Encuesta.Pais, 
        SUM(CASE WHEN Encuesta.GPSValidation = 1 AND Encuesta.Descartada = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100 AS IndicadorGPS
        FROM Encuesta
        GROUP BY YEAR(Encuesta.Fecha), MONTH(Encuesta.Fecha), Encuesta.Pais
    END
    ELSE IF @insumo = 2
    BEGIN
        SELECT Encuesta.Pais, 
        SUM(CASE WHEN Encuesta.GPSValidation = 1 AND Encuesta.Descartada = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100 AS IndicadorGPS,
        (1 - SUM(CASE WHEN Encuesta.Expirada = 1 AND Encuesta.Validada = 1 THEN 1 ELSE 0 END) / SUM(CASE WHEN Encuesta.Validada = 1 THEN 1 ELSE 0 END)) * 100 AS IndicadorExpiradas,
        (1 - SUM(CASE WHEN Encuesta.Cancelada = 1 AND Encuesta.Validada = 1 THEN 1 ELSE 0 END) / SUM(CASE WHEN Encuesta.Validada = 1 THEN 1 ELSE 0 END)) * 100 AS IndicadorCanceladas
        FROM Encuesta
        GROUP BY Encuesta.Pais
    END
    ELSE IF @insumo = 3
    BEGIN
        SELECT Entrevistador.Pais, 
        (SUM(CASE 
            WHEN Encuesta.GPSValidation = 1 AND Encuesta.Descartada = 0 THEN 
                CASE 
                    WHEN (SUM(CASE WHEN Encuesta.Expirada = 1 AND Encuesta.Validada = 1 THEN 1 ELSE 0 END) / SUM(CASE WHEN Encuesta.Validada = 1 THEN 1 ELSE 0 END)) * 100 >= 85 AND (SUM(CASE WHEN Encuesta.Expirada = 1 AND Encuesta.Validada = 1 THEN 1 ELSE 0 END) / SUM(CASE WHEN Encuesta.Validada = 1 THEN 1 ELSE 0 END)) * 100 <= 100 THEN 1.575 
                    ELSE 0 
                END 
            ELSE 0 
        END)
        + 
        CASE 
            WHEN (SUM(CASE WHEN Encuesta.Expirada = 1 AND Encuesta.Validada = 1 THEN 1 ELSE 0 END) / SUM(CASE WHEN Encuesta.Validada = 1 THEN 1 ELSE 0 END)) * 100 >= 85 AND (SUM(CASE WHEN Encuesta.Expirada = 1 AND Encuesta.Validada = 1 THEN 1 ELSE 0 END) / SUM(CASE WHEN Encuesta.Validada = 1 THEN 1 ELSE 0 END)) * 100 <= 100 THEN 1.575 
            ELSE 0 
        END
        +
        CASE 
            WHEN Encuesta.Cancelada = 1 THEN 0 
            ELSE 0.5 
        END
        )
        /
        (CASE 
            WHEN (SUM(CASE WHEN Encuesta.GPSValidation = 1 AND Encuesta.Descartada = 0 THEN 1 ELSE 0

--PROCEDMIENTO ALMACENADO 3

-- Crear tabla temporal para almacenar datos de encuestas
CREATE TABLE #encuestas (
    idEncuesta INT,
    PaisEjecucion VARCHAR(50),
    FechaEncuesta DATE,
    GPSValidation BIT,
    Descartadas BIT,
    Expirada BIT,
    Cancelada BIT,
    Validada BIT,
    Entrevistador VARCHAR(50)
)

-- Insertar datos de las últimas 30 mil encuestas en la tabla temporal
INSERT INTO #encuestas
SELECT TOP 30000 *
FROM [Archivo de Datos]
ORDER BY FechaEncuesta DESC

-- Calcular indicador GPS a nivel de Entrevistador
CREATE TABLE #gps (
    Entrevistador VARCHAR(50),
    GPSIndicador DECIMAL(18,2)
)

INSERT INTO #gps
SELECT Entrevistador, 
    CASE
        WHEN GPSValidation = 1 AND Descartadas = 0 THEN 100
        ELSE 0
    END AS GPSIndicador
FROM #encuestas

-- Calcular indicador Expiradas a nivel de Entrevistador
CREATE TABLE #expiradas (
    Entrevistador VARCHAR(50),
    ExpiradasIndicador DECIMAL(18,2)
)

INSERT INTO #expiradas
SELECT Entrevistador,
    CASE
        WHEN Expirada = 1 AND Validada = 1 THEN 0
        ELSE (1 - CAST(Expirada AS DECIMAL(18,2))/CAST(Validada AS DECIMAL(18,2))) * 100
    END AS ExpiradasIndicador
FROM #encuestas

-- Calcular indicador Canceladas a nivel de Entrevistador
CREATE TABLE #canceladas (
    Entrevistador VARCHAR(50),
    CanceladasIndicador DECIMAL(18,2)
)

INSERT INTO #canceladas
SELECT Entrevistador,
    CASE
        WHEN Cancelada = 1 THEN 0
        ELSE (1 - CAST(Cancelada AS DECIMAL(18,2))/CAST(Validada AS DECIMAL(18,2))) * 100
    END AS CanceladasIndicador
FROM #encuestas

-- Calcular nota y peso para el indicador Calidad a nivel de Entrevistador
CREATE TABLE #calidad (
    Entrevistador VARCHAR(50),
    Nota DECIMAL(18,2),
    Peso DECIMAL(18,2)
)

INSERT INTO #calidad
SELECT Entrevistador,
    CASE
        WHEN GPSIndicador >= 90 THEN 100
        WHEN GPSIndicador >= 70 AND GPSIndicador < 90 THEN GPSIndicador - 40
        ELSE 0
    END 
    + 
    CASE
        WHEN ExpiradasIndicador >= 85 AND ExpiradasIndicador <= 100 THEN (ExpiradasIndicador - 84) * 1.575
        ELSE 0

--Procedmiento 4

CREATE PROCEDURE [dbo].[usp_CalcularIndicadoresEncuestas] 
    @insumo INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @insumo = 1
    BEGIN
        SELECT 
            CONVERT(VARCHAR(7), FechaEncuesta, 120) AS MesAno,
            PaisEjecucion,
            AVG(CASE WHEN GPSValidation = 1 AND Descartadas = 0 THEN 100 ELSE 0 END) AS IndicadorGPS
        FROM 
            Encuestas
        GROUP BY 
            CONVERT(VARCHAR(7), FechaEncuesta, 120),
            PaisEjecucion
    END

    IF @insumo = 2
    BEGIN
        SELECT 
            PaisEjecucion,
            AVG(CASE WHEN GPSValidation = 1 AND Descartadas = 0 THEN 100 ELSE 0 END) AS IndicadorGPS,
            AVG((1 - CONVERT(FLOAT, Expirada)) / CONVERT(FLOAT, Validada) * 100) AS IndicadorExpiradas,
            AVG((1 - CONVERT(FLOAT, Cancelada)) / CONVERT(FLOAT, Validada) * 100 * 
            CASE WHEN EXISTS(SELECT * FROM Encuestas WHERE Cancelada = 1 AND EntrevistadorID = e.EntrevistadorID) THEN 0 ELSE 0.5 END) AS IndicadorCanceladas
        FROM 
            Encuestas e
        GROUP BY 
            PaisEjecucion
    END

    IF @insumo = 3
    BEGIN
        SELECT 
            PaisEjecucion,
            CASE 
                WHEN AVG(CASE WHEN GPSValidation = 1 AND Descartadas = 0 THEN 100 ELSE 0 END) >= 90 THEN 25
                WHEN AVG(CASE WHEN GPSValidation BETWEEN 70 AND 89 AND Descartadas = 0 THEN 100 ELSE 0 END) > 0 THEN AVG(CASE WHEN GPSValidation BETWEEN 70 AND 89 AND Descartadas = 0 THEN 100 ELSE 0 END) * 0.01
                ELSE 0
            END +
            CASE 
                WHEN AVG(CASE WHEN Expirada = 1 THEN 0 ELSE 1 END) * 100 >= 85 THEN 1.575 * (AVG(CASE WHEN Expirada = 1 THEN 0 ELSE 1 END) * 100 - 85)
                ELSE 0
            END +
            CASE 
                WHEN EXISTS(SELECT * FROM Encuestas WHERE Cancelada = 1 AND PaisEjecucion = e.PaisEjecucion AND EntrevistadorID = e.EntrevistadorID) THEN 0
                WHEN AVG(CASE WHEN Cancelada = 1 THEN 0 ELSE 1 END) * 100 >= 50 THEN 0.5
                ELSE 0
            END AS IndicadorCalidad
        FROM 
            Encuestas e
        GROUP BY 
            PaisEjecucion
    END

END

--PROCEDIMENTO FUNCIONAL

CREATE PROCEDURE CalcularIndicadoresEncuestas
    @insumo INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @insumo = 1
		BEGIN
			-- Eliminar datos existentes de la tabla indicadores
			DELETE FROM IndicadorGPS;

			INSERT INTO IndicadorGPS (Ano, Mes, Entrevistador, PaisEjecucion, Indicador)
			SELECT Ano, Mes, Entrevistador, PaisEjecucion,
			CAST((SUM(CASE WHEN GPSValidation = 1 AND Descartadas = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS DECIMAL(10,2)) AS Indicador
			FROM Encuesta
			GROUP BY Ano, Mes, Entrevistador, PaisEjecucion
			ORDER BY Ano, Mes;

			SELECT * FROM IndicadorGPS;
		END

    IF @insumo = 2
    BEGIN

		-- Eliminar datos existentes de la tabla indicadores
		DELETE FROM IndicadorEXP;

		INSERT INTO IndicadorEXP (Ano, Mes, Entrevistador, PaisEjecucion, Indicador)
        SELECT Ano, Mes, Entrevistador, PaisEjecucion,
		(CASE 
			WHEN SUM(Validadas) = 0 THEN 0 
			ELSE CAST((1 - (SUM(CASE WHEN Expirada = 1 AND Validadas = 1 THEN 1 ELSE 0 END) / SUM(Validadas))) * 100 AS DECIMAL(10,2)) 
			END) AS Indicador
		FROM Encuesta
		GROUP BY Ano, Mes, Entrevistador, PaisEjecucion
		ORDER BY Ano, Mes;

		SELECT * FROM IndicadorEXP;
    END

	IF @insumo = 3
    BEGIN

		-- Eliminar datos existentes de la tabla indicadores
		DELETE FROM IndicadorCAN;

		INSERT INTO IndicadorCAN (Ano, Mes, Entrevistador, PaisEjecucion, Indicador)
        SELECT Ano, Mes, Entrevistador, PaisEjecucion,
		(CASE 
		WHEN SUM(Validadas) = 0 THEN 0 
			ELSE CAST((1 - (SUM(CASE WHEN Cancelada = 1 AND Validadas = 1 THEN 1 ELSE 0 END) / SUM(Validadas))) * 100 AS DECIMAL(10,2))
			END) AS Indicador
		FROM Encuesta
		GROUP BY Ano, Mes, Entrevistador, PaisEjecucion
		ORDER BY Ano, Mes;

		SELECT * FROM IndicadorCAN;
    END

    IF @insumo = 4
    BEGIN

		CREATE TABLE tmpResultados (
			PaisEjecucion VARCHAR(50),
			IndicadorGPS DECIMAL(10,2),
			IndicadorExpiradas DECIMAL(10,2),
			IndicadorCanceladas DECIMAL(10,2)
		);

		INSERT INTO tmpResultados (PaisEjecucion, IndicadorGPS, IndicadorExpiradas, IndicadorCanceladas)
        SELECT PaisEjecucion, 
		CAST(AVG(IndicadorGPS) AS DECIMAL(10,2)) AS IndicadorGPS, 
		CAST(AVG(IndicadorExpiradas) AS DECIMAL(10, 2)) AS IndicadorExpiradas, 
		CAST(AVG(IndicadorCanceladas) AS DECIMAL(10, 2)) AS IndicadorCanceladas
		FROM (
			SELECT e.PaisEjecucion, gps.Ano, gps.Mes, gps.Entrevistador, gps.Indicador AS IndicadorGPS, ex.Indicador AS IndicadorExpiradas, can.Indicador AS IndicadorCanceladas
			FROM Encuesta e
			LEFT JOIN IndicadorGPS gps ON e.Entrevistador = gps.Entrevistador AND e.Ano = gps.Ano AND e.Mes = gps.Mes
			LEFT JOIN IndicadorEXP ex ON e.Entrevistador = ex.Entrevistador AND e.Ano = ex.Ano AND e.Mes = ex.Mes
			LEFT JOIN IndicadorCAN can ON e.Entrevistador = can.Entrevistador AND e.Ano = can.Ano AND e.Mes = can.Mes
		) AS tmp
		GROUP BY PaisEjecucion

		SELECT * FROM tmpResultados;
		
		DROP TABLE tmpResultados;
    END

	IF @insumo = 5
	BEGIN
		
		CREATE TABLE tmpResultados (
			PaisEjecucion VARCHAR(50),
			IndicadorCalidad DECIMAL(10,2)
		);
		
		INSERT INTO tmpResultados (PaisEjecucion, IndicadorCalidad)
		SELECT PaisEjecucion, 
        CAST(AVG(CASE 
                WHEN IndicadorGPS < 70 THEN 0 
                WHEN IndicadorGPS < 90 THEN 1 
                ELSE 25 
            END
            * CASE 
                WHEN NULLIF(CAST(Validadas AS float), 0) = 0 THEN 0
                WHEN Validadas > 0 AND CAST(Expirada AS float) / NULLIF(CAST(Validadas AS float), 0) >= 0.85 AND CAST(Expirada AS float) / NULLIF(CAST(Validadas AS float), 0) <= 1 THEN 1.575 * (CAST(Expirada AS float) / NULLIF(CAST(Validadas AS float), 0) - 0.85) * 100 
                ELSE 0 
            END
            * CASE 
                WHEN Cancelada = 1 THEN 0 
                ELSE 0.5 
            END) AS DECIMAL(10, 2)) AS IndicadorCalidad
		FROM (
			SELECT e.PaisEjecucion, e.Expirada, e.Cancelada, e.Validadas,gps.Ano, gps.Mes, gps.Entrevistador, gps.Indicador AS IndicadorGPS, ex.Indicador AS IndicadorExpiradas, can.Indicador AS IndicadorCanceladas
			FROM Encuesta e
			LEFT JOIN IndicadorGPS gps ON e.Entrevistador = gps.Entrevistador AND e.Ano = gps.Ano AND e.Mes = gps.Mes
			LEFT JOIN IndicadorEXP ex ON e.Entrevistador = ex.Entrevistador AND e.Ano = ex.Ano AND e.Mes = ex.Mes
			LEFT JOIN IndicadorCAN can ON e.Entrevistador = can.Entrevistador AND e.Ano = can.Ano AND e.Mes = can.Mes
		) AS tmp
		GROUP BY PaisEjecucion;

		SELECT * FROM tmpResultados;
		
		DROP TABLE tmpResultados;

    END

END;

