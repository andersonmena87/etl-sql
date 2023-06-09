USE [master]
GO
/****** Object:  Database [Encuestas]    Script Date: 14/04/2023 8:02:04 a. m. ******/
CREATE DATABASE [Encuestas]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Encuestas', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER1\MSSQL\DATA\Encuestas.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Encuestas_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER1\MSSQL\DATA\Encuestas_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Encuestas] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Encuestas].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Encuestas] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Encuestas] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Encuestas] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Encuestas] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Encuestas] SET ARITHABORT OFF 
GO
ALTER DATABASE [Encuestas] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Encuestas] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Encuestas] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Encuestas] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Encuestas] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Encuestas] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Encuestas] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Encuestas] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Encuestas] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Encuestas] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Encuestas] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Encuestas] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Encuestas] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Encuestas] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Encuestas] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Encuestas] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Encuestas] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Encuestas] SET RECOVERY FULL 
GO
ALTER DATABASE [Encuestas] SET  MULTI_USER 
GO
ALTER DATABASE [Encuestas] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Encuestas] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Encuestas] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Encuestas] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Encuestas] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Encuestas] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Encuestas', N'ON'
GO
ALTER DATABASE [Encuestas] SET QUERY_STORE = OFF
GO
USE [Encuestas]
GO
/****** Object:  Table [dbo].[Encuesta]    Script Date: 14/04/2023 8:02:05 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Encuesta](
	[SubjectID] [float] NULL,
	[DPEncargado] [nvarchar](255) NULL,
	[EstadoTicket] [nvarchar](255) NULL,
	[JobId] [nvarchar](255) NULL,
	[IdPropuesta] [float] NULL,
	[Gerente] [nvarchar](255) NULL,
	[Muestra] [float] NULL,
	[PaisEjecucion] [nvarchar](255) NULL,
	[PaisVenta] [nvarchar](255) NULL,
	[TipoEstudio] [nvarchar](255) NULL,
	[Tecnica] [nvarchar](255) NULL,
	[Plataforma] [nvarchar](255) NULL,
	[FechaInicioEstimada] [datetime] NULL,
	[FechaFinEstimada] [datetime] NULL,
	[Programa] [nvarchar](255) NULL,
	[Entrevistador] [nvarchar](255) NULL,
	[DiaCarga] [datetime] NULL,
	[Dia] [float] NULL,
	[Mes] [float] NULL,
	[Ano] [float] NULL,
	[EstatusEncuesta] [nvarchar](255) NULL,
	[Test] [nvarchar](255) NULL,
	[VisitStart] [datetime] NULL,
	[VisitEnd] [datetime] NULL,
	[QualityControlFlag] [nvarchar](255) NULL,
	[IsFiltered] [float] NULL,
	[Cancelada] [float] NULL,
	[Expirada] [float] NULL,
	[Validadas] [float] NULL,
	[GPSValidation] [float] NULL,
	[Descartadas] [float] NULL,
	[ClientDuration] [datetime] NULL,
	[TiempoEntreEncuesta] [float] NULL,
	[DuracionMinutos] [float] NULL,
	[IncidenciaFiltro] [float] NULL,
	[CuentasClave] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IndicadorCAN]    Script Date: 14/04/2023 8:02:05 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IndicadorCAN](
	[Ano] [int] NULL,
	[Mes] [int] NULL,
	[Entrevistador] [nvarchar](50) NULL,
	[PaisEjecucion] [nvarchar](250) NULL,
	[Indicador] [decimal](10, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IndicadorEXP]    Script Date: 14/04/2023 8:02:05 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IndicadorEXP](
	[Ano] [int] NULL,
	[Mes] [int] NULL,
	[Entrevistador] [nvarchar](50) NULL,
	[PaisEjecucion] [nvarchar](250) NULL,
	[Indicador] [decimal](10, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IndicadorGPS]    Script Date: 14/04/2023 8:02:05 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IndicadorGPS](
	[Ano] [int] NULL,
	[Mes] [int] NULL,
	[Entrevistador] [nvarchar](50) NULL,
	[PaisEjecucion] [nvarchar](250) NULL,
	[Indicador] [decimal](10, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[CalcularIndicadoresEncuestas]    Script Date: 14/04/2023 8:02:05 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CalcularIndicadoresEncuestas]
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

			SELECT Ano, Mes, Entrevistador, PaisEjecucion, Indicador AS IndicadorGPS FROM IndicadorGPS;
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

		SELECT Ano, Mes, Entrevistador, PaisEjecucion, Indicador AS IndicadorExpiradas FROM IndicadorEXP;
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

		SELECT Ano, Mes, Entrevistador, PaisEjecucion, Indicador AS IndicadorCanceladas FROM IndicadorCAN;
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
GO
USE [master]
GO
ALTER DATABASE [Encuestas] SET  READ_WRITE 
GO
