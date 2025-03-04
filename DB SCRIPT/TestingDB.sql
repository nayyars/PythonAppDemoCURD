USE [TestingDB]
GO
/****** Object:  StoredProcedure [dbo].[UpdateTestData]    Script Date: 13-01-2025 17:29:14 ******/
DROP PROCEDURE IF EXISTS [dbo].[UpdateTestData]
GO
/****** Object:  StoredProcedure [dbo].[SearchTestData]    Script Date: 13-01-2025 17:29:14 ******/
DROP PROCEDURE IF EXISTS [dbo].[SearchTestData]
GO
/****** Object:  Table [dbo].[TestResult]    Script Date: 13-01-2025 17:29:14 ******/
DROP TABLE IF EXISTS [dbo].[TestResult]
GO
USE [master]
GO
/****** Object:  Database [TestingDB]    Script Date: 13-01-2025 17:29:14 ******/
DROP DATABASE IF EXISTS [TestingDB]
GO
/****** Object:  Database [TestingDB]    Script Date: 13-01-2025 17:29:14 ******/
CREATE DATABASE [TestingDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TestingDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MODIINDIA\MSSQL\DATA\TestingDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'TestingDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MODIINDIA\MSSQL\DATA\TestingDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [TestingDB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TestingDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TestingDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TestingDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TestingDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TestingDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TestingDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [TestingDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TestingDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TestingDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TestingDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TestingDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TestingDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TestingDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TestingDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TestingDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TestingDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TestingDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TestingDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TestingDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TestingDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TestingDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TestingDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TestingDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TestingDB] SET RECOVERY FULL 
GO
ALTER DATABASE [TestingDB] SET  MULTI_USER 
GO
ALTER DATABASE [TestingDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TestingDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TestingDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TestingDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TestingDB] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'TestingDB', N'ON'
GO
ALTER DATABASE [TestingDB] SET QUERY_STORE = OFF
GO
USE [TestingDB]
GO
/****** Object:  Table [dbo].[TestResult]    Script Date: 13-01-2025 17:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TestResult](
	[TestID] [bigint] IDENTITY(1,1) NOT NULL,
	[TestName] [nvarchar](max) NULL,
	[TestCode] [nvarchar](12) NULL,
	[ReferenceRange] [nvarchar](max) NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [nvarchar](30) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[TestResult] ON 

INSERT [dbo].[TestResult] ([TestID], [TestName], [TestCode], [ReferenceRange], [ModifiedDate], [ModifiedBy]) VALUES (10024, N'Urea, plasma (BUN)', N'6568', N'	8-25 mg/dL', NULL, NULL)
INSERT [dbo].[TestResult] ([TestID], [TestName], [TestCode], [ReferenceRange], [ModifiedDate], [ModifiedBy]) VALUES (10025, N'Urinalysis: pH Specific gravity', N'787', N'1.001-1.035', NULL, NULL)
INSERT [dbo].[TestResult] ([TestID], [TestName], [TestCode], [ReferenceRange], [ModifiedDate], [ModifiedBy]) VALUES (10026, N'WBC (White blood cells, Leukocytes)', N'7878', N'4.5-17.0 x 103/mm3', NULL, NULL)
INSERT [dbo].[TestResult] ([TestID], [TestName], [TestCode], [ReferenceRange], [ModifiedDate], [ModifiedBy]) VALUES (10033, N'Hemoglobin', N'8898', N'2.1–15.1 g/dL', NULL, NULL)
INSERT [dbo].[TestResult] ([TestID], [TestName], [TestCode], [ReferenceRange], [ModifiedDate], [ModifiedBy]) VALUES (10034, N'Hematocrit', N'676', N'41–50%', NULL, NULL)
SET IDENTITY_INSERT [dbo].[TestResult] OFF
/****** Object:  StoredProcedure [dbo].[SearchTestData]    Script Date: 13-01-2025 17:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SearchTestData]
    @TestName NVARCHAR(MAX) = NULL,
    @TestCode NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * 
    FROM TestResult 
    WHERE 1=1
        AND (@TestName IS NULL OR TestName LIKE '%' + @TestName + '%')
        AND (@TestCode IS NULL OR TestCode LIKE '%' + @TestCode + '%')
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateTestData]    Script Date: 13-01-2025 17:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[UpdateTestData]
    @TestID bigint ,
    @TestName NVARCHAR(MAX) = NULL,
    @TestCode NVARCHAR(MAX) = NULL,
	@ReferenceRange NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare a result set
    UPDATE TestResult
    SET 
        TestName = ISNULL(@TestName, TestName), -- Update only if a value is provided
        TestCode = ISNULL(@TestCode, TestCode),
        ReferenceRange = ISNULL(@ReferenceRange, ReferenceRange)
    WHERE 
        TestID = @TestID; 
END
GO
USE [master]
GO
ALTER DATABASE [TestingDB] SET  READ_WRITE 
GO
