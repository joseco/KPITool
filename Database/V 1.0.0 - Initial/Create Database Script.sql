USE [master]
GO
/****** Object:  Database [KPIDB]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE DATABASE [KPIDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'KPIDB', FILENAME = N'C:\Databasesfiles\KPIDB.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'KPIDB_log', FILENAME = N'C:\Databasesfiles\KPIDB_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [KPIDB] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [KPIDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [KPIDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [KPIDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [KPIDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [KPIDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [KPIDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [KPIDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [KPIDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [KPIDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [KPIDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [KPIDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [KPIDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [KPIDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [KPIDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [KPIDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [KPIDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [KPIDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [KPIDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [KPIDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [KPIDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [KPIDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [KPIDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [KPIDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [KPIDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [KPIDB] SET  MULTI_USER 
GO
ALTER DATABASE [KPIDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [KPIDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [KPIDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [KPIDB] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [KPIDB] SET DELAYED_DURABILITY = DISABLED 
GO
USE [KPIDB]
GO
/****** Object:  DatabaseRole [aspnet_WebEvent_FullAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE ROLE [aspnet_WebEvent_FullAccess]
GO
/****** Object:  DatabaseRole [aspnet_Roles_ReportingAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE ROLE [aspnet_Roles_ReportingAccess]
GO
/****** Object:  DatabaseRole [aspnet_Roles_FullAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE ROLE [aspnet_Roles_FullAccess]
GO
/****** Object:  DatabaseRole [aspnet_Roles_BasicAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE ROLE [aspnet_Roles_BasicAccess]
GO
/****** Object:  DatabaseRole [aspnet_Profile_ReportingAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE ROLE [aspnet_Profile_ReportingAccess]
GO
/****** Object:  DatabaseRole [aspnet_Profile_FullAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE ROLE [aspnet_Profile_FullAccess]
GO
/****** Object:  DatabaseRole [aspnet_Profile_BasicAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE ROLE [aspnet_Profile_BasicAccess]
GO
/****** Object:  DatabaseRole [aspnet_Personalization_ReportingAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE ROLE [aspnet_Personalization_ReportingAccess]
GO
/****** Object:  DatabaseRole [aspnet_Personalization_FullAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE ROLE [aspnet_Personalization_FullAccess]
GO
/****** Object:  DatabaseRole [aspnet_Personalization_BasicAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE ROLE [aspnet_Personalization_BasicAccess]
GO
/****** Object:  DatabaseRole [aspnet_Membership_ReportingAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE ROLE [aspnet_Membership_ReportingAccess]
GO
/****** Object:  DatabaseRole [aspnet_Membership_FullAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE ROLE [aspnet_Membership_FullAccess]
GO
/****** Object:  DatabaseRole [aspnet_Membership_BasicAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE ROLE [aspnet_Membership_BasicAccess]
GO
ALTER ROLE [aspnet_Roles_BasicAccess] ADD MEMBER [aspnet_Roles_FullAccess]
GO
ALTER ROLE [aspnet_Roles_ReportingAccess] ADD MEMBER [aspnet_Roles_FullAccess]
GO
ALTER ROLE [aspnet_Profile_BasicAccess] ADD MEMBER [aspnet_Profile_FullAccess]
GO
ALTER ROLE [aspnet_Profile_ReportingAccess] ADD MEMBER [aspnet_Profile_FullAccess]
GO
ALTER ROLE [aspnet_Personalization_BasicAccess] ADD MEMBER [aspnet_Personalization_FullAccess]
GO
ALTER ROLE [aspnet_Personalization_ReportingAccess] ADD MEMBER [aspnet_Personalization_FullAccess]
GO
ALTER ROLE [aspnet_Membership_BasicAccess] ADD MEMBER [aspnet_Membership_FullAccess]
GO
ALTER ROLE [aspnet_Membership_ReportingAccess] ADD MEMBER [aspnet_Membership_FullAccess]
GO
/****** Object:  Schema [aspnet_Membership_BasicAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE SCHEMA [aspnet_Membership_BasicAccess]
GO
/****** Object:  Schema [aspnet_Membership_FullAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE SCHEMA [aspnet_Membership_FullAccess]
GO
/****** Object:  Schema [aspnet_Membership_ReportingAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE SCHEMA [aspnet_Membership_ReportingAccess]
GO
/****** Object:  Schema [aspnet_Personalization_BasicAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE SCHEMA [aspnet_Personalization_BasicAccess]
GO
/****** Object:  Schema [aspnet_Personalization_FullAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE SCHEMA [aspnet_Personalization_FullAccess]
GO
/****** Object:  Schema [aspnet_Personalization_ReportingAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE SCHEMA [aspnet_Personalization_ReportingAccess]
GO
/****** Object:  Schema [aspnet_Profile_BasicAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE SCHEMA [aspnet_Profile_BasicAccess]
GO
/****** Object:  Schema [aspnet_Profile_FullAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE SCHEMA [aspnet_Profile_FullAccess]
GO
/****** Object:  Schema [aspnet_Profile_ReportingAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE SCHEMA [aspnet_Profile_ReportingAccess]
GO
/****** Object:  Schema [aspnet_Roles_BasicAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE SCHEMA [aspnet_Roles_BasicAccess]
GO
/****** Object:  Schema [aspnet_Roles_FullAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE SCHEMA [aspnet_Roles_FullAccess]
GO
/****** Object:  Schema [aspnet_Roles_ReportingAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE SCHEMA [aspnet_Roles_ReportingAccess]
GO
/****** Object:  Schema [aspnet_WebEvent_FullAccess]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE SCHEMA [aspnet_WebEvent_FullAccess]
GO
/****** Object:  UserDefinedFunction [dbo].[svf_DateOnly]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[svf_DateOnly](@DateTime DateTime)
-- Strips out the time portion of any dateTime value.
RETURNS DATETIME
-- ENCRYPT_ME
AS BEGIN
    RETURN dateadd(dd,0, datediff(dd,0,@DateTime))
END


GO
/****** Object:  UserDefinedFunction [dbo].[tvf_SplitStringInIntTable]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[tvf_SplitStringInIntTable]
(
	@varString VARCHAR(MAX),
    @varDelimiter VARCHAR(5)
)
RETURNS @tblSplittedValues TABLE
(
  splitvalue VARCHAR(8000)
)
AS
BEGIN
 DECLARE @intSplitLength INT

 WHILE LEN(@varString) > 0
  BEGIN
    SELECT @intSplitLength = 
     (CASE CHARINDEX(@varDelimiter,@varString) 
     WHEN 0 THEN
      LEN(@varString) 
     ELSE CHARINDEX(@varDelimiter,@varString) -1  
     END)

    INSERT INTO @tblSplittedValues
    SELECT SUBSTRING(@varString,1,@intSplitLength)

    SELECT @varString = 
     (CASE (LEN(@varString) - @intSplitLength) 
      WHEN 0 THEN ''
      ELSE 
       RIGHT(@varString, LEN(@varString) - @intSplitLength - 1) 
     END)
  END
 RETURN
END 



GO
/****** Object:  Table [dbo].[aspnet_Applications]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_Applications](
	[ApplicationName] [nvarchar](256) NOT NULL,
	[LoweredApplicationName] [nvarchar](256) NOT NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[Description] [nvarchar](256) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [aspnet_Applications_Index]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE CLUSTERED INDEX [aspnet_Applications_Index] ON [dbo].[aspnet_Applications]
(
	[LoweredApplicationName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[aspnet_Membership]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_Membership](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Password] [nvarchar](128) NOT NULL,
	[PasswordFormat] [int] NOT NULL,
	[PasswordSalt] [nvarchar](128) NOT NULL,
	[MobilePIN] [nvarchar](16) NULL,
	[Email] [nvarchar](256) NULL,
	[LoweredEmail] [nvarchar](256) NULL,
	[PasswordQuestion] [nvarchar](256) NULL,
	[PasswordAnswer] [nvarchar](128) NULL,
	[IsApproved] [bit] NOT NULL,
	[IsLockedOut] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastLoginDate] [datetime] NOT NULL,
	[LastPasswordChangedDate] [datetime] NOT NULL,
	[LastLockoutDate] [datetime] NOT NULL,
	[FailedPasswordAttemptCount] [int] NOT NULL,
	[FailedPasswordAttemptWindowStart] [datetime] NOT NULL,
	[FailedPasswordAnswerAttemptCount] [int] NOT NULL,
	[FailedPasswordAnswerAttemptWindowStart] [datetime] NOT NULL,
	[Comment] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [aspnet_Membership_index]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE CLUSTERED INDEX [aspnet_Membership_index] ON [dbo].[aspnet_Membership]
(
	[ApplicationId] ASC,
	[LoweredEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[aspnet_Paths]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_Paths](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[PathId] [uniqueidentifier] NOT NULL,
	[Path] [nvarchar](256) NOT NULL,
	[LoweredPath] [nvarchar](256) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [aspnet_Paths_index]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE UNIQUE CLUSTERED INDEX [aspnet_Paths_index] ON [dbo].[aspnet_Paths]
(
	[ApplicationId] ASC,
	[LoweredPath] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[aspnet_PersonalizationAllUsers]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_PersonalizationAllUsers](
	[PathId] [uniqueidentifier] NOT NULL,
	[PageSettings] [image] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PathId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[aspnet_PersonalizationPerUser]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_PersonalizationPerUser](
	[Id] [uniqueidentifier] NOT NULL,
	[PathId] [uniqueidentifier] NULL,
	[UserId] [uniqueidentifier] NULL,
	[PageSettings] [image] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Index [aspnet_PersonalizationPerUser_index1]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE UNIQUE CLUSTERED INDEX [aspnet_PersonalizationPerUser_index1] ON [dbo].[aspnet_PersonalizationPerUser]
(
	[PathId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[aspnet_Profile]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_Profile](
	[UserId] [uniqueidentifier] NOT NULL,
	[PropertyNames] [ntext] NOT NULL,
	[PropertyValuesString] [ntext] NOT NULL,
	[PropertyValuesBinary] [image] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[aspnet_Roles]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_Roles](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
	[RoleName] [nvarchar](256) NOT NULL,
	[LoweredRoleName] [nvarchar](256) NOT NULL,
	[Description] [nvarchar](256) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [aspnet_Roles_index1]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE UNIQUE CLUSTERED INDEX [aspnet_Roles_index1] ON [dbo].[aspnet_Roles]
(
	[ApplicationId] ASC,
	[LoweredRoleName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[aspnet_SchemaVersions]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_SchemaVersions](
	[Feature] [nvarchar](128) NOT NULL,
	[CompatibleSchemaVersion] [nvarchar](128) NOT NULL,
	[IsCurrentVersion] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Feature] ASC,
	[CompatibleSchemaVersion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[aspnet_Users]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_Users](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[LoweredUserName] [nvarchar](256) NOT NULL,
	[MobileAlias] [nvarchar](16) NULL,
	[IsAnonymous] [bit] NOT NULL,
	[LastActivityDate] [datetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [aspnet_Users_Index]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE UNIQUE CLUSTERED INDEX [aspnet_Users_Index] ON [dbo].[aspnet_Users]
(
	[ApplicationId] ASC,
	[LoweredUserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[aspnet_UsersInRoles]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aspnet_UsersInRoles](
	[UserId] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[aspnet_WebEvent_Events]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[aspnet_WebEvent_Events](
	[EventId] [char](32) NOT NULL,
	[EventTimeUtc] [datetime] NOT NULL,
	[EventTime] [datetime] NOT NULL,
	[EventType] [nvarchar](256) NOT NULL,
	[EventSequence] [decimal](19, 0) NOT NULL,
	[EventOccurrence] [decimal](19, 0) NOT NULL,
	[EventCode] [int] NOT NULL,
	[EventDetailCode] [int] NOT NULL,
	[Message] [nvarchar](1024) NULL,
	[ApplicationPath] [nvarchar](256) NULL,
	[ApplicationVirtualPath] [nvarchar](256) NULL,
	[MachineName] [nvarchar](256) NOT NULL,
	[RequestUrl] [nvarchar](1024) NULL,
	[ExceptionType] [nvarchar](256) NULL,
	[Details] [ntext] NULL,
PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_Activity]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Activity](
	[activityID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](250) NOT NULL,
	[organizationID] [int] NOT NULL,
	[areaID] [int] NULL,
	[projectID] [int] NULL,
 CONSTRAINT [PK_tbl_Activity] PRIMARY KEY CLUSTERED 
(
	[activityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_Area]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Area](
	[areaID] [int] IDENTITY(1,1) NOT NULL,
	[organizationID] [int] NOT NULL,
	[name] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_tbl_Area] PRIMARY KEY CLUSTERED 
(
	[areaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_Category]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_Category](
	[categoryID] [varchar](20) NOT NULL,
	[name] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_tbl_Category] PRIMARY KEY CLUSTERED 
(
	[categoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_CategoryItem]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_CategoryItem](
	[categoryItemID] [varchar](20) NOT NULL,
	[categoryID] [varchar](20) NOT NULL,
	[name] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_tbl_CategoryItem] PRIMARY KEY CLUSTERED 
(
	[categoryItemID] ASC,
	[categoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_Currency]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_Currency](
	[currencyID] [char](3) NOT NULL,
 CONSTRAINT [PK_tbl_Currency] PRIMARY KEY CLUSTERED 
(
	[currencyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_CurrencyLabels]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_CurrencyLabels](
	[currencyID] [char](3) NOT NULL,
	[language] [char](2) NOT NULL,
	[name] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_tbl_CurencyLabels] PRIMARY KEY CLUSTERED 
(
	[currencyID] ASC,
	[language] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_CurrencyUnits]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_CurrencyUnits](
	[currencyUnitID] [char](3) NOT NULL,
 CONSTRAINT [PK_tbl_CurrencyUnits_1] PRIMARY KEY CLUSTERED 
(
	[currencyUnitID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_CurrencyUnitsLabels]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_CurrencyUnitsLabels](
	[currencyUnitID] [char](3) NOT NULL,
	[language] [char](2) NOT NULL,
	[name] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_tbl_CurrencyUnitsLabels] PRIMARY KEY CLUSTERED 
(
	[currencyUnitID] ASC,
	[language] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_DatabaseInfo]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_DatabaseInfo](
	[majorversion] [smallint] NOT NULL,
	[minorversion] [smallint] NOT NULL,
	[releaseversion] [smallint] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_Direction]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_Direction](
	[directionID] [char](3) NOT NULL,
 CONSTRAINT [PK_tbl_Direction] PRIMARY KEY CLUSTERED 
(
	[directionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_DirectionLabels]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_DirectionLabels](
	[directionID] [char](3) NOT NULL,
	[language] [char](2) NOT NULL,
	[name] [nchar](10) NULL,
 CONSTRAINT [PK_tbl_DirectionLabels] PRIMARY KEY CLUSTERED 
(
	[directionID] ASC,
	[language] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_KPI]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_KPI](
	[kpiID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](250) NOT NULL,
	[organizationID] [int] NULL,
	[areaID] [int] NULL,
	[projectID] [int] NULL,
	[activityID] [int] NULL,
	[personID] [int] NULL,
	[unitID] [varchar](10) NOT NULL,
	[directionID] [char](3) NOT NULL,
	[strategyID] [char](3) NOT NULL,
	[startDate] [date] NULL,
	[reportingUnitID] [char](5) NOT NULL,
	[targetPeriod] [int] NULL,
	[allowsCategories] [bit] NOT NULL,
	[currency] [char](3) NULL,
	[currencyUnitID] [char](3) NULL,
 CONSTRAINT [PK_tbl_KPI] PRIMARY KEY CLUSTERED 
(
	[kpiID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_KPICategories]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_KPICategories](
	[kpiID] [int] NOT NULL,
	[categoryID] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tbl_KPICategories_1] PRIMARY KEY CLUSTERED 
(
	[kpiID] ASC,
	[categoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_KPIMeasurementCategories]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_KPIMeasurementCategories](
	[measurementID] [int] NOT NULL,
	[categoryItemID] [varchar](20) NOT NULL,
	[categoryID] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tbl_KPIMeasurementCategories] PRIMARY KEY CLUSTERED 
(
	[measurementID] ASC,
	[categoryItemID] ASC,
	[categoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_KPIMeasurements]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_KPIMeasurements](
	[measurmentID] [int] IDENTITY(1,1) NOT NULL,
	[kpiID] [int] NOT NULL,
	[date] [date] NOT NULL,
	[measurement] [decimal](21, 3) NOT NULL,
 CONSTRAINT [PK_tbl_KPICategoryMeasurements] PRIMARY KEY CLUSTERED 
(
	[measurmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_KPITarget]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_KPITarget](
	[targetID] [int] IDENTITY(1,1) NOT NULL,
	[kpiID] [int] NOT NULL,
	[target] [decimal](21, 3) NOT NULL,
 CONSTRAINT [PK_tbl_KPITargets] PRIMARY KEY CLUSTERED 
(
	[targetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_KPITargetCategories]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_KPITargetCategories](
	[targetID] [int] NOT NULL,
	[categoryItemID] [varchar](20) NOT NULL,
	[categoryID] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tbl_KPICategoryTargets] PRIMARY KEY CLUSTERED 
(
	[targetID] ASC,
	[categoryItemID] ASC,
	[categoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_KPITypes]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_KPITypes](
	[kpiTypeID] [varchar](10) NOT NULL,
	[directionID] [char](3) NOT NULL,
	[strategyID] [char](3) NOT NULL,
	[unitID] [varchar](10) NOT NULL,
 CONSTRAINT [PK_tbl_kpiTypes] PRIMARY KEY CLUSTERED 
(
	[kpiTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_KPITypesLabels]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_KPITypesLabels](
	[kpiTypeID] [varchar](10) NOT NULL,
	[language] [char](2) NOT NULL,
	[typeName] [nvarchar](250) NOT NULL,
	[description] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_tbl_KPITypesLabels] PRIMARY KEY CLUSTERED 
(
	[kpiTypeID] ASC,
	[language] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_Language]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_Language](
	[languageID] [char](2) NOT NULL,
	[languageName] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_tbl_Language] PRIMARY KEY CLUSTERED 
(
	[languageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_Organization]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Organization](
	[organizationID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_tbl_Organization] PRIMARY KEY CLUSTERED 
(
	[organizationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_People]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_People](
	[personID] [int] IDENTITY(1,1) NOT NULL,
	[id] [nvarchar](50) NOT NULL,
	[name] [nvarchar](250) NOT NULL,
	[organizationID] [int] NOT NULL,
	[areaID] [int] NULL,
 CONSTRAINT [PK_tbl_People] PRIMARY KEY CLUSTERED 
(
	[personID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_Project]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Project](
	[projectID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](250) NOT NULL,
	[organizationID] [int] NOT NULL,
	[areaID] [int] NULL,
 CONSTRAINT [PK_tbl_Project] PRIMARY KEY CLUSTERED 
(
	[projectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_ReportingUnit]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_ReportingUnit](
	[reportingUnitID] [char](5) NOT NULL,
 CONSTRAINT [PK_tbl_ReportingUnit] PRIMARY KEY CLUSTERED 
(
	[reportingUnitID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_ReportingUnitLabels]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_ReportingUnitLabels](
	[reportingUnitID] [char](5) NOT NULL,
	[language] [char](2) NOT NULL,
	[name] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_tbl_ReportingUnitLabels] PRIMARY KEY CLUSTERED 
(
	[reportingUnitID] ASC,
	[language] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_SEG_AccessRole]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_SEG_AccessRole](
	[permissionID] [int] NOT NULL,
	[role] [varchar](100) NOT NULL,
 CONSTRAINT [PK_tbl_SEG_AccessRole] PRIMARY KEY CLUSTERED 
(
	[permissionID] ASC,
	[role] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_SEG_AccessUser]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_SEG_AccessUser](
	[permissionID] [int] NOT NULL,
	[userID] [int] NOT NULL,
 CONSTRAINT [PK_tbl_SEG_AccessUser] PRIMARY KEY CLUSTERED 
(
	[permissionID] ASC,
	[userID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_SEG_ObjectActions]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_SEG_ObjectActions](
	[objectActionID] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tbl_SEG_ObjectActions] PRIMARY KEY CLUSTERED 
(
	[objectActionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_SEG_ObjectPermissions]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_SEG_ObjectPermissions](
	[objectTypeID] [varchar](20) NOT NULL,
	[objectID] [int] NOT NULL,
	[username] [varchar](50) NOT NULL,
	[objectActionID] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tbl_SEG_ObjectPermissions] PRIMARY KEY CLUSTERED 
(
	[objectTypeID] ASC,
	[objectID] ASC,
	[username] ASC,
	[objectActionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_SEG_ObjectTypes]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_SEG_ObjectTypes](
	[objectTypeID] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tbl_SEG_ObjectTypes] PRIMARY KEY CLUSTERED 
(
	[objectTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_SEG_Permission]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_SEG_Permission](
	[permissionID] [int] NOT NULL,
	[mnemonic] [varchar](100) NOT NULL,
	[description] [varchar](250) NULL,
 CONSTRAINT [PK_tbl_SEG_Permissions] PRIMARY KEY CLUSTERED 
(
	[permissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_SEG_User]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_SEG_User](
	[userId] [int] IDENTITY(1,1) NOT NULL,
	[fullname] [varchar](500) NOT NULL,
	[cellphone] [varchar](50) NULL,
	[address] [varchar](250) NULL,
	[phonenumber] [varchar](25) NULL,
	[username] [varchar](50) NOT NULL,
	[email] [varchar](100) NOT NULL,
	[phonearea] [int] NULL,
	[phonecode] [int] NULL,
 CONSTRAINT [PK_tbl_SEG_User] PRIMARY KEY CLUSTERED 
(
	[userId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_Strategy]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_Strategy](
	[strategyID] [char](3) NOT NULL,
 CONSTRAINT [PK_tbl_Strategy] PRIMARY KEY CLUSTERED 
(
	[strategyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_StrategyLabels]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_StrategyLabels](
	[strategyID] [char](3) NOT NULL,
	[language] [char](2) NOT NULL,
	[name] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_tbl_StrategyLabels] PRIMARY KEY CLUSTERED 
(
	[strategyID] ASC,
	[language] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_TSK_Manager]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_TSK_Manager](
	[ManagerId] [int] IDENTITY(1,1) NOT NULL,
	[Status] [bit] NOT NULL,
	[SleepTimeSeconds] [bigint] NOT NULL,
	[NumberOfOverlapsAllowed] [int] NOT NULL,
 CONSTRAINT [PK_tbl_TSK_Manager] PRIMARY KEY CLUSTERED 
(
	[ManagerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_TSK_Task]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_TSK_Task](
	[TaskId] [varchar](50) NOT NULL,
	[TaskName] [varchar](50) NOT NULL,
	[TaskDescription] [varchar](200) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[PeriodLengthSeconds] [bigint] NOT NULL,
	[Iterations] [int] NOT NULL,
	[Enabled] [bit] NOT NULL,
	[IterationsExecuted] [int] NOT NULL,
	[LastExecutionDate] [datetime] NULL,
 CONSTRAINT [PK_tbl_TSK_Task] PRIMARY KEY CLUSTERED 
(
	[TaskId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_Unit]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_Unit](
	[unitID] [varchar](10) NOT NULL,
 CONSTRAINT [PK_tbl_Unit] PRIMARY KEY CLUSTERED 
(
	[unitID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_UnitLabels]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_UnitLabels](
	[unitID] [varchar](10) NOT NULL,
	[language] [char](2) NOT NULL,
	[name] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_tbl_UnitLabels] PRIMARY KEY CLUSTERED 
(
	[unitID] ASC,
	[language] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_UnitsAllowedForCurrency]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_UnitsAllowedForCurrency](
	[currencyID] [char](3) NOT NULL,
	[currencyUnitID] [char](3) NOT NULL,
 CONSTRAINT [PK_tbl_UnitsAllowedForCurrency] PRIMARY KEY CLUSTERED 
(
	[currencyID] ASC,
	[currencyUnitID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_ViewState]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_ViewState](
	[ViewStateId] [uniqueidentifier] NOT NULL,
	[Value] [image] NOT NULL,
	[LastAccessed] [datetime] NOT NULL,
	[Timeout] [int] NOT NULL,
 CONSTRAINT [PK_ViewState] PRIMARY KEY CLUSTERED 
(
	[ViewStateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  View [dbo].[vw_aspnet_Applications]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

  CREATE VIEW [dbo].[vw_aspnet_Applications]
  AS SELECT [dbo].[aspnet_Applications].[ApplicationName], [dbo].[aspnet_Applications].[LoweredApplicationName], [dbo].[aspnet_Applications].[ApplicationId], [dbo].[aspnet_Applications].[Description]
  FROM [dbo].[aspnet_Applications]
  
GO
/****** Object:  View [dbo].[vw_aspnet_MembershipUsers]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

  CREATE VIEW [dbo].[vw_aspnet_MembershipUsers]
  AS SELECT [dbo].[aspnet_Membership].[UserId],
            [dbo].[aspnet_Membership].[PasswordFormat],
            [dbo].[aspnet_Membership].[MobilePIN],
            [dbo].[aspnet_Membership].[Email],
            [dbo].[aspnet_Membership].[LoweredEmail],
            [dbo].[aspnet_Membership].[PasswordQuestion],
            [dbo].[aspnet_Membership].[PasswordAnswer],
            [dbo].[aspnet_Membership].[IsApproved],
            [dbo].[aspnet_Membership].[IsLockedOut],
            [dbo].[aspnet_Membership].[CreateDate],
            [dbo].[aspnet_Membership].[LastLoginDate],
            [dbo].[aspnet_Membership].[LastPasswordChangedDate],
            [dbo].[aspnet_Membership].[LastLockoutDate],
            [dbo].[aspnet_Membership].[FailedPasswordAttemptCount],
            [dbo].[aspnet_Membership].[FailedPasswordAttemptWindowStart],
            [dbo].[aspnet_Membership].[FailedPasswordAnswerAttemptCount],
            [dbo].[aspnet_Membership].[FailedPasswordAnswerAttemptWindowStart],
            [dbo].[aspnet_Membership].[Comment],
            [dbo].[aspnet_Users].[ApplicationId],
            [dbo].[aspnet_Users].[UserName],
            [dbo].[aspnet_Users].[MobileAlias],
            [dbo].[aspnet_Users].[IsAnonymous],
            [dbo].[aspnet_Users].[LastActivityDate]
  FROM [dbo].[aspnet_Membership] INNER JOIN [dbo].[aspnet_Users]
      ON [dbo].[aspnet_Membership].[UserId] = [dbo].[aspnet_Users].[UserId]
  
GO
/****** Object:  View [dbo].[vw_aspnet_Profiles]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

  CREATE VIEW [dbo].[vw_aspnet_Profiles]
  AS SELECT [dbo].[aspnet_Profile].[UserId], [dbo].[aspnet_Profile].[LastUpdatedDate],
      [DataSize]=  DATALENGTH([dbo].[aspnet_Profile].[PropertyNames])
                 + DATALENGTH([dbo].[aspnet_Profile].[PropertyValuesString])
                 + DATALENGTH([dbo].[aspnet_Profile].[PropertyValuesBinary])
  FROM [dbo].[aspnet_Profile]
  
GO
/****** Object:  View [dbo].[vw_aspnet_Roles]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

  CREATE VIEW [dbo].[vw_aspnet_Roles]
  AS SELECT [dbo].[aspnet_Roles].[ApplicationId], [dbo].[aspnet_Roles].[RoleId], [dbo].[aspnet_Roles].[RoleName], [dbo].[aspnet_Roles].[LoweredRoleName], [dbo].[aspnet_Roles].[Description]
  FROM [dbo].[aspnet_Roles]
  
GO
/****** Object:  View [dbo].[vw_aspnet_Users]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

  CREATE VIEW [dbo].[vw_aspnet_Users]
  AS SELECT [dbo].[aspnet_Users].[ApplicationId], [dbo].[aspnet_Users].[UserId], [dbo].[aspnet_Users].[UserName], [dbo].[aspnet_Users].[LoweredUserName], [dbo].[aspnet_Users].[MobileAlias], [dbo].[aspnet_Users].[IsAnonymous], [dbo].[aspnet_Users].[LastActivityDate]
  FROM [dbo].[aspnet_Users]
  
GO
/****** Object:  View [dbo].[vw_aspnet_UsersInRoles]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

  CREATE VIEW [dbo].[vw_aspnet_UsersInRoles]
  AS SELECT [dbo].[aspnet_UsersInRoles].[UserId], [dbo].[aspnet_UsersInRoles].[RoleId]
  FROM [dbo].[aspnet_UsersInRoles]
  
GO
/****** Object:  View [dbo].[vw_aspnet_WebPartState_Paths]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

  CREATE VIEW [dbo].[vw_aspnet_WebPartState_Paths]
  AS SELECT [dbo].[aspnet_Paths].[ApplicationId], [dbo].[aspnet_Paths].[PathId], [dbo].[aspnet_Paths].[Path], [dbo].[aspnet_Paths].[LoweredPath]
  FROM [dbo].[aspnet_Paths]
  
GO
/****** Object:  View [dbo].[vw_aspnet_WebPartState_Shared]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

  CREATE VIEW [dbo].[vw_aspnet_WebPartState_Shared]
  AS SELECT [dbo].[aspnet_PersonalizationAllUsers].[PathId], [DataSize]=DATALENGTH([dbo].[aspnet_PersonalizationAllUsers].[PageSettings]), [dbo].[aspnet_PersonalizationAllUsers].[LastUpdatedDate]
  FROM [dbo].[aspnet_PersonalizationAllUsers]
  
GO
/****** Object:  View [dbo].[vw_aspnet_WebPartState_User]    Script Date: 12/4/2016 4:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

  CREATE VIEW [dbo].[vw_aspnet_WebPartState_User]
  AS SELECT [dbo].[aspnet_PersonalizationPerUser].[PathId], [dbo].[aspnet_PersonalizationPerUser].[UserId], [DataSize]=DATALENGTH([dbo].[aspnet_PersonalizationPerUser].[PageSettings]), [dbo].[aspnet_PersonalizationPerUser].[LastUpdatedDate]
  FROM [dbo].[aspnet_PersonalizationPerUser]
  
GO
INSERT [dbo].[aspnet_SchemaVersions] ([Feature], [CompatibleSchemaVersion], [IsCurrentVersion]) VALUES (N'common', N'1', 1)
INSERT [dbo].[aspnet_SchemaVersions] ([Feature], [CompatibleSchemaVersion], [IsCurrentVersion]) VALUES (N'health monitoring', N'1', 1)
INSERT [dbo].[aspnet_SchemaVersions] ([Feature], [CompatibleSchemaVersion], [IsCurrentVersion]) VALUES (N'membership', N'1', 1)
INSERT [dbo].[aspnet_SchemaVersions] ([Feature], [CompatibleSchemaVersion], [IsCurrentVersion]) VALUES (N'personalization', N'1', 1)
INSERT [dbo].[aspnet_SchemaVersions] ([Feature], [CompatibleSchemaVersion], [IsCurrentVersion]) VALUES (N'profile', N'1', 1)
INSERT [dbo].[aspnet_SchemaVersions] ([Feature], [CompatibleSchemaVersion], [IsCurrentVersion]) VALUES (N'role manager', N'1', 1)
INSERT [dbo].[tbl_Category] ([categoryID], [name]) VALUES (N'LOC', N'Location')
INSERT [dbo].[tbl_Category] ([categoryID], [name]) VALUES (N'TAXSEG', N'Taxpayer Segment')
INSERT [dbo].[tbl_CategoryItem] ([categoryItemID], [categoryID], [name]) VALUES (N'AJK', N'LOC', N'Azad Jammu & Kashmir')
INSERT [dbo].[tbl_CategoryItem] ([categoryItemID], [categoryID], [name]) VALUES (N'BN', N'LOC', N'Balochistan')
INSERT [dbo].[tbl_CategoryItem] ([categoryItemID], [categoryID], [name]) VALUES (N'FATA', N'LOC', N'Federally Administered Tribal Areas')
INSERT [dbo].[tbl_CategoryItem] ([categoryItemID], [categoryID], [name]) VALUES (N'GB', N'LOC', N'Gilgit-Baltistan')
INSERT [dbo].[tbl_CategoryItem] ([categoryItemID], [categoryID], [name]) VALUES (N'ICT', N'LOC', N'Islamabad Capital Territory')
INSERT [dbo].[tbl_CategoryItem] ([categoryItemID], [categoryID], [name]) VALUES (N'KP', N'LOC', N'Khyber Pakhtunkhwa')
INSERT [dbo].[tbl_CategoryItem] ([categoryItemID], [categoryID], [name]) VALUES (N'LTU', N'TAXSEG', N'Large Taxpayer Unit')
INSERT [dbo].[tbl_CategoryItem] ([categoryItemID], [categoryID], [name]) VALUES (N'PB', N'LOC', N'Punjab')
INSERT [dbo].[tbl_CategoryItem] ([categoryItemID], [categoryID], [name]) VALUES (N'RTO', N'TAXSEG', N'Other Taxpayers')
INSERT [dbo].[tbl_CategoryItem] ([categoryItemID], [categoryID], [name]) VALUES (N'SD', N'LOC', N'Sindh')
INSERT [dbo].[tbl_Currency] ([currencyID]) VALUES (N'EUR')
INSERT [dbo].[tbl_Currency] ([currencyID]) VALUES (N'PKR')
INSERT [dbo].[tbl_Currency] ([currencyID]) VALUES (N'USD')
INSERT [dbo].[tbl_CurrencyLabels] ([currencyID], [language], [name]) VALUES (N'EUR', N'EN', N'€')
INSERT [dbo].[tbl_CurrencyLabels] ([currencyID], [language], [name]) VALUES (N'EUR', N'ES', N'€')
INSERT [dbo].[tbl_CurrencyLabels] ([currencyID], [language], [name]) VALUES (N'PKR', N'EN', N'Rs.')
INSERT [dbo].[tbl_CurrencyLabels] ([currencyID], [language], [name]) VALUES (N'PKR', N'ES', N'Rs.')
INSERT [dbo].[tbl_CurrencyLabels] ([currencyID], [language], [name]) VALUES (N'USD', N'EN', N'USD')
INSERT [dbo].[tbl_CurrencyLabels] ([currencyID], [language], [name]) VALUES (N'USD', N'ES', N'$US')
INSERT [dbo].[tbl_CurrencyUnits] ([currencyUnitID]) VALUES (N'BIL')
INSERT [dbo].[tbl_CurrencyUnits] ([currencyUnitID]) VALUES (N'CRO')
INSERT [dbo].[tbl_CurrencyUnits] ([currencyUnitID]) VALUES (N'DOL')
INSERT [dbo].[tbl_CurrencyUnits] ([currencyUnitID]) VALUES (N'EUR')
INSERT [dbo].[tbl_CurrencyUnits] ([currencyUnitID]) VALUES (N'LAK')
INSERT [dbo].[tbl_CurrencyUnits] ([currencyUnitID]) VALUES (N'MIL')
INSERT [dbo].[tbl_CurrencyUnits] ([currencyUnitID]) VALUES (N'RS ')
INSERT [dbo].[tbl_CurrencyUnits] ([currencyUnitID]) VALUES (N'THO')
INSERT [dbo].[tbl_CurrencyUnitsLabels] ([currencyUnitID], [language], [name]) VALUES (N'BIL', N'EN', N'Billions')
INSERT [dbo].[tbl_CurrencyUnitsLabels] ([currencyUnitID], [language], [name]) VALUES (N'BIL', N'ES', N'Miles de millones')
INSERT [dbo].[tbl_CurrencyUnitsLabels] ([currencyUnitID], [language], [name]) VALUES (N'CRO', N'EN', N'Crore')
INSERT [dbo].[tbl_CurrencyUnitsLabels] ([currencyUnitID], [language], [name]) VALUES (N'CRO', N'ES', N'Crore')
INSERT [dbo].[tbl_CurrencyUnitsLabels] ([currencyUnitID], [language], [name]) VALUES (N'DOL', N'EN', N'Dollar')
INSERT [dbo].[tbl_CurrencyUnitsLabels] ([currencyUnitID], [language], [name]) VALUES (N'DOL', N'ES', N'Dolar')
INSERT [dbo].[tbl_CurrencyUnitsLabels] ([currencyUnitID], [language], [name]) VALUES (N'EUR', N'EN', N'€')
INSERT [dbo].[tbl_CurrencyUnitsLabels] ([currencyUnitID], [language], [name]) VALUES (N'EUR', N'ES', N'€')
INSERT [dbo].[tbl_CurrencyUnitsLabels] ([currencyUnitID], [language], [name]) VALUES (N'LAK', N'EN', N'Lakh')
INSERT [dbo].[tbl_CurrencyUnitsLabels] ([currencyUnitID], [language], [name]) VALUES (N'LAK', N'ES', N'Lakh')
INSERT [dbo].[tbl_CurrencyUnitsLabels] ([currencyUnitID], [language], [name]) VALUES (N'RS ', N'EN', N'Rs.')
INSERT [dbo].[tbl_CurrencyUnitsLabels] ([currencyUnitID], [language], [name]) VALUES (N'RS ', N'ES', N'Rs.')
INSERT [dbo].[tbl_CurrencyUnitsLabels] ([currencyUnitID], [language], [name]) VALUES (N'THO', N'EN', N'Thousands')
INSERT [dbo].[tbl_CurrencyUnitsLabels] ([currencyUnitID], [language], [name]) VALUES (N'THO', N'ES', N'Miles')
INSERT [dbo].[tbl_Direction] ([directionID]) VALUES (N'MAX')
INSERT [dbo].[tbl_Direction] ([directionID]) VALUES (N'MIN')
INSERT [dbo].[tbl_DirectionLabels] ([directionID], [language], [name]) VALUES (N'MAX', N'EN', N'Maximize  ')
INSERT [dbo].[tbl_DirectionLabels] ([directionID], [language], [name]) VALUES (N'MAX', N'ES', N'Maximizar ')
INSERT [dbo].[tbl_DirectionLabels] ([directionID], [language], [name]) VALUES (N'MIN', N'EN', N'Minimize  ')
INSERT [dbo].[tbl_DirectionLabels] ([directionID], [language], [name]) VALUES (N'MIN', N'ES', N'Minimizar ')
INSERT [dbo].[tbl_KPITypes] ([kpiTypeID], [directionID], [strategyID], [unitID]) VALUES (N'AVAIL', N'MAX', N'AVG', N'PERCENT')
INSERT [dbo].[tbl_KPITypes] ([kpiTypeID], [directionID], [strategyID], [unitID]) VALUES (N'COUNT', N'MAX', N'SUM', N'INT')
INSERT [dbo].[tbl_KPITypes] ([kpiTypeID], [directionID], [strategyID], [unitID]) VALUES (N'MTBF', N'MAX', N'AVG', N'TIME')
INSERT [dbo].[tbl_KPITypes] ([kpiTypeID], [directionID], [strategyID], [unitID]) VALUES (N'MTTR', N'MIN', N'AVG', N'TIME')
INSERT [dbo].[tbl_KPITypes] ([kpiTypeID], [directionID], [strategyID], [unitID]) VALUES (N'OVEEQUEFF', N'MAX', N'AVG', N'PERCENT')
INSERT [dbo].[tbl_KPITypes] ([kpiTypeID], [directionID], [strategyID], [unitID]) VALUES (N'PERCEPTION', N'MAX', N'AVG', N'PERCENT')
INSERT [dbo].[tbl_KPITypes] ([kpiTypeID], [directionID], [strategyID], [unitID]) VALUES (N'PERF', N'MAX', N'AVG', N'PERCENT')
INSERT [dbo].[tbl_KPITypes] ([kpiTypeID], [directionID], [strategyID], [unitID]) VALUES (N'QUAL', N'MAX', N'AVG', N'PERCENT')
INSERT [dbo].[tbl_KPITypes] ([kpiTypeID], [directionID], [strategyID], [unitID]) VALUES (N'REVENUE', N'MAX', N'SUM', N'MONEY')
INSERT [dbo].[tbl_KPITypes] ([kpiTypeID], [directionID], [strategyID], [unitID]) VALUES (N'SALES', N'MAX', N'SUM', N'MONEY')
INSERT [dbo].[tbl_KPITypes] ([kpiTypeID], [directionID], [strategyID], [unitID]) VALUES (N'TTP', N'MIN', N'AVG', N'TIME')
INSERT [dbo].[tbl_KPITypes] ([kpiTypeID], [directionID], [strategyID], [unitID]) VALUES (N'UTIL', N'MAX', N'AVG', N'PERCENT')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'AVAIL', N'EN', N'Availability ', N'NA')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'AVAIL', N'ES', N'Availability ', N'NA')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'COUNT', N'EN', N'Counter', N'NA')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'COUNT', N'ES', N'Counter', N'NA')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'MTBF', N'EN', N'Mean time between failures', N'Mean time between failures (MTBF) is the predicted elapsed time between inherent failures of a system during operation. MTBF is calculated as the arithmetic mean (average) time between failures of a system.   For this type of KPI you must record the "Time between failures" and the system will automatically compute the MTFB from these values.')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'MTBF', N'ES', N'Mean time between failures', N'NA')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'MTTR', N'EN', N'Mean time to repair', N'Mean Time to Repair (MTTR) is a basic measure of the maintainability of repairable items. It represents the average time required to repair a failed component or device. Expressed mathematically, it is the total corrective maintenance time for failures divided by the total number of corrective maintenance actions for failures during a given period of time.  For this type of KPI you must record the "average time required to repair a failed component or device” and the system will automatically compute the MTTR from these values.')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'MTTR', N'ES', N'Mean time to repair', N'NA')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'OVEEQUEFF', N'EN', N'Overall Equipment Effectiveness ', N'NA')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'OVEEQUEFF', N'ES', N'Overall Equipment Effectiveness ', N'NA')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'PERCEPTION', N'EN', N'Perception', N'NA')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'PERCEPTION', N'ES', N'Perception', N'NA')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'PERF', N'EN', N'Performance ', N'NA')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'PERF', N'ES', N'Performance ', N'NA')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'QUAL', N'EN', N'Quality ', N'NA')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'QUAL', N'ES', N'Quality ', N'NA')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'REVENUE', N'EN', N'Revenue', N'Revenue is the income that an organization has from its normal business activities. In accounting, revenue is often referred to as the "top line" due to its position on the income statement at the very top. This is to be contrasted with the "bottom line" which denotes net income.  For private organizations, revenue usually considers income from the sale of goods and services to customers and is also referred to as sales or turnover.   For non-profit organizations, revenue may be referred to as gross receipts and typically includes donations from individuals and corporations, support from government agencies, income from activities related to the organization''s mission, and income from fundraising activities, membership dues, and financial securities such as stocks, bonds or investment funds. ')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'REVENUE', N'ES', N'Revenue', N'Na')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'SALES', N'EN', N'Sales', N'NA')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'SALES', N'ES', N'Sales', N'NA')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'TTP', N'EN', N'Time to process', N'Average over period.  Time to process (or TTP) is the measure of how long it takes for the organization to process a certain type of event, such as “time required to file a claim” or “time to complete a request”. ')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'TTP', N'ES', N'Tiempo de procesamiento', N'NA')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'UTIL', N'EN', N'Utilization ', N'NA')
INSERT [dbo].[tbl_KPITypesLabels] ([kpiTypeID], [language], [typeName], [description]) VALUES (N'UTIL', N'ES', N'Utilization ', N'NA')
INSERT [dbo].[tbl_Language] ([languageID], [languageName]) VALUES (N'EN', N'English')
INSERT [dbo].[tbl_Language] ([languageID], [languageName]) VALUES (N'ES', N'Español')
SET IDENTITY_INSERT [dbo].[tbl_Organization] ON 

INSERT [dbo].[tbl_Organization] ([organizationID], [name]) VALUES (1, N'Artexacta')
SET IDENTITY_INSERT [dbo].[tbl_Organization] OFF
SET IDENTITY_INSERT [dbo].[tbl_Project] ON 

INSERT [dbo].[tbl_Project] ([projectID], [name], [organizationID], [areaID]) VALUES (1, N'New Test Proj', 1, NULL)
SET IDENTITY_INSERT [dbo].[tbl_Project] OFF
INSERT [dbo].[tbl_ReportingUnit] ([reportingUnitID]) VALUES (N'DAY  ')
INSERT [dbo].[tbl_ReportingUnit] ([reportingUnitID]) VALUES (N'MONTH')
INSERT [dbo].[tbl_ReportingUnit] ([reportingUnitID]) VALUES (N'QUART')
INSERT [dbo].[tbl_ReportingUnit] ([reportingUnitID]) VALUES (N'WEEK ')
INSERT [dbo].[tbl_ReportingUnit] ([reportingUnitID]) VALUES (N'YEAR ')
INSERT [dbo].[tbl_ReportingUnitLabels] ([reportingUnitID], [language], [name]) VALUES (N'DAY  ', N'EN', N'Day')
INSERT [dbo].[tbl_ReportingUnitLabels] ([reportingUnitID], [language], [name]) VALUES (N'DAY  ', N'ES', N'Día')
INSERT [dbo].[tbl_ReportingUnitLabels] ([reportingUnitID], [language], [name]) VALUES (N'MONTH', N'EN', N'Month')
INSERT [dbo].[tbl_ReportingUnitLabels] ([reportingUnitID], [language], [name]) VALUES (N'MONTH', N'ES', N'Mes')
INSERT [dbo].[tbl_ReportingUnitLabels] ([reportingUnitID], [language], [name]) VALUES (N'QUART', N'EN', N'Quarter')
INSERT [dbo].[tbl_ReportingUnitLabels] ([reportingUnitID], [language], [name]) VALUES (N'QUART', N'ES', N'Trimestre')
INSERT [dbo].[tbl_ReportingUnitLabels] ([reportingUnitID], [language], [name]) VALUES (N'WEEK ', N'EN', N'Week')
INSERT [dbo].[tbl_ReportingUnitLabels] ([reportingUnitID], [language], [name]) VALUES (N'WEEK ', N'ES', N'Semana')
INSERT [dbo].[tbl_ReportingUnitLabels] ([reportingUnitID], [language], [name]) VALUES (N'YEAR ', N'EN', N'Year')
INSERT [dbo].[tbl_ReportingUnitLabels] ([reportingUnitID], [language], [name]) VALUES (N'YEAR ', N'ES', N'Año')
INSERT [dbo].[tbl_SEG_ObjectActions] ([objectActionID]) VALUES (N'ENTER_DATA')
INSERT [dbo].[tbl_SEG_ObjectActions] ([objectActionID]) VALUES (N'MAN_ACTIVITY')
INSERT [dbo].[tbl_SEG_ObjectActions] ([objectActionID]) VALUES (N'MAN_AREA')
INSERT [dbo].[tbl_SEG_ObjectActions] ([objectActionID]) VALUES (N'MAN_KPI')
INSERT [dbo].[tbl_SEG_ObjectActions] ([objectActionID]) VALUES (N'MAN_PEOPLE')
INSERT [dbo].[tbl_SEG_ObjectActions] ([objectActionID]) VALUES (N'MAN_PROJECT')
INSERT [dbo].[tbl_SEG_ObjectActions] ([objectActionID]) VALUES (N'OWN')
INSERT [dbo].[tbl_SEG_ObjectActions] ([objectActionID]) VALUES (N'VIEW_KPI')
INSERT [dbo].[tbl_SEG_ObjectPermissions] ([objectTypeID], [objectID], [username], [objectActionID]) VALUES (N'ORGANIZATION', 1, N'ivan', N'OWN')
INSERT [dbo].[tbl_SEG_ObjectPermissions] ([objectTypeID], [objectID], [username], [objectActionID]) VALUES (N'PROJECT', 1, N'ivan', N'OWN')
INSERT [dbo].[tbl_SEG_ObjectTypes] ([objectTypeID]) VALUES (N'ACTIVITY')
INSERT [dbo].[tbl_SEG_ObjectTypes] ([objectTypeID]) VALUES (N'KPI')
INSERT [dbo].[tbl_SEG_ObjectTypes] ([objectTypeID]) VALUES (N'ORGANIZATION')
INSERT [dbo].[tbl_SEG_ObjectTypes] ([objectTypeID]) VALUES (N'PERSON')
INSERT [dbo].[tbl_SEG_ObjectTypes] ([objectTypeID]) VALUES (N'PROJECT')
INSERT [dbo].[tbl_Strategy] ([strategyID]) VALUES (N'AVG')
INSERT [dbo].[tbl_Strategy] ([strategyID]) VALUES (N'SUM')
INSERT [dbo].[tbl_StrategyLabels] ([strategyID], [language], [name]) VALUES (N'AVG', N'EN', N'Average over period')
INSERT [dbo].[tbl_StrategyLabels] ([strategyID], [language], [name]) VALUES (N'SUM', N'EN', N'Sum over period')
INSERT [dbo].[tbl_Unit] ([unitID]) VALUES (N'DECIMAL')
INSERT [dbo].[tbl_Unit] ([unitID]) VALUES (N'INT')
INSERT [dbo].[tbl_Unit] ([unitID]) VALUES (N'MONEY')
INSERT [dbo].[tbl_Unit] ([unitID]) VALUES (N'PERCENT')
INSERT [dbo].[tbl_Unit] ([unitID]) VALUES (N'TIME')
INSERT [dbo].[tbl_UnitLabels] ([unitID], [language], [name]) VALUES (N'DECIMAL', N'EN', N'Decimal   ')
INSERT [dbo].[tbl_UnitLabels] ([unitID], [language], [name]) VALUES (N'DECIMAL', N'ES', N'Decimal   ')
INSERT [dbo].[tbl_UnitLabels] ([unitID], [language], [name]) VALUES (N'INT', N'EN', N'Integer   ')
INSERT [dbo].[tbl_UnitLabels] ([unitID], [language], [name]) VALUES (N'INT', N'ES', N'Entero')
INSERT [dbo].[tbl_UnitLabels] ([unitID], [language], [name]) VALUES (N'MONEY', N'EN', N'Money     ')
INSERT [dbo].[tbl_UnitLabels] ([unitID], [language], [name]) VALUES (N'MONEY', N'ES', N'Dinero')
INSERT [dbo].[tbl_UnitLabels] ([unitID], [language], [name]) VALUES (N'PERCENT', N'EN', N'Percentage')
INSERT [dbo].[tbl_UnitLabels] ([unitID], [language], [name]) VALUES (N'PERCENT', N'ES', N'Porcentaje')
INSERT [dbo].[tbl_UnitLabels] ([unitID], [language], [name]) VALUES (N'TIME', N'EN', N'Timespan  ')
INSERT [dbo].[tbl_UnitLabels] ([unitID], [language], [name]) VALUES (N'TIME', N'ES', N'Tiempo')
INSERT [dbo].[tbl_UnitsAllowedForCurrency] ([currencyID], [currencyUnitID]) VALUES (N'EUR', N'BIL')
INSERT [dbo].[tbl_UnitsAllowedForCurrency] ([currencyID], [currencyUnitID]) VALUES (N'EUR', N'EUR')
INSERT [dbo].[tbl_UnitsAllowedForCurrency] ([currencyID], [currencyUnitID]) VALUES (N'EUR', N'MIL')
INSERT [dbo].[tbl_UnitsAllowedForCurrency] ([currencyID], [currencyUnitID]) VALUES (N'EUR', N'THO')
INSERT [dbo].[tbl_UnitsAllowedForCurrency] ([currencyID], [currencyUnitID]) VALUES (N'PKR', N'BIL')
INSERT [dbo].[tbl_UnitsAllowedForCurrency] ([currencyID], [currencyUnitID]) VALUES (N'PKR', N'CRO')
INSERT [dbo].[tbl_UnitsAllowedForCurrency] ([currencyID], [currencyUnitID]) VALUES (N'PKR', N'LAK')
INSERT [dbo].[tbl_UnitsAllowedForCurrency] ([currencyID], [currencyUnitID]) VALUES (N'PKR', N'MIL')
INSERT [dbo].[tbl_UnitsAllowedForCurrency] ([currencyID], [currencyUnitID]) VALUES (N'PKR', N'RS ')
INSERT [dbo].[tbl_UnitsAllowedForCurrency] ([currencyID], [currencyUnitID]) VALUES (N'PKR', N'THO')
INSERT [dbo].[tbl_UnitsAllowedForCurrency] ([currencyID], [currencyUnitID]) VALUES (N'USD', N'BIL')
INSERT [dbo].[tbl_UnitsAllowedForCurrency] ([currencyID], [currencyUnitID]) VALUES (N'USD', N'DOL')
INSERT [dbo].[tbl_UnitsAllowedForCurrency] ([currencyID], [currencyUnitID]) VALUES (N'USD', N'MIL')
INSERT [dbo].[tbl_UnitsAllowedForCurrency] ([currencyID], [currencyUnitID]) VALUES (N'USD', N'THO')
/****** Object:  Index [PK__aspnet_A__C93A4C98212D7110]    Script Date: 12/4/2016 4:39:40 p. m. ******/
ALTER TABLE [dbo].[aspnet_Applications] ADD PRIMARY KEY NONCLUSTERED 
(
	[ApplicationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__aspnet_A__17477DE40800BB1C]    Script Date: 12/4/2016 4:39:40 p. m. ******/
ALTER TABLE [dbo].[aspnet_Applications] ADD UNIQUE NONCLUSTERED 
(
	[LoweredApplicationName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__aspnet_A__3091033128AAD9AD]    Script Date: 12/4/2016 4:39:40 p. m. ******/
ALTER TABLE [dbo].[aspnet_Applications] ADD UNIQUE NONCLUSTERED 
(
	[ApplicationName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PK__aspnet_M__1788CC4D19F7AE13]    Script Date: 12/4/2016 4:39:40 p. m. ******/
ALTER TABLE [dbo].[aspnet_Membership] ADD PRIMARY KEY NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PK__aspnet_P__CD67DC58E317DD0E]    Script Date: 12/4/2016 4:39:40 p. m. ******/
ALTER TABLE [dbo].[aspnet_Paths] ADD PRIMARY KEY NONCLUSTERED 
(
	[PathId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PK__aspnet_P__3214EC063236D2B9]    Script Date: 12/4/2016 4:39:40 p. m. ******/
ALTER TABLE [dbo].[aspnet_PersonalizationPerUser] ADD PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [aspnet_PersonalizationPerUser_ncindex2]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE UNIQUE NONCLUSTERED INDEX [aspnet_PersonalizationPerUser_ncindex2] ON [dbo].[aspnet_PersonalizationPerUser]
(
	[UserId] ASC,
	[PathId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PK__aspnet_R__8AFACE1BF8E4B0BF]    Script Date: 12/4/2016 4:39:40 p. m. ******/
ALTER TABLE [dbo].[aspnet_Roles] ADD PRIMARY KEY NONCLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PK__aspnet_U__1788CC4DA370C85F]    Script Date: 12/4/2016 4:39:40 p. m. ******/
ALTER TABLE [dbo].[aspnet_Users] ADD PRIMARY KEY NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [aspnet_Users_Index2]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE NONCLUSTERED INDEX [aspnet_Users_Index2] ON [dbo].[aspnet_Users]
(
	[ApplicationId] ASC,
	[LastActivityDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [aspnet_UsersInRoles_index]    Script Date: 12/4/2016 4:39:40 p. m. ******/
CREATE NONCLUSTERED INDEX [aspnet_UsersInRoles_index] ON [dbo].[aspnet_UsersInRoles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[aspnet_Applications] ADD  DEFAULT (newid()) FOR [ApplicationId]
GO
ALTER TABLE [dbo].[aspnet_Membership] ADD  DEFAULT ((0)) FOR [PasswordFormat]
GO
ALTER TABLE [dbo].[aspnet_Paths] ADD  DEFAULT (newid()) FOR [PathId]
GO
ALTER TABLE [dbo].[aspnet_PersonalizationPerUser] ADD  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[aspnet_Roles] ADD  DEFAULT (newid()) FOR [RoleId]
GO
ALTER TABLE [dbo].[aspnet_Users] ADD  DEFAULT (newid()) FOR [UserId]
GO
ALTER TABLE [dbo].[aspnet_Users] ADD  DEFAULT (NULL) FOR [MobileAlias]
GO
ALTER TABLE [dbo].[aspnet_Users] ADD  DEFAULT ((0)) FOR [IsAnonymous]
GO
ALTER TABLE [dbo].[aspnet_Membership]  WITH CHECK ADD FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[aspnet_Membership]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[aspnet_Users] ([UserId])
GO
ALTER TABLE [dbo].[aspnet_Paths]  WITH CHECK ADD FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[aspnet_PersonalizationAllUsers]  WITH CHECK ADD FOREIGN KEY([PathId])
REFERENCES [dbo].[aspnet_Paths] ([PathId])
GO
ALTER TABLE [dbo].[aspnet_PersonalizationPerUser]  WITH CHECK ADD FOREIGN KEY([PathId])
REFERENCES [dbo].[aspnet_Paths] ([PathId])
GO
ALTER TABLE [dbo].[aspnet_PersonalizationPerUser]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[aspnet_Users] ([UserId])
GO
ALTER TABLE [dbo].[aspnet_Profile]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[aspnet_Users] ([UserId])
GO
ALTER TABLE [dbo].[aspnet_Roles]  WITH CHECK ADD FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[aspnet_Users]  WITH CHECK ADD FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[aspnet_UsersInRoles]  WITH CHECK ADD FOREIGN KEY([RoleId])
REFERENCES [dbo].[aspnet_Roles] ([RoleId])
GO
ALTER TABLE [dbo].[aspnet_UsersInRoles]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[aspnet_Users] ([UserId])
GO
ALTER TABLE [dbo].[tbl_Activity]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Activity_tbl_Area] FOREIGN KEY([areaID])
REFERENCES [dbo].[tbl_Area] ([areaID])
GO
ALTER TABLE [dbo].[tbl_Activity] CHECK CONSTRAINT [FK_tbl_Activity_tbl_Area]
GO
ALTER TABLE [dbo].[tbl_Activity]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Activity_tbl_Organization] FOREIGN KEY([organizationID])
REFERENCES [dbo].[tbl_Organization] ([organizationID])
GO
ALTER TABLE [dbo].[tbl_Activity] CHECK CONSTRAINT [FK_tbl_Activity_tbl_Organization]
GO
ALTER TABLE [dbo].[tbl_Activity]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Activity_tbl_Project] FOREIGN KEY([projectID])
REFERENCES [dbo].[tbl_Project] ([projectID])
GO
ALTER TABLE [dbo].[tbl_Activity] CHECK CONSTRAINT [FK_tbl_Activity_tbl_Project]
GO
ALTER TABLE [dbo].[tbl_Area]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Area_tbl_Organization] FOREIGN KEY([organizationID])
REFERENCES [dbo].[tbl_Organization] ([organizationID])
GO
ALTER TABLE [dbo].[tbl_Area] CHECK CONSTRAINT [FK_tbl_Area_tbl_Organization]
GO
ALTER TABLE [dbo].[tbl_CategoryItem]  WITH CHECK ADD  CONSTRAINT [FK_tbl_CategoryItem_tbl_Category] FOREIGN KEY([categoryID])
REFERENCES [dbo].[tbl_Category] ([categoryID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tbl_CategoryItem] CHECK CONSTRAINT [FK_tbl_CategoryItem_tbl_Category]
GO
ALTER TABLE [dbo].[tbl_CurrencyLabels]  WITH CHECK ADD  CONSTRAINT [FK_tbl_CurencyLabels_tbl_Language] FOREIGN KEY([language])
REFERENCES [dbo].[tbl_Language] ([languageID])
GO
ALTER TABLE [dbo].[tbl_CurrencyLabels] CHECK CONSTRAINT [FK_tbl_CurencyLabels_tbl_Language]
GO
ALTER TABLE [dbo].[tbl_CurrencyLabels]  WITH CHECK ADD  CONSTRAINT [FK_tbl_CurrencyLabels_tbl_Currency] FOREIGN KEY([currencyID])
REFERENCES [dbo].[tbl_Currency] ([currencyID])
GO
ALTER TABLE [dbo].[tbl_CurrencyLabels] CHECK CONSTRAINT [FK_tbl_CurrencyLabels_tbl_Currency]
GO
ALTER TABLE [dbo].[tbl_CurrencyUnitsLabels]  WITH CHECK ADD  CONSTRAINT [FK_tbl_CurrencyUnitsLabels_tbl_CurrencyUnits] FOREIGN KEY([currencyUnitID])
REFERENCES [dbo].[tbl_CurrencyUnits] ([currencyUnitID])
GO
ALTER TABLE [dbo].[tbl_CurrencyUnitsLabels] CHECK CONSTRAINT [FK_tbl_CurrencyUnitsLabels_tbl_CurrencyUnits]
GO
ALTER TABLE [dbo].[tbl_CurrencyUnitsLabels]  WITH CHECK ADD  CONSTRAINT [FK_tbl_CurrencyUnitsLabels_tbl_Language] FOREIGN KEY([language])
REFERENCES [dbo].[tbl_Language] ([languageID])
GO
ALTER TABLE [dbo].[tbl_CurrencyUnitsLabels] CHECK CONSTRAINT [FK_tbl_CurrencyUnitsLabels_tbl_Language]
GO
ALTER TABLE [dbo].[tbl_DirectionLabels]  WITH CHECK ADD  CONSTRAINT [FK_tbl_DirectionLabels_tbl_Direction] FOREIGN KEY([directionID])
REFERENCES [dbo].[tbl_Direction] ([directionID])
GO
ALTER TABLE [dbo].[tbl_DirectionLabels] CHECK CONSTRAINT [FK_tbl_DirectionLabels_tbl_Direction]
GO
ALTER TABLE [dbo].[tbl_DirectionLabels]  WITH CHECK ADD  CONSTRAINT [FK_tbl_DirectionLabels_tbl_Language] FOREIGN KEY([language])
REFERENCES [dbo].[tbl_Language] ([languageID])
GO
ALTER TABLE [dbo].[tbl_DirectionLabels] CHECK CONSTRAINT [FK_tbl_DirectionLabels_tbl_Language]
GO
ALTER TABLE [dbo].[tbl_KPI]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPI_tbl_Area] FOREIGN KEY([currencyUnitID])
REFERENCES [dbo].[tbl_Currency] ([currencyID])
GO
ALTER TABLE [dbo].[tbl_KPI] CHECK CONSTRAINT [FK_tbl_KPI_tbl_Area]
GO
ALTER TABLE [dbo].[tbl_KPI]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPI_tbl_Currency] FOREIGN KEY([currency])
REFERENCES [dbo].[tbl_Currency] ([currencyID])
GO
ALTER TABLE [dbo].[tbl_KPI] CHECK CONSTRAINT [FK_tbl_KPI_tbl_Currency]
GO
ALTER TABLE [dbo].[tbl_KPI]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPI_tbl_CurrencyUnits] FOREIGN KEY([currencyUnitID])
REFERENCES [dbo].[tbl_CurrencyUnits] ([currencyUnitID])
GO
ALTER TABLE [dbo].[tbl_KPI] CHECK CONSTRAINT [FK_tbl_KPI_tbl_CurrencyUnits]
GO
ALTER TABLE [dbo].[tbl_KPI]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPI_tbl_Direction] FOREIGN KEY([directionID])
REFERENCES [dbo].[tbl_Direction] ([directionID])
GO
ALTER TABLE [dbo].[tbl_KPI] CHECK CONSTRAINT [FK_tbl_KPI_tbl_Direction]
GO
ALTER TABLE [dbo].[tbl_KPI]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPI_tbl_Organization] FOREIGN KEY([organizationID])
REFERENCES [dbo].[tbl_Organization] ([organizationID])
GO
ALTER TABLE [dbo].[tbl_KPI] CHECK CONSTRAINT [FK_tbl_KPI_tbl_Organization]
GO
ALTER TABLE [dbo].[tbl_KPI]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPI_tbl_People] FOREIGN KEY([personID])
REFERENCES [dbo].[tbl_People] ([personID])
GO
ALTER TABLE [dbo].[tbl_KPI] CHECK CONSTRAINT [FK_tbl_KPI_tbl_People]
GO
ALTER TABLE [dbo].[tbl_KPI]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPI_tbl_Project] FOREIGN KEY([projectID])
REFERENCES [dbo].[tbl_Project] ([projectID])
GO
ALTER TABLE [dbo].[tbl_KPI] CHECK CONSTRAINT [FK_tbl_KPI_tbl_Project]
GO
ALTER TABLE [dbo].[tbl_KPI]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPI_tbl_ReportingUnit] FOREIGN KEY([reportingUnitID])
REFERENCES [dbo].[tbl_ReportingUnit] ([reportingUnitID])
GO
ALTER TABLE [dbo].[tbl_KPI] CHECK CONSTRAINT [FK_tbl_KPI_tbl_ReportingUnit]
GO
ALTER TABLE [dbo].[tbl_KPI]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPI_tbl_Strategy] FOREIGN KEY([strategyID])
REFERENCES [dbo].[tbl_Strategy] ([strategyID])
GO
ALTER TABLE [dbo].[tbl_KPI] CHECK CONSTRAINT [FK_tbl_KPI_tbl_Strategy]
GO
ALTER TABLE [dbo].[tbl_KPI]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPI_tbl_Unit] FOREIGN KEY([unitID])
REFERENCES [dbo].[tbl_Unit] ([unitID])
GO
ALTER TABLE [dbo].[tbl_KPI] CHECK CONSTRAINT [FK_tbl_KPI_tbl_Unit]
GO
ALTER TABLE [dbo].[tbl_KPICategories]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPICategories_tbl_Category] FOREIGN KEY([categoryID])
REFERENCES [dbo].[tbl_Category] ([categoryID])
GO
ALTER TABLE [dbo].[tbl_KPICategories] CHECK CONSTRAINT [FK_tbl_KPICategories_tbl_Category]
GO
ALTER TABLE [dbo].[tbl_KPIMeasurementCategories]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPIMeasurementCategories_tbl_CategoryItem] FOREIGN KEY([categoryItemID], [categoryID])
REFERENCES [dbo].[tbl_CategoryItem] ([categoryItemID], [categoryID])
GO
ALTER TABLE [dbo].[tbl_KPIMeasurementCategories] CHECK CONSTRAINT [FK_tbl_KPIMeasurementCategories_tbl_CategoryItem]
GO
ALTER TABLE [dbo].[tbl_KPIMeasurementCategories]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPIMeasurementCategories_tbl_KPIMeasurements] FOREIGN KEY([measurementID])
REFERENCES [dbo].[tbl_KPIMeasurements] ([measurmentID])
GO
ALTER TABLE [dbo].[tbl_KPIMeasurementCategories] CHECK CONSTRAINT [FK_tbl_KPIMeasurementCategories_tbl_KPIMeasurements]
GO
ALTER TABLE [dbo].[tbl_KPIMeasurements]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPIMeasurements_tbl_KPI] FOREIGN KEY([kpiID])
REFERENCES [dbo].[tbl_KPI] ([kpiID])
GO
ALTER TABLE [dbo].[tbl_KPIMeasurements] CHECK CONSTRAINT [FK_tbl_KPIMeasurements_tbl_KPI]
GO
ALTER TABLE [dbo].[tbl_KPITarget]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPITargets_tbl_KPI] FOREIGN KEY([kpiID])
REFERENCES [dbo].[tbl_KPI] ([kpiID])
GO
ALTER TABLE [dbo].[tbl_KPITarget] CHECK CONSTRAINT [FK_tbl_KPITargets_tbl_KPI]
GO
ALTER TABLE [dbo].[tbl_KPITargetCategories]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPITargetCategories_tbl_KPITargetCategories] FOREIGN KEY([categoryItemID], [categoryID])
REFERENCES [dbo].[tbl_CategoryItem] ([categoryItemID], [categoryID])
GO
ALTER TABLE [dbo].[tbl_KPITargetCategories] CHECK CONSTRAINT [FK_tbl_KPITargetCategories_tbl_KPITargetCategories]
GO
ALTER TABLE [dbo].[tbl_KPITargetCategories]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPITargetCategories_tbl_KPITargets] FOREIGN KEY([targetID])
REFERENCES [dbo].[tbl_KPITarget] ([targetID])
GO
ALTER TABLE [dbo].[tbl_KPITargetCategories] CHECK CONSTRAINT [FK_tbl_KPITargetCategories_tbl_KPITargets]
GO
ALTER TABLE [dbo].[tbl_KPITypes]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPITypes_tbl_Direction] FOREIGN KEY([directionID])
REFERENCES [dbo].[tbl_Direction] ([directionID])
GO
ALTER TABLE [dbo].[tbl_KPITypes] CHECK CONSTRAINT [FK_tbl_KPITypes_tbl_Direction]
GO
ALTER TABLE [dbo].[tbl_KPITypes]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPITypes_tbl_Strategy] FOREIGN KEY([strategyID])
REFERENCES [dbo].[tbl_Strategy] ([strategyID])
GO
ALTER TABLE [dbo].[tbl_KPITypes] CHECK CONSTRAINT [FK_tbl_KPITypes_tbl_Strategy]
GO
ALTER TABLE [dbo].[tbl_KPITypes]  WITH CHECK ADD  CONSTRAINT [FK_tbl_kpiTypes_tbl_Unit] FOREIGN KEY([unitID])
REFERENCES [dbo].[tbl_Unit] ([unitID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[tbl_KPITypes] CHECK CONSTRAINT [FK_tbl_kpiTypes_tbl_Unit]
GO
ALTER TABLE [dbo].[tbl_KPITypesLabels]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPITypesLabels_tbl_KPITypes] FOREIGN KEY([kpiTypeID])
REFERENCES [dbo].[tbl_KPITypes] ([kpiTypeID])
GO
ALTER TABLE [dbo].[tbl_KPITypesLabels] CHECK CONSTRAINT [FK_tbl_KPITypesLabels_tbl_KPITypes]
GO
ALTER TABLE [dbo].[tbl_KPITypesLabels]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPITypesLabels_tbl_Language] FOREIGN KEY([language])
REFERENCES [dbo].[tbl_Language] ([languageID])
GO
ALTER TABLE [dbo].[tbl_KPITypesLabels] CHECK CONSTRAINT [FK_tbl_KPITypesLabels_tbl_Language]
GO
ALTER TABLE [dbo].[tbl_People]  WITH CHECK ADD  CONSTRAINT [FK_tbl_People_tbl_Area] FOREIGN KEY([areaID])
REFERENCES [dbo].[tbl_Area] ([areaID])
GO
ALTER TABLE [dbo].[tbl_People] CHECK CONSTRAINT [FK_tbl_People_tbl_Area]
GO
ALTER TABLE [dbo].[tbl_People]  WITH CHECK ADD  CONSTRAINT [FK_tbl_People_tbl_Organization] FOREIGN KEY([organizationID])
REFERENCES [dbo].[tbl_Organization] ([organizationID])
GO
ALTER TABLE [dbo].[tbl_People] CHECK CONSTRAINT [FK_tbl_People_tbl_Organization]
GO
ALTER TABLE [dbo].[tbl_Project]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Project_tbl_Area] FOREIGN KEY([areaID])
REFERENCES [dbo].[tbl_Area] ([areaID])
GO
ALTER TABLE [dbo].[tbl_Project] CHECK CONSTRAINT [FK_tbl_Project_tbl_Area]
GO
ALTER TABLE [dbo].[tbl_Project]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Project_tbl_Organization] FOREIGN KEY([organizationID])
REFERENCES [dbo].[tbl_Organization] ([organizationID])
GO
ALTER TABLE [dbo].[tbl_Project] CHECK CONSTRAINT [FK_tbl_Project_tbl_Organization]
GO
ALTER TABLE [dbo].[tbl_ReportingUnitLabels]  WITH CHECK ADD  CONSTRAINT [FK_tbl_ReportingUnitLabels_tbl_Language] FOREIGN KEY([language])
REFERENCES [dbo].[tbl_Language] ([languageID])
GO
ALTER TABLE [dbo].[tbl_ReportingUnitLabels] CHECK CONSTRAINT [FK_tbl_ReportingUnitLabels_tbl_Language]
GO
ALTER TABLE [dbo].[tbl_ReportingUnitLabels]  WITH CHECK ADD  CONSTRAINT [FK_tbl_ReportingUnitLabels_tbl_ReportingUnit] FOREIGN KEY([reportingUnitID])
REFERENCES [dbo].[tbl_ReportingUnit] ([reportingUnitID])
GO
ALTER TABLE [dbo].[tbl_ReportingUnitLabels] CHECK CONSTRAINT [FK_tbl_ReportingUnitLabels_tbl_ReportingUnit]
GO
ALTER TABLE [dbo].[tbl_SEG_ObjectPermissions]  WITH CHECK ADD  CONSTRAINT [FK_tbl_SEG_ObjectPermissions_tbl_SEG_ObjectActions] FOREIGN KEY([objectActionID])
REFERENCES [dbo].[tbl_SEG_ObjectActions] ([objectActionID])
GO
ALTER TABLE [dbo].[tbl_SEG_ObjectPermissions] CHECK CONSTRAINT [FK_tbl_SEG_ObjectPermissions_tbl_SEG_ObjectActions]
GO
ALTER TABLE [dbo].[tbl_SEG_ObjectPermissions]  WITH CHECK ADD  CONSTRAINT [FK_tbl_SEG_ObjectPermissions_tbl_SEG_ObjectTypes] FOREIGN KEY([objectTypeID])
REFERENCES [dbo].[tbl_SEG_ObjectTypes] ([objectTypeID])
GO
ALTER TABLE [dbo].[tbl_SEG_ObjectPermissions] CHECK CONSTRAINT [FK_tbl_SEG_ObjectPermissions_tbl_SEG_ObjectTypes]
GO
ALTER TABLE [dbo].[tbl_StrategyLabels]  WITH CHECK ADD  CONSTRAINT [FK_tbl_StrategyLabels_tbl_Language] FOREIGN KEY([language])
REFERENCES [dbo].[tbl_Language] ([languageID])
GO
ALTER TABLE [dbo].[tbl_StrategyLabels] CHECK CONSTRAINT [FK_tbl_StrategyLabels_tbl_Language]
GO
ALTER TABLE [dbo].[tbl_StrategyLabels]  WITH CHECK ADD  CONSTRAINT [FK_tbl_StrategyLabels_tbl_Strategy] FOREIGN KEY([strategyID])
REFERENCES [dbo].[tbl_Strategy] ([strategyID])
GO
ALTER TABLE [dbo].[tbl_StrategyLabels] CHECK CONSTRAINT [FK_tbl_StrategyLabels_tbl_Strategy]
GO
ALTER TABLE [dbo].[tbl_UnitLabels]  WITH CHECK ADD  CONSTRAINT [FK_tbl_UnitLabels_tbl_Language] FOREIGN KEY([language])
REFERENCES [dbo].[tbl_Language] ([languageID])
GO
ALTER TABLE [dbo].[tbl_UnitLabels] CHECK CONSTRAINT [FK_tbl_UnitLabels_tbl_Language]
GO
ALTER TABLE [dbo].[tbl_UnitLabels]  WITH CHECK ADD  CONSTRAINT [FK_tbl_UnitLabels_tbl_Unit] FOREIGN KEY([unitID])
REFERENCES [dbo].[tbl_Unit] ([unitID])
GO
ALTER TABLE [dbo].[tbl_UnitLabels] CHECK CONSTRAINT [FK_tbl_UnitLabels_tbl_Unit]
GO
ALTER TABLE [dbo].[tbl_UnitsAllowedForCurrency]  WITH CHECK ADD  CONSTRAINT [FK_tbl_UnitsAllowedForCurrency_tbl_Currency] FOREIGN KEY([currencyID])
REFERENCES [dbo].[tbl_Currency] ([currencyID])
GO
ALTER TABLE [dbo].[tbl_UnitsAllowedForCurrency] CHECK CONSTRAINT [FK_tbl_UnitsAllowedForCurrency_tbl_Currency]
GO
ALTER TABLE [dbo].[tbl_UnitsAllowedForCurrency]  WITH CHECK ADD  CONSTRAINT [FK_tbl_UnitsAllowedForCurrency_tbl_CurrencyUnits] FOREIGN KEY([currencyUnitID])
REFERENCES [dbo].[tbl_CurrencyUnits] ([currencyUnitID])
GO
ALTER TABLE [dbo].[tbl_UnitsAllowedForCurrency] CHECK CONSTRAINT [FK_tbl_UnitsAllowedForCurrency_tbl_CurrencyUnits]
GO
/****** Object:  StoredProcedure [dbo].[aspnet_AnyDataInTables]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_AnyDataInTables]
    @TablesToCheck int
AS
BEGIN
    -- Check Membership table if (@TablesToCheck & 1) is set
    IF ((@TablesToCheck & 1) <> 0 AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_aspnet_MembershipUsers') AND (type = 'V'))))
    BEGIN
        IF (EXISTS(SELECT TOP 1 UserId FROM dbo.aspnet_Membership))
        BEGIN
            SELECT N'aspnet_Membership'
            RETURN
        END
    END

    -- Check aspnet_Roles table if (@TablesToCheck & 2) is set
    IF ((@TablesToCheck & 2) <> 0  AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_aspnet_Roles') AND (type = 'V'))) )
    BEGIN
        IF (EXISTS(SELECT TOP 1 RoleId FROM dbo.aspnet_Roles))
        BEGIN
            SELECT N'aspnet_Roles'
            RETURN
        END
    END

    -- Check aspnet_Profile table if (@TablesToCheck & 4) is set
    IF ((@TablesToCheck & 4) <> 0  AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_aspnet_Profiles') AND (type = 'V'))) )
    BEGIN
        IF (EXISTS(SELECT TOP 1 UserId FROM dbo.aspnet_Profile))
        BEGIN
            SELECT N'aspnet_Profile'
            RETURN
        END
    END

    -- Check aspnet_PersonalizationPerUser table if (@TablesToCheck & 8) is set
    IF ((@TablesToCheck & 8) <> 0  AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_aspnet_WebPartState_User') AND (type = 'V'))) )
    BEGIN
        IF (EXISTS(SELECT TOP 1 UserId FROM dbo.aspnet_PersonalizationPerUser))
        BEGIN
            SELECT N'aspnet_PersonalizationPerUser'
            RETURN
        END
    END

    -- Check aspnet_PersonalizationPerUser table if (@TablesToCheck & 16) is set
    IF ((@TablesToCheck & 16) <> 0  AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'aspnet_WebEvent_LogEvent') AND (type = 'P'))) )
    BEGIN
        IF (EXISTS(SELECT TOP 1 * FROM dbo.aspnet_WebEvent_Events))
        BEGIN
            SELECT N'aspnet_WebEvent_Events'
            RETURN
        END
    END

    -- Check aspnet_Users table if (@TablesToCheck & 1,2,4 & 8) are all set
    IF ((@TablesToCheck & 1) <> 0 AND
        (@TablesToCheck & 2) <> 0 AND
        (@TablesToCheck & 4) <> 0 AND
        (@TablesToCheck & 8) <> 0 AND
        (@TablesToCheck & 32) <> 0 AND
        (@TablesToCheck & 128) <> 0 AND
        (@TablesToCheck & 256) <> 0 AND
        (@TablesToCheck & 512) <> 0 AND
        (@TablesToCheck & 1024) <> 0)
    BEGIN
        IF (EXISTS(SELECT TOP 1 UserId FROM dbo.aspnet_Users))
        BEGIN
            SELECT N'aspnet_Users'
            RETURN
        END
        IF (EXISTS(SELECT TOP 1 ApplicationId FROM dbo.aspnet_Applications))
        BEGIN
            SELECT N'aspnet_Applications'
            RETURN
        END
    END
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Applications_CreateApplication]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_Applications_CreateApplication]
    @ApplicationName      nvarchar(256),
    @ApplicationId        uniqueidentifier OUTPUT
AS
BEGIN
    SELECT  @ApplicationId = ApplicationId FROM dbo.aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName

    IF(@ApplicationId IS NULL)
    BEGIN
        DECLARE @TranStarted   bit
        SET @TranStarted = 0

        IF( @@TRANCOUNT = 0 )
        BEGIN
	        BEGIN TRANSACTION
	        SET @TranStarted = 1
        END
        ELSE
    	    SET @TranStarted = 0

        SELECT  @ApplicationId = ApplicationId
        FROM dbo.aspnet_Applications WITH (UPDLOCK, HOLDLOCK)
        WHERE LOWER(@ApplicationName) = LoweredApplicationName

        IF(@ApplicationId IS NULL)
        BEGIN
            SELECT  @ApplicationId = NEWID()
            INSERT  dbo.aspnet_Applications (ApplicationId, ApplicationName, LoweredApplicationName)
            VALUES  (@ApplicationId, @ApplicationName, LOWER(@ApplicationName))
        END


        IF( @TranStarted = 1 )
        BEGIN
            IF(@@ERROR = 0)
            BEGIN
	        SET @TranStarted = 0
	        COMMIT TRANSACTION
            END
            ELSE
            BEGIN
                SET @TranStarted = 0
                ROLLBACK TRANSACTION
            END
        END
    END
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_CheckSchemaVersion]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_CheckSchemaVersion]
    @Feature                   nvarchar(128),
    @CompatibleSchemaVersion   nvarchar(128)
AS
BEGIN
    IF (EXISTS( SELECT  *
                FROM    dbo.aspnet_SchemaVersions
                WHERE   Feature = LOWER( @Feature ) AND
                        CompatibleSchemaVersion = @CompatibleSchemaVersion ))
        RETURN 0

    RETURN 1
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_ChangePasswordQuestionAndAnswer]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_ChangePasswordQuestionAndAnswer]
    @ApplicationName       nvarchar(256),
    @UserName              nvarchar(256),
    @NewPasswordQuestion   nvarchar(256),
    @NewPasswordAnswer     nvarchar(128)
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL
    SELECT  @UserId = u.UserId
    FROM    dbo.aspnet_Membership m, dbo.aspnet_Users u, dbo.aspnet_Applications a
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId
    IF (@UserId IS NULL)
    BEGIN
        RETURN(1)
    END

    UPDATE dbo.aspnet_Membership
    SET    PasswordQuestion = @NewPasswordQuestion, PasswordAnswer = @NewPasswordAnswer
    WHERE  UserId=@UserId
    RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_CreateUser]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_CreateUser]
    @ApplicationName                        nvarchar(256),
    @UserName                               nvarchar(256),
    @Password                               nvarchar(128),
    @PasswordSalt                           nvarchar(128),
    @Email                                  nvarchar(256),
    @PasswordQuestion                       nvarchar(256),
    @PasswordAnswer                         nvarchar(128),
    @IsApproved                             bit,
    @CurrentTimeUtc                         datetime,
    @CreateDate                             datetime = NULL,
    @UniqueEmail                            int      = 0,
    @PasswordFormat                         int      = 0,
    @UserId                                 uniqueidentifier OUTPUT
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL

    DECLARE @NewUserId uniqueidentifier
    SELECT @NewUserId = NULL

    DECLARE @IsLockedOut bit
    SET @IsLockedOut = 0

    DECLARE @LastLockoutDate  datetime
    SET @LastLockoutDate = CONVERT( datetime, '17540101', 112 )

    DECLARE @FailedPasswordAttemptCount int
    SET @FailedPasswordAttemptCount = 0

    DECLARE @FailedPasswordAttemptWindowStart  datetime
    SET @FailedPasswordAttemptWindowStart = CONVERT( datetime, '17540101', 112 )

    DECLARE @FailedPasswordAnswerAttemptCount int
    SET @FailedPasswordAnswerAttemptCount = 0

    DECLARE @FailedPasswordAnswerAttemptWindowStart  datetime
    SET @FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, '17540101', 112 )

    DECLARE @NewUserCreated bit
    DECLARE @ReturnValue   int
    SET @ReturnValue = 0

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    EXEC dbo.aspnet_Applications_CreateApplication @ApplicationName, @ApplicationId OUTPUT

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    SET @CreateDate = @CurrentTimeUtc

    SELECT  @NewUserId = UserId FROM dbo.aspnet_Users WHERE LOWER(@UserName) = LoweredUserName AND @ApplicationId = ApplicationId
    IF ( @NewUserId IS NULL )
    BEGIN
        SET @NewUserId = @UserId
        EXEC @ReturnValue = dbo.aspnet_Users_CreateUser @ApplicationId, @UserName, 0, @CreateDate, @NewUserId OUTPUT
        SET @NewUserCreated = 1
    END
    ELSE
    BEGIN
        SET @NewUserCreated = 0
        IF( @NewUserId <> @UserId AND @UserId IS NOT NULL )
        BEGIN
            SET @ErrorCode = 6
            GOTO Cleanup
        END
    END

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @ReturnValue = -1 )
    BEGIN
        SET @ErrorCode = 10
        GOTO Cleanup
    END

    IF ( EXISTS ( SELECT UserId
                  FROM   dbo.aspnet_Membership
                  WHERE  @NewUserId = UserId ) )
    BEGIN
        SET @ErrorCode = 6
        GOTO Cleanup
    END

    SET @UserId = @NewUserId

    IF (@UniqueEmail = 1)
    BEGIN
        IF (EXISTS (SELECT *
                    FROM  dbo.aspnet_Membership m WITH ( UPDLOCK, HOLDLOCK )
                    WHERE ApplicationId = @ApplicationId AND LoweredEmail = LOWER(@Email)))
        BEGIN
            SET @ErrorCode = 7
            GOTO Cleanup
        END
    END

    IF (@NewUserCreated = 0)
    BEGIN
        UPDATE dbo.aspnet_Users
        SET    LastActivityDate = @CreateDate
        WHERE  @UserId = UserId
        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END
    END

    INSERT INTO dbo.aspnet_Membership
                ( ApplicationId,
                  UserId,
                  Password,
                  PasswordSalt,
                  Email,
                  LoweredEmail,
                  PasswordQuestion,
                  PasswordAnswer,
                  PasswordFormat,
                  IsApproved,
                  IsLockedOut,
                  CreateDate,
                  LastLoginDate,
                  LastPasswordChangedDate,
                  LastLockoutDate,
                  FailedPasswordAttemptCount,
                  FailedPasswordAttemptWindowStart,
                  FailedPasswordAnswerAttemptCount,
                  FailedPasswordAnswerAttemptWindowStart )
         VALUES ( @ApplicationId,
                  @UserId,
                  @Password,
                  @PasswordSalt,
                  @Email,
                  LOWER(@Email),
                  @PasswordQuestion,
                  @PasswordAnswer,
                  @PasswordFormat,
                  @IsApproved,
                  @IsLockedOut,
                  @CreateDate,
                  @CreateDate,
                  @CreateDate,
                  @LastLockoutDate,
                  @FailedPasswordAttemptCount,
                  @FailedPasswordAttemptWindowStart,
                  @FailedPasswordAnswerAttemptCount,
                  @FailedPasswordAnswerAttemptWindowStart )

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @TranStarted = 1 )
    BEGIN
	    SET @TranStarted = 0
	    COMMIT TRANSACTION
    END

    RETURN 0

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_FindUsersByEmail]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_FindUsersByEmail]
    @ApplicationName       nvarchar(256),
    @EmailToMatch          nvarchar(256),
    @PageIndex             int,
    @PageSize              int
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM dbo.aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN 0

    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId uniqueidentifier
    )

    -- Insert into our temp table
    IF( @EmailToMatch IS NULL )
        INSERT INTO #PageIndexForUsers (UserId)
            SELECT u.UserId
            FROM   dbo.aspnet_Users u, dbo.aspnet_Membership m
            WHERE  u.ApplicationId = @ApplicationId AND m.UserId = u.UserId AND m.Email IS NULL
            ORDER BY m.LoweredEmail
    ELSE
        INSERT INTO #PageIndexForUsers (UserId)
            SELECT u.UserId
            FROM   dbo.aspnet_Users u, dbo.aspnet_Membership m
            WHERE  u.ApplicationId = @ApplicationId AND m.UserId = u.UserId AND m.LoweredEmail LIKE LOWER(@EmailToMatch)
            ORDER BY m.LoweredEmail

    SELECT  u.UserName, m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
            m.CreateDate,
            m.LastLoginDate,
            u.LastActivityDate,
            m.LastPasswordChangedDate,
            u.UserId, m.IsLockedOut,
            m.LastLockoutDate
    FROM   dbo.aspnet_Membership m, dbo.aspnet_Users u, #PageIndexForUsers p
    WHERE  u.UserId = p.UserId AND u.UserId = m.UserId AND
           p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
    ORDER BY m.LoweredEmail

    SELECT  @TotalRecords = COUNT(*)
    FROM    #PageIndexForUsers
    RETURN @TotalRecords
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_FindUsersByName]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_FindUsersByName]
    @ApplicationName       nvarchar(256),
    @UserNameToMatch       nvarchar(256),
    @PageIndex             int,
    @PageSize              int
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM dbo.aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN 0

    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId uniqueidentifier
    )

    -- Insert into our temp table
    INSERT INTO #PageIndexForUsers (UserId)
        SELECT u.UserId
        FROM   dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE  u.ApplicationId = @ApplicationId AND m.UserId = u.UserId AND u.LoweredUserName LIKE LOWER(@UserNameToMatch)
        ORDER BY u.UserName


    SELECT  u.UserName, m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
            m.CreateDate,
            m.LastLoginDate,
            u.LastActivityDate,
            m.LastPasswordChangedDate,
            u.UserId, m.IsLockedOut,
            m.LastLockoutDate
    FROM   dbo.aspnet_Membership m, dbo.aspnet_Users u, #PageIndexForUsers p
    WHERE  u.UserId = p.UserId AND u.UserId = m.UserId AND
           p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
    ORDER BY u.UserName

    SELECT  @TotalRecords = COUNT(*)
    FROM    #PageIndexForUsers
    RETURN @TotalRecords
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetAllUsers]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_GetAllUsers]
    @ApplicationName       nvarchar(256),
    @PageIndex             int,
    @PageSize              int
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM dbo.aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN 0


    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId uniqueidentifier
    )

    -- Insert into our temp table
    INSERT INTO #PageIndexForUsers (UserId)
    SELECT u.UserId
    FROM   dbo.aspnet_Membership m, dbo.aspnet_Users u
    WHERE  u.ApplicationId = @ApplicationId AND u.UserId = m.UserId
    ORDER BY u.UserName

    SELECT @TotalRecords = @@ROWCOUNT

    SELECT u.UserName, m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
            m.CreateDate,
            m.LastLoginDate,
            u.LastActivityDate,
            m.LastPasswordChangedDate,
            u.UserId, m.IsLockedOut,
            m.LastLockoutDate
    FROM   dbo.aspnet_Membership m, dbo.aspnet_Users u, #PageIndexForUsers p
    WHERE  u.UserId = p.UserId AND u.UserId = m.UserId AND
           p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
    ORDER BY u.UserName
    RETURN @TotalRecords
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetNumberOfUsersOnline]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_GetNumberOfUsersOnline]
    @ApplicationName            nvarchar(256),
    @MinutesSinceLastInActive   int,
    @CurrentTimeUtc             datetime
AS
BEGIN
    DECLARE @DateActive datetime
    SELECT  @DateActive = DATEADD(minute,  -(@MinutesSinceLastInActive), @CurrentTimeUtc)

    DECLARE @NumOnline int
    SELECT  @NumOnline = COUNT(*)
    FROM    dbo.aspnet_Users u(NOLOCK),
            dbo.aspnet_Applications a(NOLOCK),
            dbo.aspnet_Membership m(NOLOCK)
    WHERE   u.ApplicationId = a.ApplicationId                  AND
            LastActivityDate > @DateActive                     AND
            a.LoweredApplicationName = LOWER(@ApplicationName) AND
            u.UserId = m.UserId
    RETURN(@NumOnline)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetPassword]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_GetPassword]
    @ApplicationName                nvarchar(256),
    @UserName                       nvarchar(256),
    @MaxInvalidPasswordAttempts     int,
    @PasswordAttemptWindow          int,
    @CurrentTimeUtc                 datetime,
    @PasswordAnswer                 nvarchar(128) = NULL
AS
BEGIN
    DECLARE @UserId                                 uniqueidentifier
    DECLARE @PasswordFormat                         int
    DECLARE @Password                               nvarchar(128)
    DECLARE @passAns                                nvarchar(128)
    DECLARE @IsLockedOut                            bit
    DECLARE @LastLockoutDate                        datetime
    DECLARE @FailedPasswordAttemptCount             int
    DECLARE @FailedPasswordAttemptWindowStart       datetime
    DECLARE @FailedPasswordAnswerAttemptCount       int
    DECLARE @FailedPasswordAnswerAttemptWindowStart datetime

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    SELECT  @UserId = u.UserId,
            @Password = m.Password,
            @passAns = m.PasswordAnswer,
            @PasswordFormat = m.PasswordFormat,
            @IsLockedOut = m.IsLockedOut,
            @LastLockoutDate = m.LastLockoutDate,
            @FailedPasswordAttemptCount = m.FailedPasswordAttemptCount,
            @FailedPasswordAttemptWindowStart = m.FailedPasswordAttemptWindowStart,
            @FailedPasswordAnswerAttemptCount = m.FailedPasswordAnswerAttemptCount,
            @FailedPasswordAnswerAttemptWindowStart = m.FailedPasswordAnswerAttemptWindowStart
    FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m WITH ( UPDLOCK )
    WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.ApplicationId = a.ApplicationId    AND
            u.UserId = m.UserId AND
            LOWER(@UserName) = u.LoweredUserName

    IF ( @@rowcount = 0 )
    BEGIN
        SET @ErrorCode = 1
        GOTO Cleanup
    END

    IF( @IsLockedOut = 1 )
    BEGIN
        SET @ErrorCode = 99
        GOTO Cleanup
    END

    IF ( NOT( @PasswordAnswer IS NULL ) )
    BEGIN
        IF( ( @passAns IS NULL ) OR ( LOWER( @passAns ) <> LOWER( @PasswordAnswer ) ) )
        BEGIN
            IF( @CurrentTimeUtc > DATEADD( minute, @PasswordAttemptWindow, @FailedPasswordAnswerAttemptWindowStart ) )
            BEGIN
                SET @FailedPasswordAnswerAttemptWindowStart = @CurrentTimeUtc
                SET @FailedPasswordAnswerAttemptCount = 1
            END
            ELSE
            BEGIN
                SET @FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount + 1
                SET @FailedPasswordAnswerAttemptWindowStart = @CurrentTimeUtc
            END

            BEGIN
                IF( @FailedPasswordAnswerAttemptCount >= @MaxInvalidPasswordAttempts )
                BEGIN
                    SET @IsLockedOut = 1
                    SET @LastLockoutDate = @CurrentTimeUtc
                END
            END

            SET @ErrorCode = 3
        END
        ELSE
        BEGIN
            IF( @FailedPasswordAnswerAttemptCount > 0 )
            BEGIN
                SET @FailedPasswordAnswerAttemptCount = 0
                SET @FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, '17540101', 112 )
            END
        END

        UPDATE dbo.aspnet_Membership
        SET IsLockedOut = @IsLockedOut, LastLockoutDate = @LastLockoutDate,
            FailedPasswordAttemptCount = @FailedPasswordAttemptCount,
            FailedPasswordAttemptWindowStart = @FailedPasswordAttemptWindowStart,
            FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount,
            FailedPasswordAnswerAttemptWindowStart = @FailedPasswordAnswerAttemptWindowStart
        WHERE @UserId = UserId

        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END
    END

    IF( @TranStarted = 1 )
    BEGIN
	SET @TranStarted = 0
	COMMIT TRANSACTION
    END

    IF( @ErrorCode = 0 )
        SELECT @Password, @PasswordFormat

    RETURN @ErrorCode

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetPasswordWithFormat]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_GetPasswordWithFormat]
    @ApplicationName                nvarchar(256),
    @UserName                       nvarchar(256),
    @UpdateLastLoginActivityDate    bit,
    @CurrentTimeUtc                 datetime
AS
BEGIN
    DECLARE @IsLockedOut                        bit
    DECLARE @UserId                             uniqueidentifier
    DECLARE @Password                           nvarchar(128)
    DECLARE @PasswordSalt                       nvarchar(128)
    DECLARE @PasswordFormat                     int
    DECLARE @FailedPasswordAttemptCount         int
    DECLARE @FailedPasswordAnswerAttemptCount   int
    DECLARE @IsApproved                         bit
    DECLARE @LastActivityDate                   datetime
    DECLARE @LastLoginDate                      datetime

    SELECT  @UserId          = NULL

    SELECT  @UserId = u.UserId, @IsLockedOut = m.IsLockedOut, @Password=Password, @PasswordFormat=PasswordFormat,
            @PasswordSalt=PasswordSalt, @FailedPasswordAttemptCount=FailedPasswordAttemptCount,
		    @FailedPasswordAnswerAttemptCount=FailedPasswordAnswerAttemptCount, @IsApproved=IsApproved,
            @LastActivityDate = LastActivityDate, @LastLoginDate = LastLoginDate
    FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
    WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.ApplicationId = a.ApplicationId    AND
            u.UserId = m.UserId AND
            LOWER(@UserName) = u.LoweredUserName

    IF (@UserId IS NULL)
        RETURN 1

    IF (@IsLockedOut = 1)
        RETURN 99

    SELECT   @Password, @PasswordFormat, @PasswordSalt, @FailedPasswordAttemptCount,
             @FailedPasswordAnswerAttemptCount, @IsApproved, @LastLoginDate, @LastActivityDate

    IF (@UpdateLastLoginActivityDate = 1 AND @IsApproved = 1)
    BEGIN
        UPDATE  dbo.aspnet_Membership
        SET     LastLoginDate = @CurrentTimeUtc
        WHERE   UserId = @UserId

        UPDATE  dbo.aspnet_Users
        SET     LastActivityDate = @CurrentTimeUtc
        WHERE   @UserId = UserId
    END


    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetUserByEmail]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_GetUserByEmail]
    @ApplicationName  nvarchar(256),
    @Email            nvarchar(256)
AS
BEGIN
    IF( @Email IS NULL )
        SELECT  u.UserName
        FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
                u.ApplicationId = a.ApplicationId    AND
                u.UserId = m.UserId AND
                m.LoweredEmail IS NULL
    ELSE
        SELECT  u.UserName
        FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
                u.ApplicationId = a.ApplicationId    AND
                u.UserId = m.UserId AND
                LOWER(@Email) = m.LoweredEmail

    IF (@@rowcount = 0)
        RETURN(1)
    RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetUserByName]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_GetUserByName]
    @ApplicationName      nvarchar(256),
    @UserName             nvarchar(256),
    @CurrentTimeUtc       datetime,
    @UpdateLastActivity   bit = 0
AS
BEGIN
    DECLARE @UserId uniqueidentifier

    IF (@UpdateLastActivity = 1)
    BEGIN
        -- select user ID from aspnet_users table
        SELECT TOP 1 @UserId = u.UserId
        FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE    LOWER(@ApplicationName) = a.LoweredApplicationName AND
                u.ApplicationId = a.ApplicationId    AND
                LOWER(@UserName) = u.LoweredUserName AND u.UserId = m.UserId

        IF (@@ROWCOUNT = 0) -- Username not found
            RETURN -1

        UPDATE   dbo.aspnet_Users
        SET      LastActivityDate = @CurrentTimeUtc
        WHERE    @UserId = UserId

        SELECT m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
                m.CreateDate, m.LastLoginDate, u.LastActivityDate, m.LastPasswordChangedDate,
                u.UserId, m.IsLockedOut, m.LastLockoutDate
        FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE  @UserId = u.UserId AND u.UserId = m.UserId 
    END
    ELSE
    BEGIN
        SELECT TOP 1 m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
                m.CreateDate, m.LastLoginDate, u.LastActivityDate, m.LastPasswordChangedDate,
                u.UserId, m.IsLockedOut,m.LastLockoutDate
        FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m
        WHERE    LOWER(@ApplicationName) = a.LoweredApplicationName AND
                u.ApplicationId = a.ApplicationId    AND
                LOWER(@UserName) = u.LoweredUserName AND u.UserId = m.UserId

        IF (@@ROWCOUNT = 0) -- Username not found
            RETURN -1
    END

    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_GetUserByUserId]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_GetUserByUserId]
    @UserId               uniqueidentifier,
    @CurrentTimeUtc       datetime,
    @UpdateLastActivity   bit = 0
AS
BEGIN
    IF ( @UpdateLastActivity = 1 )
    BEGIN
        UPDATE   dbo.aspnet_Users
        SET      LastActivityDate = @CurrentTimeUtc
        FROM     dbo.aspnet_Users
        WHERE    @UserId = UserId

        IF ( @@ROWCOUNT = 0 ) -- User ID not found
            RETURN -1
    END

    SELECT  m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
            m.CreateDate, m.LastLoginDate, u.LastActivityDate,
            m.LastPasswordChangedDate, u.UserName, m.IsLockedOut,
            m.LastLockoutDate
    FROM    dbo.aspnet_Users u, dbo.aspnet_Membership m
    WHERE   @UserId = u.UserId AND u.UserId = m.UserId

    IF ( @@ROWCOUNT = 0 ) -- User ID not found
       RETURN -1

    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_ResetPassword]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_ResetPassword]
    @ApplicationName             nvarchar(256),
    @UserName                    nvarchar(256),
    @NewPassword                 nvarchar(128),
    @MaxInvalidPasswordAttempts  int,
    @PasswordAttemptWindow       int,
    @PasswordSalt                nvarchar(128),
    @CurrentTimeUtc              datetime,
    @PasswordFormat              int = 0,
    @PasswordAnswer              nvarchar(128) = NULL
AS
BEGIN
    DECLARE @IsLockedOut                            bit
    DECLARE @LastLockoutDate                        datetime
    DECLARE @FailedPasswordAttemptCount             int
    DECLARE @FailedPasswordAttemptWindowStart       datetime
    DECLARE @FailedPasswordAnswerAttemptCount       int
    DECLARE @FailedPasswordAnswerAttemptWindowStart datetime

    DECLARE @UserId                                 uniqueidentifier
    SET     @UserId = NULL

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    SELECT  @UserId = u.UserId
    FROM    dbo.aspnet_Users u, dbo.aspnet_Applications a, dbo.aspnet_Membership m
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId

    IF ( @UserId IS NULL )
    BEGIN
        SET @ErrorCode = 1
        GOTO Cleanup
    END

    SELECT @IsLockedOut = IsLockedOut,
           @LastLockoutDate = LastLockoutDate,
           @FailedPasswordAttemptCount = FailedPasswordAttemptCount,
           @FailedPasswordAttemptWindowStart = FailedPasswordAttemptWindowStart,
           @FailedPasswordAnswerAttemptCount = FailedPasswordAnswerAttemptCount,
           @FailedPasswordAnswerAttemptWindowStart = FailedPasswordAnswerAttemptWindowStart
    FROM dbo.aspnet_Membership WITH ( UPDLOCK )
    WHERE @UserId = UserId

    IF( @IsLockedOut = 1 )
    BEGIN
        SET @ErrorCode = 99
        GOTO Cleanup
    END

    UPDATE dbo.aspnet_Membership
    SET    Password = @NewPassword,
           LastPasswordChangedDate = @CurrentTimeUtc,
           PasswordFormat = @PasswordFormat,
           PasswordSalt = @PasswordSalt
    WHERE  @UserId = UserId AND
           ( ( @PasswordAnswer IS NULL ) OR ( LOWER( PasswordAnswer ) = LOWER( @PasswordAnswer ) ) )

    IF ( @@ROWCOUNT = 0 )
        BEGIN
            IF( @CurrentTimeUtc > DATEADD( minute, @PasswordAttemptWindow, @FailedPasswordAnswerAttemptWindowStart ) )
            BEGIN
                SET @FailedPasswordAnswerAttemptWindowStart = @CurrentTimeUtc
                SET @FailedPasswordAnswerAttemptCount = 1
            END
            ELSE
            BEGIN
                SET @FailedPasswordAnswerAttemptWindowStart = @CurrentTimeUtc
                SET @FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount + 1
            END

            BEGIN
                IF( @FailedPasswordAnswerAttemptCount >= @MaxInvalidPasswordAttempts )
                BEGIN
                    SET @IsLockedOut = 1
                    SET @LastLockoutDate = @CurrentTimeUtc
                END
            END

            SET @ErrorCode = 3
        END
    ELSE
        BEGIN
            IF( @FailedPasswordAnswerAttemptCount > 0 )
            BEGIN
                SET @FailedPasswordAnswerAttemptCount = 0
                SET @FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, '17540101', 112 )
            END
        END

    IF( NOT ( @PasswordAnswer IS NULL ) )
    BEGIN
        UPDATE dbo.aspnet_Membership
        SET IsLockedOut = @IsLockedOut, LastLockoutDate = @LastLockoutDate,
            FailedPasswordAttemptCount = @FailedPasswordAttemptCount,
            FailedPasswordAttemptWindowStart = @FailedPasswordAttemptWindowStart,
            FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount,
            FailedPasswordAnswerAttemptWindowStart = @FailedPasswordAnswerAttemptWindowStart
        WHERE @UserId = UserId

        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END
    END

    IF( @TranStarted = 1 )
    BEGIN
	SET @TranStarted = 0
	COMMIT TRANSACTION
    END

    RETURN @ErrorCode

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_SetPassword]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_SetPassword]
    @ApplicationName  nvarchar(256),
    @UserName         nvarchar(256),
    @NewPassword      nvarchar(128),
    @PasswordSalt     nvarchar(128),
    @CurrentTimeUtc   datetime,
    @PasswordFormat   int = 0
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL
    SELECT  @UserId = u.UserId
    FROM    dbo.aspnet_Users u, dbo.aspnet_Applications a, dbo.aspnet_Membership m
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId

    IF (@UserId IS NULL)
        RETURN(1)

    UPDATE dbo.aspnet_Membership
    SET Password = @NewPassword, PasswordFormat = @PasswordFormat, PasswordSalt = @PasswordSalt,
        LastPasswordChangedDate = @CurrentTimeUtc
    WHERE @UserId = UserId
    RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_UnlockUser]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_UnlockUser]
    @ApplicationName                         nvarchar(256),
    @UserName                                nvarchar(256)
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL
    SELECT  @UserId = u.UserId
    FROM    dbo.aspnet_Users u, dbo.aspnet_Applications a, dbo.aspnet_Membership m
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId

    IF ( @UserId IS NULL )
        RETURN 1

    UPDATE dbo.aspnet_Membership
    SET IsLockedOut = 0,
        FailedPasswordAttemptCount = 0,
        FailedPasswordAttemptWindowStart = CONVERT( datetime, '17540101', 112 ),
        FailedPasswordAnswerAttemptCount = 0,
        FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, '17540101', 112 ),
        LastLockoutDate = CONVERT( datetime, '17540101', 112 )
    WHERE @UserId = UserId

    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_UpdateUser]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_UpdateUser]
    @ApplicationName      nvarchar(256),
    @UserName             nvarchar(256),
    @Email                nvarchar(256),
    @Comment              ntext,
    @IsApproved           bit,
    @LastLoginDate        datetime,
    @LastActivityDate     datetime,
    @UniqueEmail          int,
    @CurrentTimeUtc       datetime
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @UserId = NULL
    SELECT  @UserId = u.UserId, @ApplicationId = a.ApplicationId
    FROM    dbo.aspnet_Users u, dbo.aspnet_Applications a, dbo.aspnet_Membership m
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId

    IF (@UserId IS NULL)
        RETURN(1)

    IF (@UniqueEmail = 1)
    BEGIN
        IF (EXISTS (SELECT *
                    FROM  dbo.aspnet_Membership WITH (UPDLOCK, HOLDLOCK)
                    WHERE ApplicationId = @ApplicationId  AND @UserId <> UserId AND LoweredEmail = LOWER(@Email)))
        BEGIN
            RETURN(7)
        END
    END

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
	SET @TranStarted = 0

    UPDATE dbo.aspnet_Users WITH (ROWLOCK)
    SET
         LastActivityDate = @LastActivityDate
    WHERE
       @UserId = UserId

    IF( @@ERROR <> 0 )
        GOTO Cleanup

    UPDATE dbo.aspnet_Membership WITH (ROWLOCK)
    SET
         Email            = @Email,
         LoweredEmail     = LOWER(@Email),
         Comment          = @Comment,
         IsApproved       = @IsApproved,
         LastLoginDate    = @LastLoginDate
    WHERE
       @UserId = UserId

    IF( @@ERROR <> 0 )
        GOTO Cleanup

    IF( @TranStarted = 1 )
    BEGIN
	SET @TranStarted = 0
	COMMIT TRANSACTION
    END

    RETURN 0

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN -1
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Membership_UpdateUserInfo]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Membership_UpdateUserInfo]
    @ApplicationName                nvarchar(256),
    @UserName                       nvarchar(256),
    @IsPasswordCorrect              bit,
    @UpdateLastLoginActivityDate    bit,
    @MaxInvalidPasswordAttempts     int,
    @PasswordAttemptWindow          int,
    @CurrentTimeUtc                 datetime,
    @LastLoginDate                  datetime,
    @LastActivityDate               datetime
AS
BEGIN
    DECLARE @UserId                                 uniqueidentifier
    DECLARE @IsApproved                             bit
    DECLARE @IsLockedOut                            bit
    DECLARE @LastLockoutDate                        datetime
    DECLARE @FailedPasswordAttemptCount             int
    DECLARE @FailedPasswordAttemptWindowStart       datetime
    DECLARE @FailedPasswordAnswerAttemptCount       int
    DECLARE @FailedPasswordAnswerAttemptWindowStart datetime

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    SELECT  @UserId = u.UserId,
            @IsApproved = m.IsApproved,
            @IsLockedOut = m.IsLockedOut,
            @LastLockoutDate = m.LastLockoutDate,
            @FailedPasswordAttemptCount = m.FailedPasswordAttemptCount,
            @FailedPasswordAttemptWindowStart = m.FailedPasswordAttemptWindowStart,
            @FailedPasswordAnswerAttemptCount = m.FailedPasswordAnswerAttemptCount,
            @FailedPasswordAnswerAttemptWindowStart = m.FailedPasswordAnswerAttemptWindowStart
    FROM    dbo.aspnet_Applications a, dbo.aspnet_Users u, dbo.aspnet_Membership m WITH ( UPDLOCK )
    WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.ApplicationId = a.ApplicationId    AND
            u.UserId = m.UserId AND
            LOWER(@UserName) = u.LoweredUserName

    IF ( @@rowcount = 0 )
    BEGIN
        SET @ErrorCode = 1
        GOTO Cleanup
    END

    IF( @IsLockedOut = 1 )
    BEGIN
        GOTO Cleanup
    END

    IF( @IsPasswordCorrect = 0 )
    BEGIN
        IF( @CurrentTimeUtc > DATEADD( minute, @PasswordAttemptWindow, @FailedPasswordAttemptWindowStart ) )
        BEGIN
            SET @FailedPasswordAttemptWindowStart = @CurrentTimeUtc
            SET @FailedPasswordAttemptCount = 1
        END
        ELSE
        BEGIN
            SET @FailedPasswordAttemptWindowStart = @CurrentTimeUtc
            SET @FailedPasswordAttemptCount = @FailedPasswordAttemptCount + 1
        END

        BEGIN
            IF( @FailedPasswordAttemptCount >= @MaxInvalidPasswordAttempts )
            BEGIN
                SET @IsLockedOut = 1
                SET @LastLockoutDate = @CurrentTimeUtc
            END
        END
    END
    ELSE
    BEGIN
        IF( @FailedPasswordAttemptCount > 0 OR @FailedPasswordAnswerAttemptCount > 0 )
        BEGIN
            SET @FailedPasswordAttemptCount = 0
            SET @FailedPasswordAttemptWindowStart = CONVERT( datetime, '17540101', 112 )
            SET @FailedPasswordAnswerAttemptCount = 0
            SET @FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, '17540101', 112 )
            SET @LastLockoutDate = CONVERT( datetime, '17540101', 112 )
        END
    END

    IF( @UpdateLastLoginActivityDate = 1 )
    BEGIN
        UPDATE  dbo.aspnet_Users
        SET     LastActivityDate = @LastActivityDate
        WHERE   @UserId = UserId

        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END

        UPDATE  dbo.aspnet_Membership
        SET     LastLoginDate = @LastLoginDate
        WHERE   UserId = @UserId

        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END
    END


    UPDATE dbo.aspnet_Membership
    SET IsLockedOut = @IsLockedOut, LastLockoutDate = @LastLockoutDate,
        FailedPasswordAttemptCount = @FailedPasswordAttemptCount,
        FailedPasswordAttemptWindowStart = @FailedPasswordAttemptWindowStart,
        FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount,
        FailedPasswordAnswerAttemptWindowStart = @FailedPasswordAnswerAttemptWindowStart
    WHERE @UserId = UserId

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @TranStarted = 1 )
    BEGIN
	SET @TranStarted = 0
	COMMIT TRANSACTION
    END

    RETURN @ErrorCode

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Paths_CreatePath]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Paths_CreatePath]
    @ApplicationId UNIQUEIDENTIFIER,
    @Path           NVARCHAR(256),
    @PathId         UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    BEGIN TRANSACTION
    IF (NOT EXISTS(SELECT * FROM dbo.aspnet_Paths WHERE LoweredPath = LOWER(@Path) AND ApplicationId = @ApplicationId))
    BEGIN
        INSERT dbo.aspnet_Paths (ApplicationId, Path, LoweredPath) VALUES (@ApplicationId, @Path, LOWER(@Path))
    END
    COMMIT TRANSACTION
    SELECT @PathId = PathId FROM dbo.aspnet_Paths WHERE LOWER(@Path) = LoweredPath AND ApplicationId = @ApplicationId
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Personalization_GetApplicationId]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Personalization_GetApplicationId] (
    @ApplicationName NVARCHAR(256),
    @ApplicationId UNIQUEIDENTIFIER OUT)
AS
BEGIN
    SELECT @ApplicationId = ApplicationId FROM dbo.aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationAdministration_DeleteAllState]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationAdministration_DeleteAllState] (
    @AllUsersScope bit,
    @ApplicationName NVARCHAR(256),
    @Count int OUT)
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    EXEC dbo.aspnet_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
        SELECT @Count = 0
    ELSE
    BEGIN
        IF (@AllUsersScope = 1)
            DELETE FROM aspnet_PersonalizationAllUsers
            WHERE PathId IN
               (SELECT Paths.PathId
                FROM dbo.aspnet_Paths Paths
                WHERE Paths.ApplicationId = @ApplicationId)
        ELSE
            DELETE FROM aspnet_PersonalizationPerUser
            WHERE PathId IN
               (SELECT Paths.PathId
                FROM dbo.aspnet_Paths Paths
                WHERE Paths.ApplicationId = @ApplicationId)

        SELECT @Count = @@ROWCOUNT
    END
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationAdministration_FindState]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationAdministration_FindState] (
    @AllUsersScope bit,
    @ApplicationName NVARCHAR(256),
    @PageIndex              INT,
    @PageSize               INT,
    @Path NVARCHAR(256) = NULL,
    @UserName NVARCHAR(256) = NULL,
    @InactiveSinceDate DATETIME = NULL)
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    EXEC dbo.aspnet_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
        RETURN

    -- Set the page bounds
    DECLARE @PageLowerBound INT
    DECLARE @PageUpperBound INT
    DECLARE @TotalRecords   INT
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table to store the selected results
    CREATE TABLE #PageIndex (
        IndexId int IDENTITY (0, 1) NOT NULL,
        ItemId UNIQUEIDENTIFIER
    )

    IF (@AllUsersScope = 1)
    BEGIN
        -- Insert into our temp table
        INSERT INTO #PageIndex (ItemId)
        SELECT Paths.PathId
        FROM dbo.aspnet_Paths Paths,
             ((SELECT Paths.PathId
               FROM dbo.aspnet_PersonalizationAllUsers AllUsers, dbo.aspnet_Paths Paths
               WHERE Paths.ApplicationId = @ApplicationId
                      AND AllUsers.PathId = Paths.PathId
                      AND (@Path IS NULL OR Paths.LoweredPath LIKE LOWER(@Path))
              ) AS SharedDataPerPath
              FULL OUTER JOIN
              (SELECT DISTINCT Paths.PathId
               FROM dbo.aspnet_PersonalizationPerUser PerUser, dbo.aspnet_Paths Paths
               WHERE Paths.ApplicationId = @ApplicationId
                      AND PerUser.PathId = Paths.PathId
                      AND (@Path IS NULL OR Paths.LoweredPath LIKE LOWER(@Path))
              ) AS UserDataPerPath
              ON SharedDataPerPath.PathId = UserDataPerPath.PathId
             )
        WHERE Paths.PathId = SharedDataPerPath.PathId OR Paths.PathId = UserDataPerPath.PathId
        ORDER BY Paths.Path ASC

        SELECT @TotalRecords = @@ROWCOUNT

        SELECT Paths.Path,
               SharedDataPerPath.LastUpdatedDate,
               SharedDataPerPath.SharedDataLength,
               UserDataPerPath.UserDataLength,
               UserDataPerPath.UserCount
        FROM dbo.aspnet_Paths Paths,
             ((SELECT PageIndex.ItemId AS PathId,
                      AllUsers.LastUpdatedDate AS LastUpdatedDate,
                      DATALENGTH(AllUsers.PageSettings) AS SharedDataLength
               FROM dbo.aspnet_PersonalizationAllUsers AllUsers, #PageIndex PageIndex
               WHERE AllUsers.PathId = PageIndex.ItemId
                     AND PageIndex.IndexId >= @PageLowerBound AND PageIndex.IndexId <= @PageUpperBound
              ) AS SharedDataPerPath
              FULL OUTER JOIN
              (SELECT PageIndex.ItemId AS PathId,
                      SUM(DATALENGTH(PerUser.PageSettings)) AS UserDataLength,
                      COUNT(*) AS UserCount
               FROM aspnet_PersonalizationPerUser PerUser, #PageIndex PageIndex
               WHERE PerUser.PathId = PageIndex.ItemId
                     AND PageIndex.IndexId >= @PageLowerBound AND PageIndex.IndexId <= @PageUpperBound
               GROUP BY PageIndex.ItemId
              ) AS UserDataPerPath
              ON SharedDataPerPath.PathId = UserDataPerPath.PathId
             )
        WHERE Paths.PathId = SharedDataPerPath.PathId OR Paths.PathId = UserDataPerPath.PathId
        ORDER BY Paths.Path ASC
    END
    ELSE
    BEGIN
        -- Insert into our temp table
        INSERT INTO #PageIndex (ItemId)
        SELECT PerUser.Id
        FROM dbo.aspnet_PersonalizationPerUser PerUser, dbo.aspnet_Users Users, dbo.aspnet_Paths Paths
        WHERE Paths.ApplicationId = @ApplicationId
              AND PerUser.UserId = Users.UserId
              AND PerUser.PathId = Paths.PathId
              AND (@Path IS NULL OR Paths.LoweredPath LIKE LOWER(@Path))
              AND (@UserName IS NULL OR Users.LoweredUserName LIKE LOWER(@UserName))
              AND (@InactiveSinceDate IS NULL OR Users.LastActivityDate <= @InactiveSinceDate)
        ORDER BY Paths.Path ASC, Users.UserName ASC

        SELECT @TotalRecords = @@ROWCOUNT

        SELECT Paths.Path, PerUser.LastUpdatedDate, DATALENGTH(PerUser.PageSettings), Users.UserName, Users.LastActivityDate
        FROM dbo.aspnet_PersonalizationPerUser PerUser, dbo.aspnet_Users Users, dbo.aspnet_Paths Paths, #PageIndex PageIndex
        WHERE PerUser.Id = PageIndex.ItemId
              AND PerUser.UserId = Users.UserId
              AND PerUser.PathId = Paths.PathId
              AND PageIndex.IndexId >= @PageLowerBound AND PageIndex.IndexId <= @PageUpperBound
        ORDER BY Paths.Path ASC, Users.UserName ASC
    END

    RETURN @TotalRecords
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationAdministration_GetCountOfState]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationAdministration_GetCountOfState] (
    @Count int OUT,
    @AllUsersScope bit,
    @ApplicationName NVARCHAR(256),
    @Path NVARCHAR(256) = NULL,
    @UserName NVARCHAR(256) = NULL,
    @InactiveSinceDate DATETIME = NULL)
AS
BEGIN

    DECLARE @ApplicationId UNIQUEIDENTIFIER
    EXEC dbo.aspnet_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
        SELECT @Count = 0
    ELSE
        IF (@AllUsersScope = 1)
            SELECT @Count = COUNT(*)
            FROM dbo.aspnet_PersonalizationAllUsers AllUsers, dbo.aspnet_Paths Paths
            WHERE Paths.ApplicationId = @ApplicationId
                  AND AllUsers.PathId = Paths.PathId
                  AND (@Path IS NULL OR Paths.LoweredPath LIKE LOWER(@Path))
        ELSE
            SELECT @Count = COUNT(*)
            FROM dbo.aspnet_PersonalizationPerUser PerUser, dbo.aspnet_Users Users, dbo.aspnet_Paths Paths
            WHERE Paths.ApplicationId = @ApplicationId
                  AND PerUser.UserId = Users.UserId
                  AND PerUser.PathId = Paths.PathId
                  AND (@Path IS NULL OR Paths.LoweredPath LIKE LOWER(@Path))
                  AND (@UserName IS NULL OR Users.LoweredUserName LIKE LOWER(@UserName))
                  AND (@InactiveSinceDate IS NULL OR Users.LastActivityDate <= @InactiveSinceDate)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationAdministration_ResetSharedState]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationAdministration_ResetSharedState] (
    @Count int OUT,
    @ApplicationName NVARCHAR(256),
    @Path NVARCHAR(256))
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    EXEC dbo.aspnet_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
        SELECT @Count = 0
    ELSE
    BEGIN
        DELETE FROM dbo.aspnet_PersonalizationAllUsers
        WHERE PathId IN
            (SELECT AllUsers.PathId
             FROM dbo.aspnet_PersonalizationAllUsers AllUsers, dbo.aspnet_Paths Paths
             WHERE Paths.ApplicationId = @ApplicationId
                   AND AllUsers.PathId = Paths.PathId
                   AND Paths.LoweredPath = LOWER(@Path))

        SELECT @Count = @@ROWCOUNT
    END
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationAdministration_ResetUserState]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationAdministration_ResetUserState] (
    @Count                  int                 OUT,
    @ApplicationName        NVARCHAR(256),
    @InactiveSinceDate      DATETIME            = NULL,
    @UserName               NVARCHAR(256)       = NULL,
    @Path                   NVARCHAR(256)       = NULL)
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    EXEC dbo.aspnet_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
        SELECT @Count = 0
    ELSE
    BEGIN
        DELETE FROM dbo.aspnet_PersonalizationPerUser
        WHERE Id IN (SELECT PerUser.Id
                     FROM dbo.aspnet_PersonalizationPerUser PerUser, dbo.aspnet_Users Users, dbo.aspnet_Paths Paths
                     WHERE Paths.ApplicationId = @ApplicationId
                           AND PerUser.UserId = Users.UserId
                           AND PerUser.PathId = Paths.PathId
                           AND (@InactiveSinceDate IS NULL OR Users.LastActivityDate <= @InactiveSinceDate)
                           AND (@UserName IS NULL OR Users.LoweredUserName = LOWER(@UserName))
                           AND (@Path IS NULL OR Paths.LoweredPath = LOWER(@Path)))

        SELECT @Count = @@ROWCOUNT
    END
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationAllUsers_GetPageSettings]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationAllUsers_GetPageSettings] (
    @ApplicationName  NVARCHAR(256),
    @Path              NVARCHAR(256))
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    DECLARE @PathId UNIQUEIDENTIFIER

    SELECT @ApplicationId = NULL
    SELECT @PathId = NULL

    EXEC dbo.aspnet_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
    BEGIN
        RETURN
    END

    SELECT @PathId = u.PathId FROM dbo.aspnet_Paths u WHERE u.ApplicationId = @ApplicationId AND u.LoweredPath = LOWER(@Path)
    IF (@PathId IS NULL)
    BEGIN
        RETURN
    END

    SELECT p.PageSettings FROM dbo.aspnet_PersonalizationAllUsers p WHERE p.PathId = @PathId
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationAllUsers_ResetPageSettings]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationAllUsers_ResetPageSettings] (
    @ApplicationName  NVARCHAR(256),
    @Path              NVARCHAR(256))
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    DECLARE @PathId UNIQUEIDENTIFIER

    SELECT @ApplicationId = NULL
    SELECT @PathId = NULL

    EXEC dbo.aspnet_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
    BEGIN
        RETURN
    END

    SELECT @PathId = u.PathId FROM dbo.aspnet_Paths u WHERE u.ApplicationId = @ApplicationId AND u.LoweredPath = LOWER(@Path)
    IF (@PathId IS NULL)
    BEGIN
        RETURN
    END

    DELETE FROM dbo.aspnet_PersonalizationAllUsers WHERE PathId = @PathId
    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationAllUsers_SetPageSettings]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationAllUsers_SetPageSettings] (
    @ApplicationName  NVARCHAR(256),
    @Path             NVARCHAR(256),
    @PageSettings     IMAGE,
    @CurrentTimeUtc   DATETIME)
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    DECLARE @PathId UNIQUEIDENTIFIER

    SELECT @ApplicationId = NULL
    SELECT @PathId = NULL

    EXEC dbo.aspnet_Applications_CreateApplication @ApplicationName, @ApplicationId OUTPUT

    SELECT @PathId = u.PathId FROM dbo.aspnet_Paths u WHERE u.ApplicationId = @ApplicationId AND u.LoweredPath = LOWER(@Path)
    IF (@PathId IS NULL)
    BEGIN
        EXEC dbo.aspnet_Paths_CreatePath @ApplicationId, @Path, @PathId OUTPUT
    END

    IF (EXISTS(SELECT PathId FROM dbo.aspnet_PersonalizationAllUsers WHERE PathId = @PathId))
        UPDATE dbo.aspnet_PersonalizationAllUsers SET PageSettings = @PageSettings, LastUpdatedDate = @CurrentTimeUtc WHERE PathId = @PathId
    ELSE
        INSERT INTO dbo.aspnet_PersonalizationAllUsers(PathId, PageSettings, LastUpdatedDate) VALUES (@PathId, @PageSettings, @CurrentTimeUtc)
    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationPerUser_GetPageSettings]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationPerUser_GetPageSettings] (
    @ApplicationName  NVARCHAR(256),
    @UserName         NVARCHAR(256),
    @Path             NVARCHAR(256),
    @CurrentTimeUtc   DATETIME)
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    DECLARE @PathId UNIQUEIDENTIFIER
    DECLARE @UserId UNIQUEIDENTIFIER

    SELECT @ApplicationId = NULL
    SELECT @PathId = NULL
    SELECT @UserId = NULL

    EXEC dbo.aspnet_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
    BEGIN
        RETURN
    END

    SELECT @PathId = u.PathId FROM dbo.aspnet_Paths u WHERE u.ApplicationId = @ApplicationId AND u.LoweredPath = LOWER(@Path)
    IF (@PathId IS NULL)
    BEGIN
        RETURN
    END

    SELECT @UserId = u.UserId FROM dbo.aspnet_Users u WHERE u.ApplicationId = @ApplicationId AND u.LoweredUserName = LOWER(@UserName)
    IF (@UserId IS NULL)
    BEGIN
        RETURN
    END

    UPDATE   dbo.aspnet_Users WITH (ROWLOCK)
    SET      LastActivityDate = @CurrentTimeUtc
    WHERE    UserId = @UserId
    IF (@@ROWCOUNT = 0) -- Username not found
        RETURN

    SELECT p.PageSettings FROM dbo.aspnet_PersonalizationPerUser p WHERE p.PathId = @PathId AND p.UserId = @UserId
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationPerUser_ResetPageSettings]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationPerUser_ResetPageSettings] (
    @ApplicationName  NVARCHAR(256),
    @UserName         NVARCHAR(256),
    @Path             NVARCHAR(256),
    @CurrentTimeUtc   DATETIME)
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    DECLARE @PathId UNIQUEIDENTIFIER
    DECLARE @UserId UNIQUEIDENTIFIER

    SELECT @ApplicationId = NULL
    SELECT @PathId = NULL
    SELECT @UserId = NULL

    EXEC dbo.aspnet_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
    BEGIN
        RETURN
    END

    SELECT @PathId = u.PathId FROM dbo.aspnet_Paths u WHERE u.ApplicationId = @ApplicationId AND u.LoweredPath = LOWER(@Path)
    IF (@PathId IS NULL)
    BEGIN
        RETURN
    END

    SELECT @UserId = u.UserId FROM dbo.aspnet_Users u WHERE u.ApplicationId = @ApplicationId AND u.LoweredUserName = LOWER(@UserName)
    IF (@UserId IS NULL)
    BEGIN
        RETURN
    END

    UPDATE   dbo.aspnet_Users WITH (ROWLOCK)
    SET      LastActivityDate = @CurrentTimeUtc
    WHERE    UserId = @UserId
    IF (@@ROWCOUNT = 0) -- Username not found
        RETURN

    DELETE FROM dbo.aspnet_PersonalizationPerUser WHERE PathId = @PathId AND UserId = @UserId
    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_PersonalizationPerUser_SetPageSettings]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_PersonalizationPerUser_SetPageSettings] (
    @ApplicationName  NVARCHAR(256),
    @UserName         NVARCHAR(256),
    @Path             NVARCHAR(256),
    @PageSettings     IMAGE,
    @CurrentTimeUtc   DATETIME)
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    DECLARE @PathId UNIQUEIDENTIFIER
    DECLARE @UserId UNIQUEIDENTIFIER

    SELECT @ApplicationId = NULL
    SELECT @PathId = NULL
    SELECT @UserId = NULL

    EXEC dbo.aspnet_Applications_CreateApplication @ApplicationName, @ApplicationId OUTPUT

    SELECT @PathId = u.PathId FROM dbo.aspnet_Paths u WHERE u.ApplicationId = @ApplicationId AND u.LoweredPath = LOWER(@Path)
    IF (@PathId IS NULL)
    BEGIN
        EXEC dbo.aspnet_Paths_CreatePath @ApplicationId, @Path, @PathId OUTPUT
    END

    SELECT @UserId = u.UserId FROM dbo.aspnet_Users u WHERE u.ApplicationId = @ApplicationId AND u.LoweredUserName = LOWER(@UserName)
    IF (@UserId IS NULL)
    BEGIN
        EXEC dbo.aspnet_Users_CreateUser @ApplicationId, @UserName, 0, @CurrentTimeUtc, @UserId OUTPUT
    END

    UPDATE   dbo.aspnet_Users WITH (ROWLOCK)
    SET      LastActivityDate = @CurrentTimeUtc
    WHERE    UserId = @UserId
    IF (@@ROWCOUNT = 0) -- Username not found
        RETURN

    IF (EXISTS(SELECT PathId FROM dbo.aspnet_PersonalizationPerUser WHERE UserId = @UserId AND PathId = @PathId))
        UPDATE dbo.aspnet_PersonalizationPerUser SET PageSettings = @PageSettings, LastUpdatedDate = @CurrentTimeUtc WHERE UserId = @UserId AND PathId = @PathId
    ELSE
        INSERT INTO dbo.aspnet_PersonalizationPerUser(UserId, PathId, PageSettings, LastUpdatedDate) VALUES (@UserId, @PathId, @PageSettings, @CurrentTimeUtc)
    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Profile_DeleteInactiveProfiles]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_Profile_DeleteInactiveProfiles]
    @ApplicationName        nvarchar(256),
    @ProfileAuthOptions     int,
    @InactiveSinceDate      datetime
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
    BEGIN
        SELECT  0
        RETURN
    END

    DELETE
    FROM    dbo.aspnet_Profile
    WHERE   UserId IN
            (   SELECT  UserId
                FROM    dbo.aspnet_Users u
                WHERE   ApplicationId = @ApplicationId
                        AND (LastActivityDate <= @InactiveSinceDate)
                        AND (
                                (@ProfileAuthOptions = 2)
                             OR (@ProfileAuthOptions = 0 AND IsAnonymous = 1)
                             OR (@ProfileAuthOptions = 1 AND IsAnonymous = 0)
                            )
            )

    SELECT  @@ROWCOUNT
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Profile_DeleteProfiles]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_Profile_DeleteProfiles]
    @ApplicationName        nvarchar(256),
    @UserNames              nvarchar(4000)
AS
BEGIN
    DECLARE @UserName     nvarchar(256)
    DECLARE @CurrentPos   int
    DECLARE @NextPos      int
    DECLARE @NumDeleted   int
    DECLARE @DeletedUser  int
    DECLARE @TranStarted  bit
    DECLARE @ErrorCode    int

    SET @ErrorCode = 0
    SET @CurrentPos = 1
    SET @NumDeleted = 0
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
        BEGIN TRANSACTION
        SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    WHILE (@CurrentPos <= LEN(@UserNames))
    BEGIN
        SELECT @NextPos = CHARINDEX(N',', @UserNames,  @CurrentPos)
        IF (@NextPos = 0 OR @NextPos IS NULL)
            SELECT @NextPos = LEN(@UserNames) + 1

        SELECT @UserName = SUBSTRING(@UserNames, @CurrentPos, @NextPos - @CurrentPos)
        SELECT @CurrentPos = @NextPos+1

        IF (LEN(@UserName) > 0)
        BEGIN
            SELECT @DeletedUser = 0
            EXEC dbo.aspnet_Users_DeleteUser @ApplicationName, @UserName, 4, @DeletedUser OUTPUT
            IF( @@ERROR <> 0 )
            BEGIN
                SET @ErrorCode = -1
                GOTO Cleanup
            END
            IF (@DeletedUser <> 0)
                SELECT @NumDeleted = @NumDeleted + 1
        END
    END
    SELECT @NumDeleted
    IF (@TranStarted = 1)
    BEGIN
    	SET @TranStarted = 0
    	COMMIT TRANSACTION
    END
    SET @TranStarted = 0

    RETURN 0

Cleanup:
    IF (@TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END
    RETURN @ErrorCode
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Profile_GetNumberOfInactiveProfiles]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_Profile_GetNumberOfInactiveProfiles]
    @ApplicationName        nvarchar(256),
    @ProfileAuthOptions     int,
    @InactiveSinceDate      datetime
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
    BEGIN
        SELECT 0
        RETURN
    END

    SELECT  COUNT(*)
    FROM    dbo.aspnet_Users u, dbo.aspnet_Profile p
    WHERE   ApplicationId = @ApplicationId
        AND u.UserId = p.UserId
        AND (LastActivityDate <= @InactiveSinceDate)
        AND (
                (@ProfileAuthOptions = 2)
                OR (@ProfileAuthOptions = 0 AND IsAnonymous = 1)
                OR (@ProfileAuthOptions = 1 AND IsAnonymous = 0)
            )
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Profile_GetProfiles]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_Profile_GetProfiles]
    @ApplicationName        nvarchar(256),
    @ProfileAuthOptions     int,
    @PageIndex              int,
    @PageSize               int,
    @UserNameToMatch        nvarchar(256) = NULL,
    @InactiveSinceDate      datetime      = NULL
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN

    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId uniqueidentifier
    )

    -- Insert into our temp table
    INSERT INTO #PageIndexForUsers (UserId)
        SELECT  u.UserId
        FROM    dbo.aspnet_Users u, dbo.aspnet_Profile p
        WHERE   ApplicationId = @ApplicationId
            AND u.UserId = p.UserId
            AND (@InactiveSinceDate IS NULL OR LastActivityDate <= @InactiveSinceDate)
            AND (     (@ProfileAuthOptions = 2)
                   OR (@ProfileAuthOptions = 0 AND IsAnonymous = 1)
                   OR (@ProfileAuthOptions = 1 AND IsAnonymous = 0)
                 )
            AND (@UserNameToMatch IS NULL OR LoweredUserName LIKE LOWER(@UserNameToMatch))
        ORDER BY UserName

    SELECT  u.UserName, u.IsAnonymous, u.LastActivityDate, p.LastUpdatedDate,
            DATALENGTH(p.PropertyNames) + DATALENGTH(p.PropertyValuesString) + DATALENGTH(p.PropertyValuesBinary)
    FROM    dbo.aspnet_Users u, dbo.aspnet_Profile p, #PageIndexForUsers i
    WHERE   u.UserId = p.UserId AND p.UserId = i.UserId AND i.IndexId >= @PageLowerBound AND i.IndexId <= @PageUpperBound

    SELECT COUNT(*)
    FROM   #PageIndexForUsers

    DROP TABLE #PageIndexForUsers
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Profile_GetProperties]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_Profile_GetProperties]
    @ApplicationName      nvarchar(256),
    @UserName             nvarchar(256),
    @CurrentTimeUtc       datetime
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM dbo.aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN

    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL

    SELECT @UserId = UserId
    FROM   dbo.aspnet_Users
    WHERE  ApplicationId = @ApplicationId AND LoweredUserName = LOWER(@UserName)

    IF (@UserId IS NULL)
        RETURN
    SELECT TOP 1 PropertyNames, PropertyValuesString, PropertyValuesBinary
    FROM         dbo.aspnet_Profile
    WHERE        UserId = @UserId

    IF (@@ROWCOUNT > 0)
    BEGIN
        UPDATE dbo.aspnet_Users
        SET    LastActivityDate=@CurrentTimeUtc
        WHERE  UserId = @UserId
    END
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Profile_SetProperties]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_Profile_SetProperties]
    @ApplicationName        nvarchar(256),
    @PropertyNames          ntext,
    @PropertyValuesString   ntext,
    @PropertyValuesBinary   image,
    @UserName               nvarchar(256),
    @IsUserAnonymous        bit,
    @CurrentTimeUtc         datetime
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
       BEGIN TRANSACTION
       SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    EXEC dbo.aspnet_Applications_CreateApplication @ApplicationName, @ApplicationId OUTPUT

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    DECLARE @UserId uniqueidentifier
    DECLARE @LastActivityDate datetime
    SELECT  @UserId = NULL
    SELECT  @LastActivityDate = @CurrentTimeUtc

    SELECT @UserId = UserId
    FROM   dbo.aspnet_Users
    WHERE  ApplicationId = @ApplicationId AND LoweredUserName = LOWER(@UserName)
    IF (@UserId IS NULL)
        EXEC dbo.aspnet_Users_CreateUser @ApplicationId, @UserName, @IsUserAnonymous, @LastActivityDate, @UserId OUTPUT

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    UPDATE dbo.aspnet_Users
    SET    LastActivityDate=@CurrentTimeUtc
    WHERE  UserId = @UserId

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF (EXISTS( SELECT *
               FROM   dbo.aspnet_Profile
               WHERE  UserId = @UserId))
        UPDATE dbo.aspnet_Profile
        SET    PropertyNames=@PropertyNames, PropertyValuesString = @PropertyValuesString,
               PropertyValuesBinary = @PropertyValuesBinary, LastUpdatedDate=@CurrentTimeUtc
        WHERE  UserId = @UserId
    ELSE
        INSERT INTO dbo.aspnet_Profile(UserId, PropertyNames, PropertyValuesString, PropertyValuesBinary, LastUpdatedDate)
             VALUES (@UserId, @PropertyNames, @PropertyValuesString, @PropertyValuesBinary, @CurrentTimeUtc)

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @TranStarted = 1 )
    BEGIN
    	SET @TranStarted = 0
    	COMMIT TRANSACTION
    END

    RETURN 0

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_RegisterSchemaVersion]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_RegisterSchemaVersion]
    @Feature                   nvarchar(128),
    @CompatibleSchemaVersion   nvarchar(128),
    @IsCurrentVersion          bit,
    @RemoveIncompatibleSchema  bit
AS
BEGIN
    IF( @RemoveIncompatibleSchema = 1 )
    BEGIN
        DELETE FROM dbo.aspnet_SchemaVersions WHERE Feature = LOWER( @Feature )
    END
    ELSE
    BEGIN
        IF( @IsCurrentVersion = 1 )
        BEGIN
            UPDATE dbo.aspnet_SchemaVersions
            SET IsCurrentVersion = 0
            WHERE Feature = LOWER( @Feature )
        END
    END

    INSERT  dbo.aspnet_SchemaVersions( Feature, CompatibleSchemaVersion, IsCurrentVersion )
    VALUES( LOWER( @Feature ), @CompatibleSchemaVersion, @IsCurrentVersion )
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Roles_CreateRole]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Roles_CreateRole]
    @ApplicationName  nvarchar(256),
    @RoleName         nvarchar(256)
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
        BEGIN TRANSACTION
        SET @TranStarted = 1
    END
    ELSE
        SET @TranStarted = 0

    EXEC dbo.aspnet_Applications_CreateApplication @ApplicationName, @ApplicationId OUTPUT

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF (EXISTS(SELECT RoleId FROM dbo.aspnet_Roles WHERE LoweredRoleName = LOWER(@RoleName) AND ApplicationId = @ApplicationId))
    BEGIN
        SET @ErrorCode = 1
        GOTO Cleanup
    END

    INSERT INTO dbo.aspnet_Roles
                (ApplicationId, RoleName, LoweredRoleName)
         VALUES (@ApplicationId, @RoleName, LOWER(@RoleName))

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
        COMMIT TRANSACTION
    END

    RETURN(0)

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
        ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Roles_DeleteRole]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_Roles_DeleteRole]
    @ApplicationName            nvarchar(256),
    @RoleName                   nvarchar(256),
    @DeleteOnlyIfRoleIsEmpty    bit
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN(1)

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
        BEGIN TRANSACTION
        SET @TranStarted = 1
    END
    ELSE
        SET @TranStarted = 0

    DECLARE @RoleId   uniqueidentifier
    SELECT  @RoleId = NULL
    SELECT  @RoleId = RoleId FROM dbo.aspnet_Roles WHERE LoweredRoleName = LOWER(@RoleName) AND ApplicationId = @ApplicationId

    IF (@RoleId IS NULL)
    BEGIN
        SELECT @ErrorCode = 1
        GOTO Cleanup
    END
    IF (@DeleteOnlyIfRoleIsEmpty <> 0)
    BEGIN
        IF (EXISTS (SELECT RoleId FROM dbo.aspnet_UsersInRoles  WHERE @RoleId = RoleId))
        BEGIN
            SELECT @ErrorCode = 2
            GOTO Cleanup
        END
    END


    DELETE FROM dbo.aspnet_UsersInRoles  WHERE @RoleId = RoleId

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    DELETE FROM dbo.aspnet_Roles WHERE @RoleId = RoleId  AND ApplicationId = @ApplicationId

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
        COMMIT TRANSACTION
    END

    RETURN(0)

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
        ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Roles_GetAllRoles]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_Roles_GetAllRoles] (
    @ApplicationName           nvarchar(256))
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN
    SELECT RoleName
    FROM   dbo.aspnet_Roles WHERE ApplicationId = @ApplicationId
    ORDER BY RoleName
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Roles_RoleExists]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_Roles_RoleExists]
    @ApplicationName  nvarchar(256),
    @RoleName         nvarchar(256)
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN(0)
    IF (EXISTS (SELECT RoleName FROM dbo.aspnet_Roles WHERE LOWER(@RoleName) = LoweredRoleName AND ApplicationId = @ApplicationId ))
        RETURN(1)
    ELSE
        RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Setup_RemoveAllRoleMembers]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_Setup_RemoveAllRoleMembers]
    @name   sysname
AS
BEGIN
    CREATE TABLE #aspnet_RoleMembers
    (
        Group_name      sysname,
        Group_id        smallint,
        Users_in_group  sysname,
        User_id         smallint
    )

    INSERT INTO #aspnet_RoleMembers
    EXEC sp_helpuser @name

    DECLARE @user_id smallint
    DECLARE @cmd nvarchar(500)
    DECLARE c1 cursor FORWARD_ONLY FOR
        SELECT User_id FROM #aspnet_RoleMembers

    OPEN c1

    FETCH c1 INTO @user_id
    WHILE (@@fetch_status = 0)
    BEGIN
        SET @cmd = 'EXEC sp_droprolemember ' + '''' + @name + ''', ''' + USER_NAME(@user_id) + ''''
        EXEC (@cmd)
        FETCH c1 INTO @user_id
    END

    CLOSE c1
    DEALLOCATE c1
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Setup_RestorePermissions]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_Setup_RestorePermissions]
    @name   sysname
AS
BEGIN
    DECLARE @object sysname
    DECLARE @protectType char(10)
    DECLARE @action varchar(60)
    DECLARE @grantee sysname
    DECLARE @cmd nvarchar(500)
    DECLARE c1 cursor FORWARD_ONLY FOR
        SELECT Object, ProtectType, [Action], Grantee FROM #aspnet_Permissions where Object = @name

    OPEN c1

    FETCH c1 INTO @object, @protectType, @action, @grantee
    WHILE (@@fetch_status = 0)
    BEGIN
        SET @cmd = @protectType + ' ' + @action + ' on ' + @object + ' TO [' + @grantee + ']'
        EXEC (@cmd)
        FETCH c1 INTO @object, @protectType, @action, @grantee
    END

    CLOSE c1
    DEALLOCATE c1
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_UnRegisterSchemaVersion]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_UnRegisterSchemaVersion]
    @Feature                   nvarchar(128),
    @CompatibleSchemaVersion   nvarchar(128)
AS
BEGIN
    DELETE FROM dbo.aspnet_SchemaVersions
        WHERE   Feature = LOWER(@Feature) AND @CompatibleSchemaVersion = CompatibleSchemaVersion
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Users_CreateUser]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_Users_CreateUser]
    @ApplicationId    uniqueidentifier,
    @UserName         nvarchar(256),
    @IsUserAnonymous  bit,
    @LastActivityDate DATETIME,
    @UserId           uniqueidentifier OUTPUT
AS
BEGIN
    IF( @UserId IS NULL )
        SELECT @UserId = NEWID()
    ELSE
    BEGIN
        IF( EXISTS( SELECT UserId FROM dbo.aspnet_Users
                    WHERE @UserId = UserId ) )
            RETURN -1
    END

    INSERT dbo.aspnet_Users (ApplicationId, UserId, UserName, LoweredUserName, IsAnonymous, LastActivityDate)
    VALUES (@ApplicationId, @UserId, @UserName, LOWER(@UserName), @IsUserAnonymous, @LastActivityDate)

    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_Users_DeleteUser]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_Users_DeleteUser]
    @ApplicationName  nvarchar(256),
    @UserName         nvarchar(256),
    @TablesToDeleteFrom int,
    @NumTablesDeletedFrom int OUTPUT
AS
BEGIN
    DECLARE @UserId               uniqueidentifier
    SELECT  @UserId               = NULL
    SELECT  @NumTablesDeletedFrom = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
	SET @TranStarted = 0

    DECLARE @ErrorCode   int
    DECLARE @RowCount    int

    SET @ErrorCode = 0
    SET @RowCount  = 0

    SELECT  @UserId = u.UserId
    FROM    dbo.aspnet_Users u, dbo.aspnet_Applications a
    WHERE   u.LoweredUserName       = LOWER(@UserName)
        AND u.ApplicationId         = a.ApplicationId
        AND LOWER(@ApplicationName) = a.LoweredApplicationName

    IF (@UserId IS NULL)
    BEGIN
        GOTO Cleanup
    END

    -- Delete from Membership table if (@TablesToDeleteFrom & 1) is set
    IF ((@TablesToDeleteFrom & 1) <> 0 AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_aspnet_MembershipUsers') AND (type = 'V'))))
    BEGIN
        DELETE FROM dbo.aspnet_Membership WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
               @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    -- Delete from aspnet_UsersInRoles table if (@TablesToDeleteFrom & 2) is set
    IF ((@TablesToDeleteFrom & 2) <> 0  AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_aspnet_UsersInRoles') AND (type = 'V'))) )
    BEGIN
        DELETE FROM dbo.aspnet_UsersInRoles WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
                @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    -- Delete from aspnet_Profile table if (@TablesToDeleteFrom & 4) is set
    IF ((@TablesToDeleteFrom & 4) <> 0  AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_aspnet_Profiles') AND (type = 'V'))) )
    BEGIN
        DELETE FROM dbo.aspnet_Profile WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
                @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    -- Delete from aspnet_PersonalizationPerUser table if (@TablesToDeleteFrom & 8) is set
    IF ((@TablesToDeleteFrom & 8) <> 0  AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_aspnet_WebPartState_User') AND (type = 'V'))) )
    BEGIN
        DELETE FROM dbo.aspnet_PersonalizationPerUser WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
                @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    -- Delete from aspnet_Users table if (@TablesToDeleteFrom & 1,2,4 & 8) are all set
    IF ((@TablesToDeleteFrom & 1) <> 0 AND
        (@TablesToDeleteFrom & 2) <> 0 AND
        (@TablesToDeleteFrom & 4) <> 0 AND
        (@TablesToDeleteFrom & 8) <> 0 AND
        (EXISTS (SELECT UserId FROM dbo.aspnet_Users WHERE @UserId = UserId)))
    BEGIN
        DELETE FROM dbo.aspnet_Users WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
                @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    IF( @TranStarted = 1 )
    BEGIN
	    SET @TranStarted = 0
	    COMMIT TRANSACTION
    END

    RETURN 0

Cleanup:
    SET @NumTablesDeletedFrom = 0

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
	    ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_UsersInRoles_AddUsersToRoles]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_UsersInRoles_AddUsersToRoles]
	@ApplicationName  nvarchar(256),
	@UserNames		  nvarchar(4000),
	@RoleNames		  nvarchar(4000),
	@CurrentTimeUtc   datetime
AS
BEGIN
	DECLARE @AppId uniqueidentifier
	SELECT  @AppId = NULL
	SELECT  @AppId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
	IF (@AppId IS NULL)
		RETURN(2)
	DECLARE @TranStarted   bit
	SET @TranStarted = 0

	IF( @@TRANCOUNT = 0 )
	BEGIN
		BEGIN TRANSACTION
		SET @TranStarted = 1
	END

	DECLARE @tbNames	table(Name nvarchar(256) NOT NULL PRIMARY KEY)
	DECLARE @tbRoles	table(RoleId uniqueidentifier NOT NULL PRIMARY KEY)
	DECLARE @tbUsers	table(UserId uniqueidentifier NOT NULL PRIMARY KEY)
	DECLARE @Num		int
	DECLARE @Pos		int
	DECLARE @NextPos	int
	DECLARE @Name		nvarchar(256)

	SET @Num = 0
	SET @Pos = 1
	WHILE(@Pos <= LEN(@RoleNames))
	BEGIN
		SELECT @NextPos = CHARINDEX(N',', @RoleNames,  @Pos)
		IF (@NextPos = 0 OR @NextPos IS NULL)
			SELECT @NextPos = LEN(@RoleNames) + 1
		SELECT @Name = RTRIM(LTRIM(SUBSTRING(@RoleNames, @Pos, @NextPos - @Pos)))
		SELECT @Pos = @NextPos+1

		INSERT INTO @tbNames VALUES (@Name)
		SET @Num = @Num + 1
	END

	INSERT INTO @tbRoles
	  SELECT RoleId
	  FROM   dbo.aspnet_Roles ar, @tbNames t
	  WHERE  LOWER(t.Name) = ar.LoweredRoleName AND ar.ApplicationId = @AppId

	IF (@@ROWCOUNT <> @Num)
	BEGIN
		SELECT TOP 1 Name
		FROM   @tbNames
		WHERE  LOWER(Name) NOT IN (SELECT ar.LoweredRoleName FROM dbo.aspnet_Roles ar,  @tbRoles r WHERE r.RoleId = ar.RoleId)
		IF( @TranStarted = 1 )
			ROLLBACK TRANSACTION
		RETURN(2)
	END

	DELETE FROM @tbNames WHERE 1=1
	SET @Num = 0
	SET @Pos = 1

	WHILE(@Pos <= LEN(@UserNames))
	BEGIN
		SELECT @NextPos = CHARINDEX(N',', @UserNames,  @Pos)
		IF (@NextPos = 0 OR @NextPos IS NULL)
			SELECT @NextPos = LEN(@UserNames) + 1
		SELECT @Name = RTRIM(LTRIM(SUBSTRING(@UserNames, @Pos, @NextPos - @Pos)))
		SELECT @Pos = @NextPos+1

		INSERT INTO @tbNames VALUES (@Name)
		SET @Num = @Num + 1
	END

	INSERT INTO @tbUsers
	  SELECT UserId
	  FROM   dbo.aspnet_Users ar, @tbNames t
	  WHERE  LOWER(t.Name) = ar.LoweredUserName AND ar.ApplicationId = @AppId

	IF (@@ROWCOUNT <> @Num)
	BEGIN
		DELETE FROM @tbNames
		WHERE LOWER(Name) IN (SELECT LoweredUserName FROM dbo.aspnet_Users au,  @tbUsers u WHERE au.UserId = u.UserId)

		INSERT dbo.aspnet_Users (ApplicationId, UserId, UserName, LoweredUserName, IsAnonymous, LastActivityDate)
		  SELECT @AppId, NEWID(), Name, LOWER(Name), 0, @CurrentTimeUtc
		  FROM   @tbNames

		INSERT INTO @tbUsers
		  SELECT  UserId
		  FROM	dbo.aspnet_Users au, @tbNames t
		  WHERE   LOWER(t.Name) = au.LoweredUserName AND au.ApplicationId = @AppId
	END

	IF (EXISTS (SELECT * FROM dbo.aspnet_UsersInRoles ur, @tbUsers tu, @tbRoles tr WHERE tu.UserId = ur.UserId AND tr.RoleId = ur.RoleId))
	BEGIN
		SELECT TOP 1 UserName, RoleName
		FROM		 dbo.aspnet_UsersInRoles ur, @tbUsers tu, @tbRoles tr, aspnet_Users u, aspnet_Roles r
		WHERE		u.UserId = tu.UserId AND r.RoleId = tr.RoleId AND tu.UserId = ur.UserId AND tr.RoleId = ur.RoleId

		IF( @TranStarted = 1 )
			ROLLBACK TRANSACTION
		RETURN(3)
	END

	INSERT INTO dbo.aspnet_UsersInRoles (UserId, RoleId)
	SELECT UserId, RoleId
	FROM @tbUsers, @tbRoles

	IF( @TranStarted = 1 )
		COMMIT TRANSACTION
	RETURN(0)
END                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
GO
/****** Object:  StoredProcedure [dbo].[aspnet_UsersInRoles_FindUsersInRole]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_UsersInRoles_FindUsersInRole]
    @ApplicationName  nvarchar(256),
    @RoleName         nvarchar(256),
    @UserNameToMatch  nvarchar(256)
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN(1)
     DECLARE @RoleId uniqueidentifier
     SELECT  @RoleId = NULL

     SELECT  @RoleId = RoleId
     FROM    dbo.aspnet_Roles
     WHERE   LOWER(@RoleName) = LoweredRoleName AND ApplicationId = @ApplicationId

     IF (@RoleId IS NULL)
         RETURN(1)

    SELECT u.UserName
    FROM   dbo.aspnet_Users u, dbo.aspnet_UsersInRoles ur
    WHERE  u.UserId = ur.UserId AND @RoleId = ur.RoleId AND u.ApplicationId = @ApplicationId AND LoweredUserName LIKE LOWER(@UserNameToMatch)
    ORDER BY u.UserName
    RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_UsersInRoles_GetRolesForUser]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_UsersInRoles_GetRolesForUser]
    @ApplicationName  nvarchar(256),
    @UserName         nvarchar(256)
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN(1)
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL

    SELECT  @UserId = UserId
    FROM    dbo.aspnet_Users
    WHERE   LoweredUserName = LOWER(@UserName) AND ApplicationId = @ApplicationId

    IF (@UserId IS NULL)
        RETURN(1)

    SELECT r.RoleName
    FROM   dbo.aspnet_Roles r, dbo.aspnet_UsersInRoles ur
    WHERE  r.RoleId = ur.RoleId AND r.ApplicationId = @ApplicationId AND ur.UserId = @UserId
    ORDER BY r.RoleName
    RETURN (0)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_UsersInRoles_GetUsersInRoles]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_UsersInRoles_GetUsersInRoles]
    @ApplicationName  nvarchar(256),
    @RoleName         nvarchar(256)
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN(1)
     DECLARE @RoleId uniqueidentifier
     SELECT  @RoleId = NULL

     SELECT  @RoleId = RoleId
     FROM    dbo.aspnet_Roles
     WHERE   LOWER(@RoleName) = LoweredRoleName AND ApplicationId = @ApplicationId

     IF (@RoleId IS NULL)
         RETURN(1)

    SELECT u.UserName
    FROM   dbo.aspnet_Users u, dbo.aspnet_UsersInRoles ur
    WHERE  u.UserId = ur.UserId AND @RoleId = ur.RoleId AND u.ApplicationId = @ApplicationId
    ORDER BY u.UserName
    RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_UsersInRoles_IsUserInRole]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_UsersInRoles_IsUserInRole]
    @ApplicationName  nvarchar(256),
    @UserName         nvarchar(256),
    @RoleName         nvarchar(256)
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN(2)
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL
    DECLARE @RoleId uniqueidentifier
    SELECT  @RoleId = NULL

    SELECT  @UserId = UserId
    FROM    dbo.aspnet_Users
    WHERE   LoweredUserName = LOWER(@UserName) AND ApplicationId = @ApplicationId

    IF (@UserId IS NULL)
        RETURN(2)

    SELECT  @RoleId = RoleId
    FROM    dbo.aspnet_Roles
    WHERE   LoweredRoleName = LOWER(@RoleName) AND ApplicationId = @ApplicationId

    IF (@RoleId IS NULL)
        RETURN(3)

    IF (EXISTS( SELECT * FROM dbo.aspnet_UsersInRoles WHERE  UserId = @UserId AND RoleId = @RoleId))
        RETURN(1)
    ELSE
        RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[aspnet_UsersInRoles_RemoveUsersFromRoles]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[aspnet_UsersInRoles_RemoveUsersFromRoles]
	@ApplicationName  nvarchar(256),
	@UserNames		  nvarchar(4000),
	@RoleNames		  nvarchar(4000)
AS
BEGIN
	DECLARE @AppId uniqueidentifier
	SELECT  @AppId = NULL
	SELECT  @AppId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
	IF (@AppId IS NULL)
		RETURN(2)


	DECLARE @TranStarted   bit
	SET @TranStarted = 0

	IF( @@TRANCOUNT = 0 )
	BEGIN
		BEGIN TRANSACTION
		SET @TranStarted = 1
	END

	DECLARE @tbNames  table(Name nvarchar(256) NOT NULL PRIMARY KEY)
	DECLARE @tbRoles  table(RoleId uniqueidentifier NOT NULL PRIMARY KEY)
	DECLARE @tbUsers  table(UserId uniqueidentifier NOT NULL PRIMARY KEY)
	DECLARE @Num	  int
	DECLARE @Pos	  int
	DECLARE @NextPos  int
	DECLARE @Name	  nvarchar(256)
	DECLARE @CountAll int
	DECLARE @CountU	  int
	DECLARE @CountR	  int


	SET @Num = 0
	SET @Pos = 1
	WHILE(@Pos <= LEN(@RoleNames))
	BEGIN
		SELECT @NextPos = CHARINDEX(N',', @RoleNames,  @Pos)
		IF (@NextPos = 0 OR @NextPos IS NULL)
			SELECT @NextPos = LEN(@RoleNames) + 1
		SELECT @Name = RTRIM(LTRIM(SUBSTRING(@RoleNames, @Pos, @NextPos - @Pos)))
		SELECT @Pos = @NextPos+1

		INSERT INTO @tbNames VALUES (@Name)
		SET @Num = @Num + 1
	END

	INSERT INTO @tbRoles
	  SELECT RoleId
	  FROM   dbo.aspnet_Roles ar, @tbNames t
	  WHERE  LOWER(t.Name) = ar.LoweredRoleName AND ar.ApplicationId = @AppId
	SELECT @CountR = @@ROWCOUNT

	IF (@CountR <> @Num)
	BEGIN
		SELECT TOP 1 N'', Name
		FROM   @tbNames
		WHERE  LOWER(Name) NOT IN (SELECT ar.LoweredRoleName FROM dbo.aspnet_Roles ar,  @tbRoles r WHERE r.RoleId = ar.RoleId)
		IF( @TranStarted = 1 )
			ROLLBACK TRANSACTION
		RETURN(2)
	END


	DELETE FROM @tbNames WHERE 1=1
	SET @Num = 0
	SET @Pos = 1


	WHILE(@Pos <= LEN(@UserNames))
	BEGIN
		SELECT @NextPos = CHARINDEX(N',', @UserNames,  @Pos)
		IF (@NextPos = 0 OR @NextPos IS NULL)
			SELECT @NextPos = LEN(@UserNames) + 1
		SELECT @Name = RTRIM(LTRIM(SUBSTRING(@UserNames, @Pos, @NextPos - @Pos)))
		SELECT @Pos = @NextPos+1

		INSERT INTO @tbNames VALUES (@Name)
		SET @Num = @Num + 1
	END

	INSERT INTO @tbUsers
	  SELECT UserId
	  FROM   dbo.aspnet_Users ar, @tbNames t
	  WHERE  LOWER(t.Name) = ar.LoweredUserName AND ar.ApplicationId = @AppId

	SELECT @CountU = @@ROWCOUNT
	IF (@CountU <> @Num)
	BEGIN
		SELECT TOP 1 Name, N''
		FROM   @tbNames
		WHERE  LOWER(Name) NOT IN (SELECT au.LoweredUserName FROM dbo.aspnet_Users au,  @tbUsers u WHERE u.UserId = au.UserId)

		IF( @TranStarted = 1 )
			ROLLBACK TRANSACTION
		RETURN(1)
	END

	SELECT  @CountAll = COUNT(*)
	FROM	dbo.aspnet_UsersInRoles ur, @tbUsers u, @tbRoles r
	WHERE   ur.UserId = u.UserId AND ur.RoleId = r.RoleId

	IF (@CountAll <> @CountU * @CountR)
	BEGIN
		SELECT TOP 1 UserName, RoleName
		FROM		 @tbUsers tu, @tbRoles tr, dbo.aspnet_Users u, dbo.aspnet_Roles r
		WHERE		 u.UserId = tu.UserId AND r.RoleId = tr.RoleId AND
					 tu.UserId NOT IN (SELECT ur.UserId FROM dbo.aspnet_UsersInRoles ur WHERE ur.RoleId = tr.RoleId) AND
					 tr.RoleId NOT IN (SELECT ur.RoleId FROM dbo.aspnet_UsersInRoles ur WHERE ur.UserId = tu.UserId)
		IF( @TranStarted = 1 )
			ROLLBACK TRANSACTION
		RETURN(3)
	END

	DELETE FROM dbo.aspnet_UsersInRoles
	WHERE UserId IN (SELECT UserId FROM @tbUsers)
	  AND RoleId IN (SELECT RoleId FROM @tbRoles)
	IF( @TranStarted = 1 )
		COMMIT TRANSACTION
	RETURN(0)
END
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
GO
/****** Object:  StoredProcedure [dbo].[aspnet_WebEvent_LogEvent]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[aspnet_WebEvent_LogEvent]
        @EventId         char(32),
        @EventTimeUtc    datetime,
        @EventTime       datetime,
        @EventType       nvarchar(256),
        @EventSequence   decimal(19,0),
        @EventOccurrence decimal(19,0),
        @EventCode       int,
        @EventDetailCode int,
        @Message         nvarchar(1024),
        @ApplicationPath nvarchar(256),
        @ApplicationVirtualPath nvarchar(256),
        @MachineName    nvarchar(256),
        @RequestUrl      nvarchar(1024),
        @ExceptionType   nvarchar(256),
        @Details         ntext
AS
BEGIN
    INSERT
        dbo.aspnet_WebEvent_Events
        (
            EventId,
            EventTimeUtc,
            EventTime,
            EventType,
            EventSequence,
            EventOccurrence,
            EventCode,
            EventDetailCode,
            Message,
            ApplicationPath,
            ApplicationVirtualPath,
            MachineName,
            RequestUrl,
            ExceptionType,
            Details
        )
    VALUES
    (
        @EventId,
        @EventTimeUtc,
        @EventTime,
        @EventType,
        @EventSequence,
        @EventOccurrence,
        @EventCode,
        @EventDetailCode,
        @Message,
        @ApplicationPath,
        @ApplicationVirtualPath,
        @MachineName,
        @RequestUrl,
        @ExceptionType,
        @Details
    )
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GenerateInserts]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROC [dbo].[usp_GenerateInserts]
(
	@table_name varchar(776),  		-- The table/view for which the INSERT statements will be generated using the existing data
	@target_table varchar(776) = NULL, 	-- Use this parameter to specify a different table name into which the data will be inserted
	@include_column_list bit = 1,		-- Use this parameter to include/ommit column list in the generated INSERT statement
	@from varchar(800) = NULL, 		-- Use this parameter to filter the rows based on a filter condition (using WHERE)
	@include_timestamp bit = 0, 		-- Specify 1 for this parameter, if you want to include the TIMESTAMP/ROWVERSION column's data in the INSERT statement
	@debug_mode bit = 0,			-- If @debug_mode is set to 1, the SQL statements constructed by this procedure will be printed for later examination
	@owner varchar(64) = NULL,		-- Use this parameter if you are not the owner of the table
	@ommit_images bit = 0,			-- Use this parameter to generate INSERT statements by omitting the 'image' columns
	@ommit_identity bit = 0,		-- Use this parameter to ommit the identity columns
	@top int = NULL,			-- Use this parameter to generate INSERT statements only for the TOP n rows
	@cols_to_include varchar(8000) = NULL,	-- List of columns to be included in the INSERT statement
	@cols_to_exclude varchar(8000) = NULL,	-- List of columns to be excluded from the INSERT statement
	@disable_constraints bit = 0,		-- When 1, disables foreign key constraints and enables them after the INSERT statements
	@ommit_computed_cols bit = 0		-- When 1, computed columns will not be included in the INSERT statement
	
)
-- ENCRYPT_ME
AS
BEGIN

/***********************************************************************************************************
Procedure:	sp_generate_inserts  (Build 22) 
		(Copyright © 2002 Narayana Vyas Kondreddi. All rights reserved.)
                                          
Purpose:To generate INSERT statements from existing data. 
		These INSERTS can be executed to regenerate the data at some other location.
		This procedure is also useful to create a database setup, where in you can 
		script your data along with your table definitions.

Written by:	Narayana Vyas Kondreddi
	        http://vyaskn.tripod.com

Acknowledgements:
		Divya Kalra	-- For beta testing
		Mark Charsley	-- For reporting a problem with scripting uniqueidentifier columns with NULL values
		Artur Zeygman	-- For helping me simplify a bit of code for handling non-dbo owned tables
		Joris Laperre   -- For reporting a regression bug in handling text/ntext columns

Tested on: 	SQL Server 7.0 and SQL Server 2000

Date created:	January 17th 2001 21:52 GMT

Date modified:	May 1st 2002 19:50 GMT

Email: 		vyaskn@hotmail.com

NOTE:		This procedure may not work with tables with too many columns.
		Results can be unpredictable with huge text columns or SQL Server 2000's sql_variant data types
		Whenever possible, Use @include_column_list parameter to ommit column list in the INSERT statement, for better results
		IMPORTANT: This procedure is not tested with internation data (Extended characters or Unicode). If needed
		you might want to convert the datatypes of character variables in this procedure to their respective unicode counterparts
		like nchar and nvarchar
		

Example 1:	To generate INSERT statements for table 'titles':
		
		EXEC sp_generate_inserts 'titles'

Example 2: 	To ommit the column list in the INSERT statement: (Column list is included by default)
		IMPORTANT: If you have too many columns, you are advised to ommit column list, as shown below,
		to avoid erroneous results
		
		EXEC sp_generate_inserts 'titles', @include_column_list = 0

Example 3:	To generate INSERT statements for 'titlesCopy' table from 'titles' table:

		EXEC sp_generate_inserts 'titles', 'titlesCopy'

Example 4:	To generate INSERT statements for 'titles' table for only those titles 
		which contain the word 'Computer' in them:
		NOTE: Do not complicate the FROM or WHERE clause here. It's assumed that you are good with T-SQL if you are using this parameter

		EXEC sp_generate_inserts 'titles', @from = "from titles where title like '%Computer%'"

Example 5: 	To specify that you want to include TIMESTAMP column's data as well in the INSERT statement:
		(By default TIMESTAMP column's data is not scripted)

		EXEC sp_generate_inserts 'titles', @include_timestamp = 1

Example 6:	To print the debug information:
  
		EXEC sp_generate_inserts 'titles', @debug_mode = 1

Example 7: 	If you are not the owner of the table, use @owner parameter to specify the owner name
		To use this option, you must have SELECT permissions on that table

		EXEC sp_generate_inserts Nickstable, @owner = 'Nick'

Example 8: 	To generate INSERT statements for the rest of the columns excluding images
		When using this otion, DO NOT set @include_column_list parameter to 0.

		EXEC sp_generate_inserts imgtable, @ommit_images = 1

Example 9: 	To generate INSERT statements excluding (ommiting) IDENTITY columns:
		(By default IDENTITY columns are included in the INSERT statement)

		EXEC sp_generate_inserts mytable, @ommit_identity = 1

Example 10: 	To generate INSERT statements for the TOP 10 rows in the table:
		
		EXEC sp_generate_inserts mytable, @top = 10

Example 11: 	To generate INSERT statements with only those columns you want:
		
		EXEC sp_generate_inserts titles, @cols_to_include = "'title','title_id','au_id'"

Example 12: 	To generate INSERT statements by omitting certain columns:
		
		EXEC sp_generate_inserts titles, @cols_to_exclude = "'title','title_id','au_id'"

Example 13:	To avoid checking the foreign key constraints while loading data with INSERT statements:
		
		EXEC sp_generate_inserts titles, @disable_constraints = 1

Example 14: 	To exclude computed columns from the INSERT statement:
		EXEC sp_generate_inserts MyTable, @ommit_computed_cols = 1
***********************************************************************************************************/

SET NOCOUNT ON

--Making sure user only uses either @cols_to_include or @cols_to_exclude
IF ((@cols_to_include IS NOT NULL) AND (@cols_to_exclude IS NOT NULL))
	BEGIN
		RAISERROR('Use either @cols_to_include or @cols_to_exclude. Do not use both the parameters at once',16,1)
		RETURN -1 --Failure. Reason: Both @cols_to_include and @cols_to_exclude parameters are specified
	END

--Making sure the @cols_to_include and @cols_to_exclude parameters are receiving values in proper format
IF ((@cols_to_include IS NOT NULL) AND (PATINDEX('''%''',@cols_to_include) = 0))
	BEGIN
		RAISERROR('Invalid use of @cols_to_include property',16,1)
		PRINT 'Specify column names surrounded by single quotes and separated by commas'
		PRINT 'Eg: EXEC sp_generate_inserts titles, @cols_to_include = "''title_id'',''title''"'
		RETURN -1 --Failure. Reason: Invalid use of @cols_to_include property
	END

IF ((@cols_to_exclude IS NOT NULL) AND (PATINDEX('''%''',@cols_to_exclude) = 0))
	BEGIN
		RAISERROR('Invalid use of @cols_to_exclude property',16,1)
		PRINT 'Specify column names surrounded by single quotes and separated by commas'
		PRINT 'Eg: EXEC sp_generate_inserts titles, @cols_to_exclude = "''title_id'',''title''"'
		RETURN -1 --Failure. Reason: Invalid use of @cols_to_exclude property
	END


--Checking to see if the database name is specified along wih the table name
--Your database context should be local to the table for which you want to generate INSERT statements
--specifying the database name is not allowed
IF (PARSENAME(@table_name,3)) IS NOT NULL
	BEGIN
		RAISERROR('Do not specify the database name. Be in the required database and just specify the table name.',16,1)
		RETURN -1 --Failure. Reason: Database name is specified along with the table name, which is not allowed
	END

--Checking for the existence of 'user table' or 'view'
--This procedure is not written to work on system tables
--To script the data in system tables, just create a view on the system tables and script the view instead

IF @owner IS NULL
	BEGIN
		IF ((OBJECT_ID(@table_name,'U') IS NULL) AND (OBJECT_ID(@table_name,'V') IS NULL)) 
			BEGIN
				RAISERROR('User table or view not found.',16,1)
				PRINT 'You may see this error, if you are not the owner of this table or view. In that case use @owner parameter to specify the owner name.'
				PRINT 'Make sure you have SELECT permission on that table or view.'
				RETURN -1 --Failure. Reason: There is no user table or view with this name
			END
	END
ELSE
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @table_name AND (TABLE_TYPE = 'BASE TABLE' OR TABLE_TYPE = 'VIEW') AND TABLE_SCHEMA = @owner)
			BEGIN
				RAISERROR('User table or view not found.',16,1)
				PRINT 'You may see this error, if you are not the owner of this table. In that case use @owner parameter to specify the owner name.'
				PRINT 'Make sure you have SELECT permission on that table or view.'
				RETURN -1 --Failure. Reason: There is no user table or view with this name		
			END
	END

--Variable declarations
DECLARE		@Column_ID int, 		
		@Column_List varchar(8000), 
		@Column_Name varchar(128), 
		@Start_Insert varchar(786), 
		@Data_Type varchar(128), 
		@Actual_Values varchar(8000),	--This is the string that will be finally executed to generate INSERT statements
		@IDN varchar(128)		--Will contain the IDENTITY column's name in the table

--Variable Initialization
SET @IDN = ''
SET @Column_ID = 0
SET @Column_Name = ''
SET @Column_List = ''
SET @Actual_Values = ''

IF @owner IS NULL 
	BEGIN
		SET @Start_Insert = 'INSERT INTO ' + '[' + RTRIM(COALESCE(@target_table,@table_name)) + ']' 
	END
ELSE
	BEGIN
		SET @Start_Insert = 'INSERT ' + '[' + LTRIM(RTRIM(@owner)) + '].' + '[' + RTRIM(COALESCE(@target_table,@table_name)) + ']' 		
	END


--To get the first column's ID

SELECT	@Column_ID = MIN(ORDINAL_POSITION) 	
FROM	INFORMATION_SCHEMA.COLUMNS (NOLOCK) 
WHERE 	TABLE_NAME = @table_name AND
(@owner IS NULL OR TABLE_SCHEMA = @owner)



--Loop through all the columns of the table, to get the column names and their data types
WHILE @Column_ID IS NOT NULL
	BEGIN
		SELECT 	@Column_Name = QUOTENAME(COLUMN_NAME), 
		@Data_Type = DATA_TYPE 
		FROM 	INFORMATION_SCHEMA.COLUMNS (NOLOCK) 
		WHERE 	ORDINAL_POSITION = @Column_ID AND 
		TABLE_NAME = @table_name AND
		(@owner IS NULL OR TABLE_SCHEMA = @owner)



		IF @cols_to_include IS NOT NULL --Selecting only user specified columns
		BEGIN
			IF CHARINDEX( '''' + SUBSTRING(@Column_Name,2,LEN(@Column_Name)-2) + '''',@cols_to_include) = 0 
			BEGIN
				GOTO SKIP_LOOP
			END
		END

		IF @cols_to_exclude IS NOT NULL --Selecting only user specified columns
		BEGIN
			IF CHARINDEX( '''' + SUBSTRING(@Column_Name,2,LEN(@Column_Name)-2) + '''',@cols_to_exclude) <> 0 
			BEGIN
				GOTO SKIP_LOOP
			END
		END

		--Making sure to output SET IDENTITY_INSERT ON/OFF in case the table has an IDENTITY column
		IF (SELECT COLUMNPROPERTY( OBJECT_ID(QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + @table_name),SUBSTRING(@Column_Name,2,LEN(@Column_Name) - 2),'IsIdentity')) = 1 
		BEGIN
			IF @ommit_identity = 0 --Determing whether to include or exclude the IDENTITY column
				SET @IDN = @Column_Name
			ELSE
				GOTO SKIP_LOOP			
		END
		
		--Making sure whether to output computed columns or not
		IF @ommit_computed_cols = 1
		BEGIN
			IF (SELECT COLUMNPROPERTY( OBJECT_ID(QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + @table_name),SUBSTRING(@Column_Name,2,LEN(@Column_Name) - 2),'IsComputed')) = 1 
			BEGIN
				GOTO SKIP_LOOP					
			END
		END
		
		--Tables with columns of IMAGE data type are not supported for obvious reasons
		IF(@Data_Type in ('image'))
			BEGIN
				IF (@ommit_images = 0)
					BEGIN
						RAISERROR('Tables with image columns are not supported.',16,1)
						PRINT 'Use @ommit_images = 1 parameter to generate INSERTs for the rest of the columns.'
						PRINT 'DO NOT ommit Column List in the INSERT statements. If you ommit column list using @include_column_list=0, the generated INSERTs will fail.'
						RETURN -1 --Failure. Reason: There is a column with image data type
					END
				ELSE
					BEGIN
					GOTO SKIP_LOOP
					END
			END

		--Determining the data type of the column and depending on the data type, the VALUES part of
		--the INSERT statement is generated. Care is taken to handle columns with NULL values. Also
		--making sure, not to lose any data from flot, real, money, smallmomey, datetime columns
		SET @Actual_Values = @Actual_Values  +
		CASE 
			WHEN @Data_Type IN ('char','varchar','nchar','nvarchar') 
				THEN 
					'COALESCE('''''''' + REPLACE(RTRIM(' + @Column_Name + '),'''''''','''''''''''')+'''''''',''NULL'')'
			WHEN @Data_Type IN ('datetime','smalldatetime') 
				THEN 
					'COALESCE('''''''' + RTRIM(CONVERT(char,' + @Column_Name + ',109))+'''''''',''NULL'')'
			WHEN @Data_Type IN ('uniqueidentifier') 
				THEN  
					'COALESCE('''''''' + REPLACE(CONVERT(char(255),RTRIM(' + @Column_Name + ')),'''''''','''''''''''')+'''''''',''NULL'')'
			WHEN @Data_Type IN ('text','ntext') 
				THEN  
					'COALESCE('''''''' + REPLACE(CONVERT(char(8000),' + @Column_Name + '),'''''''','''''''''''')+'''''''',''NULL'')'					
			WHEN @Data_Type IN ('binary','varbinary') 
				THEN  
					'COALESCE(RTRIM(CONVERT(char,' + 'CONVERT(int,' + @Column_Name + '))),''NULL'')'  
			WHEN @Data_Type IN ('timestamp','rowversion') 
				THEN  
					CASE 
						WHEN @include_timestamp = 0 
							THEN 
								'''DEFAULT''' 
							ELSE 
								'COALESCE(RTRIM(CONVERT(char,' + 'CONVERT(int,' + @Column_Name + '))),''NULL'')'  
					END
			WHEN @Data_Type IN ('float','real','money','smallmoney')
				THEN
					'COALESCE(LTRIM(RTRIM(' + 'CONVERT(char, ' +  @Column_Name  + ',2)' + ')),''NULL'')' 
			ELSE 
				'COALESCE(LTRIM(RTRIM(' + 'CONVERT(char, ' +  @Column_Name  + ')' + ')),''NULL'')' 
		END   + '+' +  ''',''' + ' + '
		
		--Generating the column list for the INSERT statement
		SET @Column_List = @Column_List +  @Column_Name + ','	

		SKIP_LOOP: --The label used in GOTO

		SELECT 	@Column_ID = MIN(ORDINAL_POSITION) 
		FROM 	INFORMATION_SCHEMA.COLUMNS (NOLOCK) 
		WHERE 	TABLE_NAME = @table_name AND 
		ORDINAL_POSITION > @Column_ID AND
		(@owner IS NULL OR TABLE_SCHEMA = @owner)


	--Loop ends here!
	END

--To get rid of the extra characters that got concatenated during the last run through the loop
SET @Column_List = LEFT(@Column_List,len(@Column_List) - 1)
SET @Actual_Values = LEFT(@Actual_Values,len(@Actual_Values) - 6)

IF LTRIM(@Column_List) = '' 
	BEGIN
		RAISERROR('No columns to select. There should at least be one column to generate the output',16,1)
		RETURN -1 --Failure. Reason: Looks like all the columns are ommitted using the @cols_to_exclude parameter
	END

--Forming the final string that will be executed, to output the INSERT statements
IF (@include_column_list <> 0)
	BEGIN
		SET @Actual_Values = 
			'SELECT ' +  
			CASE WHEN @top IS NULL OR @top < 0 THEN '' ELSE ' TOP ' + LTRIM(STR(@top)) + ' ' END + 
			'''' + RTRIM(@Start_Insert) + 
			' ''+' + '''(' + RTRIM(@Column_List) +  '''+' + ''')''' + 
			' +''VALUES(''+ ' +  @Actual_Values  + '+'')''' + ' ' + 
			COALESCE(@from,' FROM ' + CASE WHEN @owner IS NULL THEN '' ELSE '[' + LTRIM(RTRIM(@owner)) + '].' END + '[' + rtrim(@table_name) + ']' + '(NOLOCK)')
	END
ELSE IF (@include_column_list = 0)
	BEGIN
		SET @Actual_Values = 
			'SELECT ' + 
			CASE WHEN @top IS NULL OR @top < 0 THEN '' ELSE ' TOP ' + LTRIM(STR(@top)) + ' ' END + 
			'''' + RTRIM(@Start_Insert) + 
			' '' +''VALUES(''+ ' +  @Actual_Values + '+'')''' + ' ' + 
			COALESCE(@from,' FROM ' + CASE WHEN @owner IS NULL THEN '' ELSE '[' + LTRIM(RTRIM(@owner)) + '].' END + '[' + rtrim(@table_name) + ']' + '(NOLOCK)')
	END	

--Determining whether to ouput any debug information
IF @debug_mode =1
	BEGIN
		PRINT '/*****START OF DEBUG INFORMATION*****'
		PRINT 'Beginning of the INSERT statement:'
		PRINT @Start_Insert
		PRINT ''
		PRINT 'The column list:'
		PRINT @Column_List
		PRINT ''
		PRINT 'The SELECT statement executed to generate the INSERTs'
		PRINT @Actual_Values
		PRINT ''
		PRINT '*****END OF DEBUG INFORMATION*****/'
		PRINT ''
	END
		
PRINT '--INSERTs generated by ''sp_generate_inserts'' stored procedure written by Vyas'
PRINT '--Build number: 22'
PRINT '--Problems/Suggestions? Contact Vyas @ vyaskn@hotmail.com'
PRINT '--http://vyaskn.tripod.com'
PRINT ''
PRINT 'SET NOCOUNT ON'
PRINT ''


--Determining whether to print IDENTITY_INSERT or not
IF (@IDN <> '')
	BEGIN
		PRINT 'SET IDENTITY_INSERT ' + QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + QUOTENAME(@table_name) + ' ON'
		PRINT 'GO'
		PRINT ''
	END


IF @disable_constraints = 1 AND (OBJECT_ID(QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + @table_name, 'U') IS NOT NULL)
	BEGIN
		IF @owner IS NULL
			BEGIN
				SELECT 	'ALTER TABLE ' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' NOCHECK CONSTRAINT ALL' AS '--Code to disable constraints temporarily'
			END
		ELSE
			BEGIN
				SELECT 	'ALTER TABLE ' + QUOTENAME(@owner) + '.' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' NOCHECK CONSTRAINT ALL' AS '--Code to disable constraints temporarily'
			END

		PRINT 'GO'
	END

PRINT ''
PRINT 'PRINT ''Inserting values into ' + '[' + RTRIM(COALESCE(@target_table,@table_name)) + ']' + ''''


--All the hard work pays off here!!! You'll get your INSERT statements, when the next line executes!
EXEC (@Actual_Values)

PRINT 'PRINT ''Done'''
PRINT ''


IF @disable_constraints = 1 AND (OBJECT_ID(QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + @table_name, 'U') IS NOT NULL)
	BEGIN
		IF @owner IS NULL
			BEGIN
				SELECT 	'ALTER TABLE ' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' CHECK CONSTRAINT ALL'  AS '--Code to enable the previously disabled constraints'
			END
		ELSE
			BEGIN
				SELECT 	'ALTER TABLE ' + QUOTENAME(@owner) + '.' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' CHECK CONSTRAINT ALL' AS '--Code to enable the previously disabled constraints'
			END

		PRINT 'GO'
	END

PRINT ''
IF (@IDN <> '')
	BEGIN
		PRINT 'SET IDENTITY_INSERT ' + QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + QUOTENAME(@table_name) + ' OFF'
		PRINT 'GO'
	END

PRINT 'SET NOCOUNT OFF'


SET NOCOUNT OFF
RETURN 0 --Success. We are done!
END



GO
/****** Object:  StoredProcedure [dbo].[usp_GetVersionMajor]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[usp_GetVersionMajor] 
		@smiMajor smallint OUTPUT
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_DatabaseInfo]') 
		AND type in (N'U')) 
	BEGIN
		IF EXISTS(SELECT [majorversion] FROM [dbo].[tbl_DatabaseInfo])
		BEGIN
			SELECT TOP 1 @smiMajor = [majorversion] 
				FROM [dbo].[tbl_DatabaseInfo] ORDER BY [majorversion] DESC
		END
		ELSE
		BEGIN
			select @smiMajor = 0
		END
	END
	ELSE
	BEGIN
		select @smiMajor = 0
	END
END





GO
/****** Object:  StoredProcedure [dbo].[usp_GetVersionMinor]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =====================================================================================

CREATE PROCEDURE [dbo].[usp_GetVersionMinor] 
		@smiMinor smallint OUTPUT
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_DatabaseInfo]') 
		AND type in (N'U')) 
	BEGIN
		IF EXISTS(SELECT [minorversion] FROM [dbo].[tbl_DatabaseInfo])
		BEGIN
			SELECT TOP 1 @smiMinor = [minorversion] 
				FROM [dbo].[tbl_DatabaseInfo] ORDER BY [majorversion] DESC, [minorversion] DESC
		END
		ELSE
		BEGIN
			select @smiMinor = 0
		END
	END
	ELSE
	BEGIN
		select @smiMinor = 0
	END
END





GO
/****** Object:  StoredProcedure [dbo].[usp_GetVersionRelease]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_GetVersionRelease] 
		@smiRelease smallint OUTPUT
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[databaseinfo]') 
		AND type in (N'U')) 
	BEGIN
		IF EXISTS(SELECT [releaseversion] FROM [dbo].[tbl_DatabaseInfo])
		BEGIN
			SELECT TOP 1 @smiRelease = [releaseversion]
				FROM [dbo].[tbl_DatabaseInfo] ORDER BY [majorversion] DESC, [minorversion] DESC, [releaseversion] DESC
		END
		ELSE
		BEGIN
			select @smiRelease = 0
		END
	END
	ELSE
	BEGIN
		select @smiRelease = 0
	END
END

/****** Object:  Table [dbo].[tbl_GridColumn]    Script Date: 08/26/2013 11:58:01 ******/
SET ANSI_NULLS ON


GO
/****** Object:  StoredProcedure [dbo].[usp_LANG_GetLanguageList]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[usp_LANG_GetLanguageList]
AS
BEGIN
	SELECT	[languageId]
		   ,[languageName]
	FROM	[dbo].[tbl_Language]
END


GO
/****** Object:  StoredProcedure [dbo].[usp_LANG_GetLanguageNameById]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


-- =============================================
-- Author:		Fernando Alarcón
-- Create date: 10/09/2013
-- Description:	Get a language Name by id.
-- =============================================
CREATE PROCEDURE [dbo].[usp_LANG_GetLanguageNameById]
		@languageNameId VARCHAR(10),
		@language VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;

	IF(@languageNameId IS NULL)
		SELECT @languageNameId = ''
			
	SET @language = UPPER(@language)
			
	SELECT	TOP 1	[T].[languageName]
	FROM			[dbo].[tbl_Language] AS [L]
	INNER JOIN		[dbo].[tbl_Language_Translations] AS [T] 
		ON			[T].[languageID] = [L].[languageID]
	WHERE			[T].[languageID] = CASE @languageNameId WHEN '' THEN [L].[languageID] ELSE @languageNameId END
	AND				[t].[language] = @language
END

GO
/****** Object:  StoredProcedure [dbo].[usp_ORG_DeleteOrganization]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Delete an organization, an all of the related objects
--				
-- =============================================
CREATE PROCEDURE [dbo].[usp_ORG_DeleteOrganization]
	@organizationID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- We detect if the SP was called from an active transation and 
	-- we save it to use it later.  In the SP, @TranCounter = 0
	-- means that there are no active transations and that this SP
	-- started one. @TranCounter > 0 means that a transation was started
	-- before we started this SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0
		-- We called this SP when an active transaction already exists.
		-- We create a savepoint to be able to only roll back this 
		-- transaction if there is some error.
		-- ===============================================
		---  MAKE SURE THAT THIS NAME IS COPIED BELOW 
		---  AND IS UNIQUE IN THE SYSTEM!!!!!!
		-- ===============================================
		SAVE TRANSACTION DeleteOrganization;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		-- We basically have to delete everything related to that organization.
		
		-- Start with KPIs. 
		-- Get the IDs of all the KPIs we will delete
		DECLARE @KPITable as TABLE (kpiID int)
		INSERT INTO @KPITable
		SELECT [kpiID] from [dbo].[tbl_KPI]
		where [organizationID] = @organizationID

		-- Delete all measurements for the KPIs selected

		-- Delete all permissions for the KPIs selected
		DELETE FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and [objectID] in (select kpiID from @KPITable)

		-- Delete the KPIs selected
		-- Now lets delete all people for the organization
		-- Get the IDs of all the people we will delete
		-- Delete all the permissios for these persons
		-- Delete the people

		-- Now lets delete all activities for the organization
		-- Get the IDs of all the activities we will delete
		-- Delete all the permissios for these activities
		-- Delete the activities

		-- Now lets delete all projects for the organization
		-- Get the IDs of all the projects we will delete
		-- Delete all the projects for these activities
		-- Delete the projects

		-- Now lets delete all areas for the organization

		-- Now lets delete the permissions for the organization

		-- And finally lets delete the organization

		-- =============================================================
		-- INSERT THE SQL STATEMENTS HERE
		-- =============================================================

		-- We arrived here without errors; we should commit the transation we started
		-- but we should not commit if there was a previous transaction started
		IF @TranCounter = 0
			-- @TranCounter = 0 means that no other transaction was started before this transaction 
			-- and that we shouold hence commit this transaction
			COMMIT TRANSACTION;
		
	END TRY
	BEGIN CATCH

		-- There was an error.  We need to determine what type of rollback we must perform

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		IF @TranCounter = 0
			-- We have only the transaction that we started in this SP.  Rollback
			-- all the tranaction.
			ROLLBACK TRANSACTION;
		ELSE
			-- A transaction was started before this SP was called.  We must
			-- rollback only the changes we made in this SP.

			-- We see XACT_STATE and the possible results are 0, 1, or -1.
			-- If it is 1, the transaction is valid and we can do a commit. But since we are in the 
			-- CATCH we don't do the commit. We need to rollback to the savepoint
			-- If it is -1 the transaction is not valid and we must do a full rollback... we can't
			-- do a rollback to a savepoint
			-- XACT_STATE = 0 means that there is no transaciton and a rollback would cause an error
			-- See http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() = 1
				-- If the transaction is still valid then we rollback to the restore point defined before
				-- ===============================================
				---  MAKE SURE THAT THIS NAME IS EXACTLY AS ABOVE 
				-- ===============================================
				ROLLBACK TRANSACTION DeleteOrganization;

				-- If the transaction is not valid we cannot do a commit or a rollback to a savepoint
				-- because a rollback is not allowed. Hence, we must simply return to the caller and 
				-- they will be respnsible to rollback the transaction

				-- If there is no tranaction then there is nothing left to do

		-- After doing the correpsonding rollback, we must propagate the error information to the SP that called us 
		-- See http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[usp_ORG_InsertArea]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Cerate a new area for an organization
-- =============================================
CREATE PROCEDURE [dbo].[usp_ORG_InsertArea]
	@organizationID int,
	@areaName nvarchar(250),
	@areaID int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO [dbo].[tbl_Area]
           ([organizationID]
           ,[name])
     VALUES
           (@organizationID
           ,@areaName)

	SELECT @areaID = SCOPE_IDENTITY()
END

GO
/****** Object:  StoredProcedure [dbo].[usp_ORG_InsertOrganization]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Cerate a new organization
-- =============================================
CREATE PROCEDURE [dbo].[usp_ORG_InsertOrganization]
	@userName varchar(50),
	@organizationName nvarchar(250),
	@organizationID int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	-- We detect if the SP was called from an active transation and 
	-- we save it to use it later.  In the SP, @TranCounter = 0
	-- means that there are no active transations and that this SP
	-- started one. @TranCounter > 0 means that a transation was started
	-- before we started this SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0
		-- We called this SP when an active transaction already exists.
		-- We create a savepoint to be able to only roll back this 
		-- transaction if there is some error.
		-- ===============================================
		---  MAKE SURE THAT THIS NAME IS COPIED BELOW 
		---  AND IS UNIQUE IN THE SYSTEM!!!!!!
		-- ===============================================
		SAVE TRANSACTION InsertOrganiPS;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		INSERT INTO [dbo].[tbl_Organization]
			   ([name])
		VALUES
			   (@organizationName)

		SELECT @organizationID = SCOPE_IDENTITY()

		-- Ensure that the owner can manage this object
		INSERT INTO [dbo].[tbl_SEG_ObjectPermissions]
           ([objectTypeID]
           ,[objectID]
           ,[username]
           ,[objectActionID])
		VALUES
           ('ORGANIZATION'
           ,@organizationID
           ,@userName
           ,'OWN')	

		-- We arrived here without errors; we should commit the transation we started
		-- but we should not commit if there was a previous transaction started
		IF @TranCounter = 0
			-- @TranCounter = 0 means that no other transaction was started before this transaction 
			-- and that we shouold hence commit this transaction
			COMMIT TRANSACTION;
		
	END TRY
	BEGIN CATCH

		-- There was an error.  We need to determine what type of rollback we must perform

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		IF @TranCounter = 0
			-- We have only the transaction that we started in this SP.  Rollback
			-- all the tranaction.
			ROLLBACK TRANSACTION;
		ELSE
			-- A transaction was started before this SP was called.  We must
			-- rollback only the changes we made in this SP.

			-- We see XACT_STATE and the possible results are 0, 1, or -1.
			-- If it is 1, the transaction is valid and we can do a commit. But since we are in the 
			-- CATCH we don't do the commit. We need to rollback to the savepoint
			-- If it is -1 the transaction is not valid and we must do a full rollback... we can't
			-- do a rollback to a savepoint
			-- XACT_STATE = 0 means that there is no transaciton and a rollback would cause an error
			-- See http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() = 1
				-- If the transaction is still valid then we rollback to the restore point defined before
				-- ===============================================
				---  MAKE SURE THAT THIS NAME IS EXACTLY AS ABOVE 
				-- ===============================================
				ROLLBACK TRANSACTION InsertOrganiPS;

				-- If the transaction is not valid we cannot do a commit or a rollback to a savepoint
				-- because a rollback is not allowed. Hence, we must simply return to the caller and 
				-- they will be respnsible to rollback the transaction

				-- If there is no tranaction then there is nothing left to do

		-- After doing the correpsonding rollback, we must propagate the error information to the SP that called us 
		-- See http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[usp_ORG_UpdateOrganization]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 12 2016
-- Description:	Update the name of the organization
-- =============================================
CREATE PROCEDURE [dbo].[usp_ORG_UpdateOrganization]
	@organizationID int,
	@organizationName nvarchar(250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [dbo].[tbl_Organization]
	SET [name] = @organizationName
	WHERE [organizationID] = @organizationID

END

GO
/****** Object:  StoredProcedure [dbo].[usp_PROJ_DeleteProject]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Delete a project and all of the 
-- related objects
-- =============================================
CREATE PROCEDURE [dbo].[usp_PROJ_DeleteProject]
	@projectID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- We detect if the SP was called from an active transation and 
	-- we save it to use it later.  In the SP, @TranCounter = 0
	-- means that there are no active transations and that this SP
	-- started one. @TranCounter > 0 means that a transation was started
	-- before we started this SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0
		-- We called this SP when an active transaction already exists.
		-- We create a savepoint to be able to only roll back this 
		-- transaction if there is some error.
		-- ===============================================
		---  MAKE SURE THAT THIS NAME IS COPIED BELOW 
		---  AND IS UNIQUE IN THE SYSTEM!!!!!!
		-- ===============================================
		SAVE TRANSACTION DeleteOrganization;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		-- We basically have to delete everything related to that project.
		
		-- Start with KPIs. 
		-- Get the IDs of all the KPIs we will delete
		DECLARE @KPITable as TABLE (kpiID int)
		INSERT INTO @KPITable
		SELECT [kpiID] from [dbo].[tbl_KPI]
		where [projectID] = @projectID

		-- Delete all measurements for the KPIs selected

		-- Delete all permissions for the KPIs selected
		DELETE FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and [objectID] in (select kpiID from @KPITable)

		-- Delete the KPIs selected
		DELETE FROM [dbo].[tbl_KPI]
		where [kpiID] in (select kpiID from @KPITable)

		-- Now lets delete all activities for the project
		-- Get the IDs of all the activities we will delete
		-- Delete all the permissios for these activities
		-- Delete the activities

		-- Now lets delete the permissions for the project

		-- And finally lets delete the project

		-- =============================================================
		-- INSERT THE SQL STATEMENTS HERE
		-- =============================================================

		-- We arrived here without errors; we should commit the transation we started
		-- but we should not commit if there was a previous transaction started
		IF @TranCounter = 0
			-- @TranCounter = 0 means that no other transaction was started before this transaction 
			-- and that we shouold hence commit this transaction
			COMMIT TRANSACTION;
		
	END TRY
	BEGIN CATCH

		-- There was an error.  We need to determine what type of rollback we must perform

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		IF @TranCounter = 0
			-- We have only the transaction that we started in this SP.  Rollback
			-- all the tranaction.
			ROLLBACK TRANSACTION;
		ELSE
			-- A transaction was started before this SP was called.  We must
			-- rollback only the changes we made in this SP.

			-- We see XACT_STATE and the possible results are 0, 1, or -1.
			-- If it is 1, the transaction is valid and we can do a commit. But since we are in the 
			-- CATCH we don't do the commit. We need to rollback to the savepoint
			-- If it is -1 the transaction is not valid and we must do a full rollback... we can't
			-- do a rollback to a savepoint
			-- XACT_STATE = 0 means that there is no transaciton and a rollback would cause an error
			-- See http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() = 1
				-- If the transaction is still valid then we rollback to the restore point defined before
				-- ===============================================
				---  MAKE SURE THAT THIS NAME IS EXACTLY AS ABOVE 
				-- ===============================================
				ROLLBACK TRANSACTION DeleteOrganization;

				-- If the transaction is not valid we cannot do a commit or a rollback to a savepoint
				-- because a rollback is not allowed. Hence, we must simply return to the caller and 
				-- they will be respnsible to rollback the transaction

				-- If there is no tranaction then there is nothing left to do

		-- After doing the correpsonding rollback, we must propagate the error information to the SP that called us 
		-- See http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[usp_PROJ_InsertProject]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Cerate a new project
-- =============================================
CREATE PROCEDURE [dbo].[usp_PROJ_InsertProject]
	@userName varchar(50),
	@organizationID int,
	@areaID int,
	@projectName nvarchar(250),
	@projectID int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- We detect if the SP was called from an active transation and 
	-- we save it to use it later.  In the SP, @TranCounter = 0
	-- means that there are no active transations and that this SP
	-- started one. @TranCounter > 0 means that a transation was started
	-- before we started this SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0
		-- We called this SP when an active transaction already exists.
		-- We create a savepoint to be able to only roll back this 
		-- transaction if there is some error.
		-- ===============================================
		---  MAKE SURE THAT THIS NAME IS COPIED BELOW 
		---  AND IS UNIQUE IN THE SYSTEM!!!!!!
		-- ===============================================
		SAVE TRANSACTION InsertProjectPS;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		IF(@areaID = 0)
			SELECT @areaID = null

		INSERT INTO [dbo].[tbl_Project]
           ([name]
           ,[organizationID]
           ,[areaID])
		VALUES
           (@projectName
           ,@organizationID
           ,@areaID)

		SELECT @projectID = SCOPE_IDENTITY()

		-- Ensure that the owner can manage this object
		INSERT INTO [dbo].[tbl_SEG_ObjectPermissions]
           ([objectTypeID]
           ,[objectID]
           ,[username]
           ,[objectActionID])
		VALUES
           ('PROJECT'
           ,@projectID
           ,@userName
           ,'OWN')

		-- We arrived here without errors; we should commit the transation we started
		-- but we should not commit if there was a previous transaction started
		IF @TranCounter = 0
			-- @TranCounter = 0 means that no other transaction was started before this transaction 
			-- and that we shouold hence commit this transaction
			COMMIT TRANSACTION;
		
	END TRY
	BEGIN CATCH

		-- There was an error.  We need to determine what type of rollback we must perform

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		IF @TranCounter = 0
			-- We have only the transaction that we started in this SP.  Rollback
			-- all the tranaction.
			ROLLBACK TRANSACTION;
		ELSE
			-- A transaction was started before this SP was called.  We must
			-- rollback only the changes we made in this SP.

			-- We see XACT_STATE and the possible results are 0, 1, or -1.
			-- If it is 1, the transaction is valid and we can do a commit. But since we are in the 
			-- CATCH we don't do the commit. We need to rollback to the savepoint
			-- If it is -1 the transaction is not valid and we must do a full rollback... we can't
			-- do a rollback to a savepoint
			-- XACT_STATE = 0 means that there is no transaciton and a rollback would cause an error
			-- See http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() = 1
				-- If the transaction is still valid then we rollback to the restore point defined before
				-- ===============================================
				---  MAKE SURE THAT THIS NAME IS EXACTLY AS ABOVE 
				-- ===============================================
				ROLLBACK TRANSACTION InsertProjectPS;

				-- If the transaction is not valid we cannot do a commit or a rollback to a savepoint
				-- because a rollback is not allowed. Hence, we must simply return to the caller and 
				-- they will be respnsible to rollback the transaction

				-- If there is no tranaction then there is nothing left to do

		-- After doing the correpsonding rollback, we must propagate the error information to the SP that called us 
		-- See http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[usp_PROJ_UpdateProject]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 12 2016
-- Description:	Update the name and context of a project
-- =============================================
CREATE PROCEDURE [dbo].[usp_PROJ_UpdateProject]
	@projectID int,
	@projectName nvarchar(250),
	@organizationID int,
	@areaID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if(@areaID = null)
		select @areaID = NULL

	UPDATE [dbo].[tbl_Project]
	SET [name] = @projectName
		  ,[organizationID] = @organizationID
		  ,[areaID] = @areaID
	 WHERE projectID = @projectID

END

GO
/****** Object:  StoredProcedure [dbo].[usp_SearchCode]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[usp_SearchCode]
	@SearchStr 	varchar(100),
	@RowsReturned	int = NULL	OUT
-- ENCRYPT_ME
AS
/*************************************************************************************************
		Copyright © 1997 - 2002 Narayana Vyas Kondreddi. All rights reserved.
                                          
Purpose:	To search the stored proceudre, UDF, trigger code for a given keyword.

Written by:	Narayana Vyas Kondreddi
		http://vyaskn.tripod.com

Tested on: 	SQL Server 7.0, SQL Server 2000

Date created:	January-22-2002 21:37 GMT

Date modified:	February-17-2002 19:31 GMT

Email: 		vyaskn@hotmail.com

Examples:

To search your database code for the keyword 'unauthorized':
EXEC sp_search_code 'unauthorized'

To search your database code for the keyword 'FlowerOrders' and also find out the number of hits:
DECLARE @Hits int
EXEC sp_search_code 'FlowerOrders', @Hits OUT
SELECT 'Found ' + LTRIM(STR(@Hits)) + ' object(s) containing this keyword' AS Result
*************************************************************************************************/
BEGIN
	SET NOCOUNT ON

	SELECT	DISTINCT USER_NAME(o.uid) + '.' + OBJECT_NAME(c.id) AS 'Object name',
		CASE 
 			WHEN OBJECTPROPERTY(c.id, 'IsReplProc') = 1 
				THEN 'Replication stored procedure'
 			WHEN OBJECTPROPERTY(c.id, 'IsExtendedProc') = 1 
				THEN 'Extended stored procedure'				
			WHEN OBJECTPROPERTY(c.id, 'IsProcedure') = 1 
				THEN 'Stored Procedure' 
			WHEN OBJECTPROPERTY(c.id, 'IsTrigger') = 1 
				THEN 'Trigger' 
			WHEN OBJECTPROPERTY(c.id, 'IsTableFunction') = 1 
				THEN 'Table-valued function' 
			WHEN OBJECTPROPERTY(c.id, 'IsScalarFunction') = 1 
				THEN 'Scalar-valued function'
 			WHEN OBJECTPROPERTY(c.id, 'IsInlineFunction') = 1 
				THEN 'Inline function'	
		END AS 'Object type',
		'EXEC sp_helptext ''' + USER_NAME(o.uid) + '.' + OBJECT_NAME(c.id) + '''' AS 'Run this command to see the object text'
	FROM	syscomments c
		INNER JOIN
		sysobjects o
		ON c.id = o.id
	WHERE	c.text LIKE '%' + @SearchStr + '%'	AND
		encrypted = 0				AND
		(
		OBJECTPROPERTY(c.id, 'IsReplProc') = 1		OR
		OBJECTPROPERTY(c.id, 'IsExtendedProc') = 1	OR
		OBJECTPROPERTY(c.id, 'IsProcedure') = 1		OR
		OBJECTPROPERTY(c.id, 'IsTrigger') = 1		OR
		OBJECTPROPERTY(c.id, 'IsTableFunction') = 1	OR
		OBJECTPROPERTY(c.id, 'IsScalarFunction') = 1	OR
		OBJECTPROPERTY(c.id, 'IsInlineFunction') = 1	
		)

	ORDER BY	'Object type', 'Object name'

	SET @RowsReturned = @@ROWCOUNT
END


GO
/****** Object:  StoredProcedure [dbo].[usp_SEG_AddDefaultAdministratorAccess]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- ==============================================================================================================
/* 
* Add default access to administrator.
* The administrator for the application should ALWAYS be able to define access 
* control.  Otherwise the application locks up.  Hence, we add access to
* operation 1 for the given group, if it does not exist.
* Variables: @roleName
*/
CREATE PROCEDURE [dbo].[usp_SEG_AddDefaultAdministratorAccess] 
	-- Add the parameters for the stored procedure here
	@roleName as varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DECLARE @intCount AS INT 
	SELECT  @intCount = count(*) 
	FROM [dbo].[tbl_SEG_AccessRole] 
	WHERE [role] = @roleName 
	AND [permissionID] = 
				(SELECT [permissionID] 
				 FROM [tbl_SEG_Permission]
				 WHERE [mnemonic] = 'MANAGE_USERS_ROLES')
				 
	IF(@intCount = 0)  
	BEGIN
		INSERT INTO [dbo].[tbl_SEG_AccessRole] ([permissionID], [role])
		VALUES (1, @roleName)
	END
END





GO
/****** Object:  StoredProcedure [dbo].[usp_SEG_DeleteOperationForRole]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[usp_SEG_DeleteOperationForRole]
	@intPermissionID int,
	@varRole varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(
				SELECT * 
						FROM [dbo].[tbl_SEG_AccessRole] 
						WHERE [permissionid] = @intPermissionID AND [role] = @varRole
 			  )
	BEGIN
 		DELETE FROM [dbo].[tbl_SEG_AccessRole] 
			WHERE [permissionid] = @intPermissionID AND [role] = @varRole
	END
END





GO
/****** Object:  StoredProcedure [dbo].[usp_SEG_DeleteOperationForUser]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[usp_SEG_DeleteOperationForUser]
	@intPermissionID int,
	@intUserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(
				SELECT * 
						FROM [dbo].[tbl_SEG_AccessUser] 
						WHERE [permissionId] = @intPermissionID 
						AND [userId] = @intUserID
 			  )
	BEGIN
 		DELETE FROM [dbo].[tbl_SEG_AccessUser] 
						WHERE [permissionId] = @intPermissionID 
						AND [userId] = @intUserID
	END
END





GO
/****** Object:  StoredProcedure [dbo].[usp_SEG_DeleteUserRecord]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[usp_SEG_DeleteUserRecord]
	@intUserId AS INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0
		-- Procedure called when there is an active transaction.
		-- Create a savepoint to be able to roll back only the work done
		-- in the procedure if there is an error.
		SAVE TRANSACTION DeleteUserRecordPS;
	ELSE
		-- Procedure must start its own transaction.
		BEGIN TRANSACTION;

	BEGIN TRY	
	
		DELETE FROM [dbo].[tbl_SEG_User]
			WHERE 
			[userId] = @intUserId

	-- Llegamos aquí si no hay errores;  debemos hacer un commit de la transacción
		-- que comenzamos, pero no debemos hacer un comit si hubo una transacción
		-- comenzada anteriormente.
		IF @TranCounter = 0
			-- @TranCounter = 0 significa que no se comenzó ninguna transacción antes de 
			-- esta transacción y por lo tando debemos hacer un comit de nuestra 
			-- stranacción.
			COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH

		-- Hubo un error. Debemos detemrinar que tipo de rollback debemos hacer.

		IF @TranCounter = 0
			-- Tenemos sólo la transacción que comenzamos en este SP.  Rollback
			-- toda la transacción.
			ROLLBACK TRANSACTION;
		ELSE
			-- Se comenzó una transacción antes de que llamen a este SP. Debemos hacer
			-- un rollback solo de las modificaciones que hicimos en este SP

			-- Vemos XACT_STATE y los posibles resultados son 0, 1, or -1.
			-- Si es 1, la transacción es válida y se puede hacer un comit. Pero como 
			-- estamos en el CATCH no hacemos comit.
			-- Si es -1 la transacción no es válida y se debe hacer un rollback
			-- Si es - Significa que no hay un transacción y que un rollback causaría un error
			-- Ver http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() <> -1
				-- Si la transacción es todavía válida, hacemos un rollback hasta el punto
				-- de restauración definido anteriormente.  
				-- Sólo podemos hacer un rollback si XACT_STATE() = -1
				-- OJO: Este es el mismo nombre utilizado anterioremente!!  
				ROLLBACK TRANSACTION InsertUserPS;

				-- Si la transaccion no es válida no se puede hacer un commit ni un rollback, 
				-- por lo que un rollback al punto de restauración no es permitido por que 
				-- el rollback al punto de restauración escribiría en el log de la base de 
				-- datos.  Símplemente debemos retornar al que nos llamó y este será 
				-- responsable de hacer rollback a la transacción. 

		-- Luego de hacer el rollback correspondiente, debemos propagar la información de error
		-- al SP que nos llamó. 
		--
		-- Ver http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH
END





GO
/****** Object:  StoredProcedure [dbo].[usp_SEG_GetClientsForSearch]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[usp_SEG_GetClientsForSearch]
	@whereSql AS VARCHAR(4000)
AS
BEGIN
	
	DECLARE @sqlQuery nvarchar(4000)
	

	SET @sqlQuery = '
	  
	  SELECT U.[ClienteId]
		  ,U.[CodigoIdentificacion]
		  ,U.[NombreCompleto]
		  ,U.[paisId]
		  ,U.[ciudadId]
		  ,U.[direccion]
		  ,U.[tipoClienteId]
		  ,U.[UserName]
		  ,U.[passwordChanged]
		  ,U.[estado]
		  ,U.[creditoEmision]
	      ,U.[creditoFlete]
	      ,U.[fechaRegistro]
		  ,U.[montoMaximoDeuda]
		  ,U.[observacionesCredito]
	  FROM [dbo].[tbl_CLI_Cliente] U
	  WHERE ' + @whereSql 
	
	EXEC(@sqlQuery)
	
END






GO
/****** Object:  StoredProcedure [dbo].[usp_SEG_GetPermissionsForRole]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[usp_SEG_GetPermissionsForRole]
	-- Add the parameters for the stored procedure here
	@varRole varchar(100)
-- ENCRYPT_ME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [os].[permissionid], 
		[os].[description], 
		[ar].[role]
	FROM [dbo].[tbl_SEG_Permission] [os] 
		LEFT OUTER JOIN [dbo].[tbl_SEG_AccessRole] [ar] 
		ON [os].[permissionid] = [ar].[permissionid]
		AND [ar].[role] = @varRole
		ORDER BY [os].[description] ASC
END





GO
/****** Object:  StoredProcedure [dbo].[usp_SEG_GetPermissionsForUser]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[usp_SEG_GetPermissionsForUser]
	@intUserId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [os].[permissionId], 
		 [os].[description], 
		[au].[userid]
	FROM [dbo].[tbl_SEG_Permission] [os] 
		LEFT OUTER JOIN [dbo].[tbl_SEG_AccessUser] [au] 
		ON [os].[permissionid] = [au].[permissionid]
		AND [au].[userid] = @intUserId
		ORDER BY [os].[description] ASC
END





GO
/****** Object:  StoredProcedure [dbo].[usp_SEG_GetRolesAllowedForPermission]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- ==============================================================================================================
CREATE PROCEDURE [dbo].[usp_SEG_GetRolesAllowedForPermission] 
	@varMnemonic VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [ar].[role] 
		FROM [dbo].[tbl_SEG_Permission] [os], [dbo].[tbl_SEG_AccessRole] [ar]
		WHERE [os].[permissionID] = [ar].[permissionID] 
		AND [os].[mnemonic] = @varMnemonic
END





GO
/****** Object:  StoredProcedure [dbo].[usp_SEG_GetUserById]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[usp_SEG_GetUserById]
	@intUserId AS INT
AS
BEGIN
	SELECT [userId]
      ,[fullname]
      ,[cellphone]
      ,[address]
      ,[phonenumber]
      ,[phonearea]
      ,[phonecode]
	  ,[username]
	  ,[email]
  FROM [dbo].[tbl_SEG_User]
	WHERE	
		[userId] = @intUserId 
END






GO
/****** Object:  StoredProcedure [dbo].[usp_SEG_GetUserByUsername]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--=================================================================================================================
CREATE PROCEDURE [dbo].[usp_SEG_GetUserByUsername]
	@varUserName AS VARCHAR(50)
AS
BEGIN
	SELECT [userId]
      ,[fullname]
      ,[cellphone]
      ,[address]
      ,[phonenumber]
      ,[phonearea]
      ,[phonecode]
	  ,[username]
	  ,[email]
  FROM [dbo].[tbl_SEG_User]
	WHERE	
		[username] = @varUserName
END






GO
/****** Object:  StoredProcedure [dbo].[usp_SEG_GetUsersBySearchParameters]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[usp_SEG_GetUsersBySearchParameters]
	@varUserName AS VARCHAR(50),	
	@varFullname AS VARCHAR(500)
AS
BEGIN
	SELECT [userId]
      ,[fullname]
      ,[cellphone]
      ,[address]
      ,[phonenumber]
      ,[phonearea]
      ,[phonecode]
	  ,[username]
	  ,[email]
  FROM [dbo].[tbl_SEG_User]
	WHERE
		CASE @varUserName 
			WHEN '' THEN 1
			ELSE
				CASE WHEN
					[username] LIKE @varUserName
				THEN 1 ELSE 0 END
		END  = 1
	AND
		CASE @varFullname
			WHEN '' THEN 1
			ELSE
				CASE WHEN
					[fullname] LIKE @varFullname
				THEN 1 ELSE 0 END
		END = 1
END






GO
/****** Object:  StoredProcedure [dbo].[usp_SEG_GetUsersForSearch]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[usp_SEG_GetUsersForSearch]
	@whereSql AS VARCHAR(4000)
AS
BEGIN
	
	DECLARE @sqlQuery nvarchar(4000)
	

	SET @sqlQuery = 'SELECT U.[userId]
		  ,U.[fullname]
		  ,U.[cellphone]
		  ,U.[address]
		  ,U.[phonenumber]
		  ,U.[phonearea]
		  ,U.[phonecode]
		  ,U.[username]
		  ,U.[email]
	  FROM [dbo].[tbl_SEG_User] U
	  WHERE ' + @whereSql 
	
	EXEC(@sqlQuery)
	
END






GO
/****** Object:  StoredProcedure [dbo].[usp_SEG_GeUserIdByEmail]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[usp_SEG_GeUserIdByEmail]
	@varEmailAddress VARCHAR(250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [userId]
		FROM [dbo].[tbl_SEG_User]
		WHERE [email] = @varEmailAddress
END






GO
/****** Object:  StoredProcedure [dbo].[usp_TRANSACTION_PATERN]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Transaction pattern for use in the system
-- =============================================
CREATE PROCEDURE [dbo].[usp_TRANSACTION_PATERN]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- We detect if the SP was called from an active transation and 
	-- we save it to use it later.  In the SP, @TranCounter = 0
	-- means that there are no active transations and that this SP
	-- started one. @TranCounter > 0 means that a transation was started
	-- before we started this SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0
		-- We called this SP when an active transaction already exists.
		-- We create a savepoint to be able to only roll back this 
		-- transaction if there is some error.
		-- ===============================================
		---  MAKE SURE THAT THIS NAME IS COPIED BELOW 
		---  AND IS UNIQUE IN THE SYSTEM!!!!!!
		-- ===============================================
		SAVE TRANSACTION XXXXXXXXXXXXXXXXXXXX;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		-- =============================================================
		-- INSERT THE SQL STATEMENTS HERE
		-- =============================================================

		-- We arrived here without errors; we should commit the transation we started
		-- but we should not commit if there was a previous transaction started
		IF @TranCounter = 0
			-- @TranCounter = 0 means that no other transaction was started before this transaction 
			-- and that we shouold hence commit this transaction
			COMMIT TRANSACTION;
		
	END TRY
	BEGIN CATCH

		-- There was an error.  We need to determine what type of rollback we must perform

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		IF @TranCounter = 0
			-- We have only the transaction that we started in this SP.  Rollback
			-- all the tranaction.
			ROLLBACK TRANSACTION;
		ELSE
			-- A transaction was started before this SP was called.  We must
			-- rollback only the changes we made in this SP.

			-- We see XACT_STATE and the possible results are 0, 1, or -1.
			-- If it is 1, the transaction is valid and we can do a commit. But since we are in the 
			-- CATCH we don't do the commit. We need to rollback to the savepoint
			-- If it is -1 the transaction is not valid and we must do a full rollback... we can't
			-- do a rollback to a savepoint
			-- XACT_STATE = 0 means that there is no transaciton and a rollback would cause an error
			-- See http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() = 1
				-- If the transaction is still valid then we rollback to the restore point defined before
				-- ===============================================
				---  MAKE SURE THAT THIS NAME IS EXACTLY AS ABOVE 
				-- ===============================================
				ROLLBACK TRANSACTION XXXXXXXXXXXXXXXXXXXX;

				-- If the transaction is not valid we cannot do a commit or a rollback to a savepoint
				-- because a rollback is not allowed. Hence, we must simply return to the caller and 
				-- they will be respnsible to rollback the transaction

				-- If there is no tranaction then there is nothing left to do

		-- After doing the correpsonding rollback, we must propagate the error information to the SP that called us 
		-- See http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[usp_TSK_DeleteManagerRecord]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TSK_DeleteManagerRecord]
	@intTaskMgrId AS INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0
		-- Procedure called when there is an active transaction.
		-- Create a savepoint to be able to roll back only the work done
		-- in the procedure if there is an error.
		SAVE TRANSACTION DeleteManagerRecordPS;
	ELSE
		-- Procedure must start its own transaction.
		BEGIN TRANSACTION;

	BEGIN TRY	
	
		DELETE FROM [dbo].[tbl_TSK_Manager]
			WHERE 
			[ManagerId] = @intTaskMgrId

	-- Llegamos aquí si no hay errores;  debemos hacer un commit de la transacción
		-- que comenzamos, pero no debemos hacer un comit si hubo una transacción
		-- comenzada anteriormente.
		IF @TranCounter = 0
			-- @TranCounter = 0 significa que no se comenzó ninguna transacción antes de 
			-- esta transacción y por lo tando debemos hacer un comit de nuestra 
			-- stranacción.
			COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH

		-- Hubo un error. Debemos detemrinar que tipo de rollback debemos hacer.

		IF @TranCounter = 0
			-- Tenemos sólo la transacción que comenzamos en este SP.  Rollback
			-- toda la transacción.
			ROLLBACK TRANSACTION;
		ELSE
			-- Se comenzó una transacción antes de que llamen a este SP. Debemos hacer
			-- un rollback solo de las modificaciones que hicimos en este SP

			-- Vemos XACT_STATE y los posibles resultados son 0, 1, or -1.
			-- Si es 1, la transacción es válida y se puede hacer un comit. Pero como 
			-- estamos en el CATCH no hacemos comit.
			-- Si es -1 la transacción no es válida y se debe hacer un rollback
			-- Si es - Significa que no hay un transacción y que un rollback causaría un error
			-- Ver http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() <> -1
				-- Si la transacción es todavía válida, hacemos un rollback hasta el punto
				-- de restauración definido anteriormente.  
				-- Sólo podemos hacer un rollback si XACT_STATE() = -1
				-- OJO: Este es el mismo nombre utilizado anterioremente!!  
				ROLLBACK TRANSACTION DeleteManagerRecordPS;

				-- Si la transaccion no es válida no se puede hacer un commit ni un rollback, 
				-- por lo que un rollback al punto de restauración no es permitido por que 
				-- el rollback al punto de restauración escribiría en el log de la base de 
				-- datos.  Símplemente debemos retornar al que nos llamó y este será 
				-- responsable de hacer rollback a la transacción. 

		-- Luego de hacer el rollback correspondiente, debemos propagar la información de error
		-- al SP que nos llamó. 
		--
		-- Ver http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH
END


GO
/****** Object:  StoredProcedure [dbo].[usp_TSK_DeleteTaskRecord]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TSK_DeleteTaskRecord]
	@varTaskId AS VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0
		-- Procedure called when there is an active transaction.
		-- Create a savepoint to be able to roll back only the work done
		-- in the procedure if there is an error.
		SAVE TRANSACTION DeleteTaskRecordPS;
	ELSE
		-- Procedure must start its own transaction.
		BEGIN TRANSACTION;

	BEGIN TRY	
	
		DELETE FROM [dbo].[tbl_TSK_Task]
			WHERE 
			[TaskId] = @varTaskId

	-- Llegamos aquí si no hay errores;  debemos hacer un commit de la transacción
		-- que comenzamos, pero no debemos hacer un comit si hubo una transacción
		-- comenzada anteriormente.
		IF @TranCounter = 0
			-- @TranCounter = 0 significa que no se comenzó ninguna transacción antes de 
			-- esta transacción y por lo tando debemos hacer un comit de nuestra 
			-- stranacción.
			COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH

		-- Hubo un error. Debemos detemrinar que tipo de rollback debemos hacer.

		IF @TranCounter = 0
			-- Tenemos sólo la transacción que comenzamos en este SP.  Rollback
			-- toda la transacción.
			ROLLBACK TRANSACTION;
		ELSE
			-- Se comenzó una transacción antes de que llamen a este SP. Debemos hacer
			-- un rollback solo de las modificaciones que hicimos en este SP

			-- Vemos XACT_STATE y los posibles resultados son 0, 1, or -1.
			-- Si es 1, la transacción es válida y se puede hacer un comit. Pero como 
			-- estamos en el CATCH no hacemos comit.
			-- Si es -1 la transacción no es válida y se debe hacer un rollback
			-- Si es - Significa que no hay un transacción y que un rollback causaría un error
			-- Ver http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() <> -1
				-- Si la transacción es todavía válida, hacemos un rollback hasta el punto
				-- de restauración definido anteriormente.  
				-- Sólo podemos hacer un rollback si XACT_STATE() = -1
				-- OJO: Este es el mismo nombre utilizado anterioremente!!  
				ROLLBACK TRANSACTION DeleteTaskRecordPS;

				-- Si la transaccion no es válida no se puede hacer un commit ni un rollback, 
				-- por lo que un rollback al punto de restauración no es permitido por que 
				-- el rollback al punto de restauración escribiría en el log de la base de 
				-- datos.  Símplemente debemos retornar al que nos llamó y este será 
				-- responsable de hacer rollback a la transacción. 

		-- Luego de hacer el rollback correspondiente, debemos propagar la información de error
		-- al SP que nos llamó. 
		--
		-- Ver http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH
END


GO
/****** Object:  StoredProcedure [dbo].[usp_TSK_GetAllTasks]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TSK_GetAllTasks]
AS
BEGIN
	SELECT [TaskId]
		,[TaskName]
		,[TaskDescription]
		,[StartDate]
		,[EndDate]
		,[PeriodLengthSeconds]
		,[Iterations]
		,[Enabled]
		,[IterationsExecuted]
		,[LastExecutionDate]
	FROM [tbl_TSK_Task] t

END


GO
/****** Object:  StoredProcedure [dbo].[usp_TSK_GetCurrentManager]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TSK_GetCurrentManager]
AS
BEGIN
	SELECT [ManagerId]
      ,[Status]
      ,[SleepTimeSeconds]
      ,[NumberOfOverlapsAllowed]
  FROM [tbl_TSK_Manager]
END


GO
/****** Object:  StoredProcedure [dbo].[usp_TSK_GetManagerById]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TSK_GetManagerById]
	@intTaskMgrId AS INT
AS
BEGIN
	SELECT [ManagerId]
      ,[Status]
      ,[SleepTimeSeconds]
      ,[NumberOfOverlapsAllowed]
  FROM [tbl_TSK_Manager]
	WHERE	
		[ManagerId] = @intTaskMgrId 
END


GO
/****** Object:  StoredProcedure [dbo].[usp_TSK_GetTaskById]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TSK_GetTaskById]
	@varTaskId AS VARCHAR(50)
AS
BEGIN
	SELECT [TaskId]
		,[TaskName]
		,[TaskDescription]
		,[StartDate]
		,[EndDate]
		,[PeriodLengthSeconds]
		,[Iterations]
		,[Enabled]
		,[IterationsExecuted]
		,[LastExecutionDate]
  FROM [tbl_TSK_Task]
	WHERE	
		[TaskId] = @varTaskId 
END


GO
/****** Object:  StoredProcedure [dbo].[usp_TSK_GetTasksForExecution]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TSK_GetTasksForExecution]
AS
BEGIN
	SELECT [TaskId]
		,[TaskName]
		,[TaskDescription]
		,[StartDate]
		,[EndDate]
		,[PeriodLengthSeconds]
		,[Iterations]
		,[Enabled]
		,[IterationsExecuted]
		,[LastExecutionDate]
	FROM [tbl_TSK_Task] t
	WHERE 
			t.[StartDate] <= GETDATE()
		AND DATEADD(ss, t.[PeriodLengthSeconds],CASE WHEN t.[LastExecutionDate] IS NULL THEN t.[StartDate] else t.[LastExecutionDate] END)<=GETDATE()
		AND t.[Enabled] = 1
		AND t.[Iterations] <> 0
		AND t.PeriodLengthSeconds > 0
		AND t.[EndDate] is null
		AND t.[IterationsExecuted] < t.[Iterations]
UNION

	SELECT [TaskId]
		,[TaskName]
		,[TaskDescription]
		,[StartDate]
		,[EndDate]
		,[PeriodLengthSeconds]
		,[Iterations]
		,[Enabled]
		,[IterationsExecuted]
		,[LastExecutionDate]
	FROM [tbl_TSK_Task] t
WHERE 
		t.[StartDate] <= GETDATE()
	AND DATEADD(ss, t.[PeriodLengthSeconds],CASE WHEN t.[LastExecutionDate] IS NULL THEN t.[StartDate] else t.[LastExecutionDate] END)<=GETDATE()
	AND t.[Enabled] = 1
	AND t.[PeriodLengthSeconds] > 0
	AND t.[EndDate] > GETDATE()
	AND t.[Iterations] = 0

END


GO
/****** Object:  StoredProcedure [dbo].[usp_TSK_InsertManagerRecord]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TSK_InsertManagerRecord]
	@intStatus AS INT,
	@longSleepTime AS BIGINT,
	@intNumberOfOverlapsAllowed AS INT,
	@intTaskMgrId AS INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	-- Detectamos si el SP fue llamado desde una transacción activa y 
	-- la guardamos para usarla más tarde.  En el SP, @TranCounter = 0
	-- significa que no existen transacciones activas y que este SP
	-- comenzó una.  @TranCounter > 0 significa que se inició una transacción
	-- antes de la que empezaremos en este SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;

	IF @TranCounter > 0
		-- Se llamó a este SP cuando ya existe una transacción activa.
		-- Creamos un punto de restauración para poder hacer sólo rollback
		-- de esta transacción si hay algún error.
		-- OJO:  Este nombre tiene que cambiarse!!!  Debe ser único para la 
		-- cadena de transacciones.  También debe cambiarse al final del SP!!!
		SAVE TRANSACTION InsertManagerPS;
	ELSE
		-- Este SP comienza su propia transacción y no hay otra antes
		BEGIN TRANSACTION;
	BEGIN TRY
 	
	 INSERT INTO [dbo].[tbl_TSK_Manager]
           ([Status]
           ,[SleepTimeSeconds]
           ,[NumberOfOverlapsAllowed])
     VALUES
           (@intStatus
           ,@longSleepTime
           ,@intNumberOfOverlapsAllowed)

	SELECT @intTaskMgrId = SCOPE_IDENTITY()
	
	-- Llegamos aquí si no hay errores;  debemos hacer un commit de la transacción
		-- que comenzamos, pero no debemos hacer un comit si hubo una transacción
		-- comenzada anteriormente.
		IF @TranCounter = 0
			-- @TranCounter = 0 significa que no se comenzó ninguna transacción antes de 
			-- esta transacción y por lo tando debemos hacer un comit de nuestra 
			-- stranacción.
			COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH

		-- Hubo un error. Debemos detemrinar que tipo de rollback debemos hacer.

		IF @TranCounter = 0
			-- Tenemos sólo la transacción que comenzamos en este SP.  Rollback
			-- toda la transacción.
			ROLLBACK TRANSACTION;
		ELSE
			-- Se comenzó una transacción antes de que llamen a este SP. Debemos hacer
			-- un rollback solo de las modificaciones que hicimos en este SP

			-- Vemos XACT_STATE y los posibles resultados son 0, 1, or -1.
			-- Si es 1, la transacción es válida y se puede hacer un comit. Pero como 
			-- estamos en el CATCH no hacemos comit.
			-- Si es -1 la transacción no es válida y se debe hacer un rollback
			-- Si es - Significa que no hay un transacción y que un rollback causaría un error
			-- Ver http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() <> -1
				-- Si la transacción es todavía válida, hacemos un rollback hasta el punto
				-- de restauración definido anteriormente.  
				-- Sólo podemos hacer un rollback si XACT_STATE() = -1
				-- OJO: Este es el mismo nombre utilizado anterioremente!!  
				ROLLBACK TRANSACTION InsertManagerPS;

				-- Si la transaccion no es válida no se puede hacer un commit ni un rollback, 
				-- por lo que un rollback al punto de restauración no es permitido por que 
				-- el rollback al punto de restauración escribiría en el log de la base de 
				-- datos.  Símplemente debemos retornar al que nos llamó y este será 
				-- responsable de hacer rollback a la transacción. 

		-- Luego de hacer el rollback correspondiente, debemos propagar la información de error
		-- al SP que nos llamó. 
		--
		-- Ver http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH
END


GO
/****** Object:  StoredProcedure [dbo].[usp_TSK_InsertTaskRecord]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TSK_InsertTaskRecord]
	@varTaskName AS VARCHAR(50),
	@varTaskDescription AS VARCHAR(50),
	@dtStartDate AS DATETIME,
	@dtEndDate AS DATETIME,
	@longPeriodLength as BIGINT,
	@intIterations AS int,
	@boolEnabled as bit,
	@intIterationsExec as int,
	@dtLastExDate as DATETIME,
	@varTaskId AS VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @varFinalTaskName AS VARCHAR(50);
	DECLARE @varFinalTaskDescription AS VARCHAR(50);

	IF(@varTaskName = '')
		SELECT @varFinalTaskName = NULL 
	ELSE
		SELECT @varFinalTaskName = @varTaskName
		
	IF(@varTaskDescription = '')
		SELECT @varFinalTaskDescription = NULL 
	ELSE
		SELECT @varFinalTaskDescription = @varTaskDescription

	-- Detectamos si el SP fue llamado desde una transacción activa y 
	-- la guardamos para usarla más tarde.  En el SP, @TranCounter = 0
	-- significa que no existen transacciones activas y que este SP
	-- comenzó una.  @TranCounter > 0 significa que se inició una transacción
	-- antes de la que empezaremos en este SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;

	IF @TranCounter > 0
		-- Se llamó a este SP cuando ya existe una transacción activa.
		-- Creamos un punto de restauración para poder hacer sólo rollback
		-- de esta transacción si hay algún error.
		-- OJO:  Este nombre tiene que cambiarse!!!  Debe ser único para la 
		-- cadena de transacciones.  También debe cambiarse al final del SP!!!
		SAVE TRANSACTION InsertTaskPS;
	ELSE
		-- Este SP comienza su propia transacción y no hay otra antes
		BEGIN TRANSACTION;
	BEGIN TRY
 	
	 INSERT INTO [dbo].[tbl_TSK_Task]
           ([TaskId],
           [TaskName]
           ,[TaskDescription]
           ,[StartDate]
           ,[EndDate]
           ,[PeriodLengthSeconds]
           ,[Iterations]
           ,[Enabled]
           ,[IterationsExecuted]
           ,[LastExecutionDate])
     VALUES
           (@varTaskId,
           @varFinalTaskName
           ,@varFinalTaskDescription,
           @dtStartDate
           ,@dtEndDate
           ,@longPeriodLength
           ,@intIterations
           ,@boolEnabled
           ,@intIterationsExec
           ,@dtLastExDate)
	
	-- Llegamos aquí si no hay errores;  debemos hacer un commit de la transacción
		-- que comenzamos, pero no debemos hacer un comit si hubo una transacción
		-- comenzada anteriormente.
		IF @TranCounter = 0
			-- @TranCounter = 0 significa que no se comenzó ninguna transacción antes de 
			-- esta transacción y por lo tando debemos hacer un comit de nuestra 
			-- stranacción.
			COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH

		-- Hubo un error. Debemos detemrinar que tipo de rollback debemos hacer.

		IF @TranCounter = 0
			-- Tenemos sólo la transacción que comenzamos en este SP.  Rollback
			-- toda la transacción.
			ROLLBACK TRANSACTION;
		ELSE
			-- Se comenzó una transacción antes de que llamen a este SP. Debemos hacer
			-- un rollback solo de las modificaciones que hicimos en este SP

			-- Vemos XACT_STATE y los posibles resultados son 0, 1, or -1.
			-- Si es 1, la transacción es válida y se puede hacer un comit. Pero como 
			-- estamos en el CATCH no hacemos comit.
			-- Si es -1 la transacción no es válida y se debe hacer un rollback
			-- Si es - Significa que no hay un transacción y que un rollback causaría un error
			-- Ver http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() <> -1
				-- Si la transacción es todavía válida, hacemos un rollback hasta el punto
				-- de restauración definido anteriormente.  
				-- Sólo podemos hacer un rollback si XACT_STATE() = -1
				-- OJO: Este es el mismo nombre utilizado anterioremente!!  
				ROLLBACK TRANSACTION InsertTaskPS;

				-- Si la transaccion no es válida no se puede hacer un commit ni un rollback, 
				-- por lo que un rollback al punto de restauración no es permitido por que 
				-- el rollback al punto de restauración escribiría en el log de la base de 
				-- datos.  Símplemente debemos retornar al que nos llamó y este será 
				-- responsable de hacer rollback a la transacción. 

		-- Luego de hacer el rollback correspondiente, debemos propagar la información de error
		-- al SP que nos llamó. 
		--
		-- Ver http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH
END


GO
/****** Object:  StoredProcedure [dbo].[usp_TSK_UpdateManagerRecord]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TSK_UpdateManagerRecord]
	@intStatus AS INT,
	@longSleepTime AS BIGINT,
	@intNumberOfOverlapsAllowed AS INT,
	@intTaskMgrId AS INT
AS
BEGIN
	SET NOCOUNT ON;
		
	-- Detectamos si el SP fue llamado desde una transacción activa y 
	-- la guardamos para usarla más tarde.  En el SP, @TranCounter = 0
	-- significa que no existen transacciones activas y que este SP
	-- comenzó una.  @TranCounter > 0 significa que se inició una transacción
	-- antes de la que empezaremos en este SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;

	IF @TranCounter > 0
		-- Se llamó a este SP cuando ya existe una transacción activa.
		-- Creamos un punto de restauración para poder hacer sólo rollback
		-- de esta transacción si hay algún error.
		-- OJO:  Este nombre tiene que cambiarse!!!  Debe ser único para la 
		-- cadena de transacciones.  También debe cambiarse al final del SP!!!
		SAVE TRANSACTION UpdateManagerPS;
	ELSE
		-- Este SP comienza su propia transacción y no hay otra antes
		BEGIN TRANSACTION;
	BEGIN TRY
	
		UPDATE [dbo].[tbl_TSK_Manager]
	    SET [Status] = @intStatus
		  ,[SleepTimeSeconds] = @longSleepTime
		  ,[NumberOfOverlapsAllowed] = @intNumberOfOverlapsAllowed
		WHERE 
			[ManagerId] = @intTaskMgrId
	
	-- Llegamos aquí si no hay errores;  debemos hacer un commit de la transacción
		-- que comenzamos, pero no debemos hacer un comit si hubo una transacción
		-- comenzada anteriormente.
		IF @TranCounter = 0
			-- @TranCounter = 0 significa que no se comenzó ninguna transacción antes de 
			-- esta transacción y por lo tando debemos hacer un comit de nuestra 
			-- stranacción.
			COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH

		-- Hubo un error. Debemos detemrinar que tipo de rollback debemos hacer.

		IF @TranCounter = 0
			-- Tenemos sólo la transacción que comenzamos en este SP.  Rollback
			-- toda la transacción.
			ROLLBACK TRANSACTION;
		ELSE
			-- Se comenzó una transacción antes de que llamen a este SP. Debemos hacer
			-- un rollback solo de las modificaciones que hicimos en este SP

			-- Vemos XACT_STATE y los posibles resultados son 0, 1, or -1.
			-- Si es 1, la transacción es válida y se puede hacer un comit. Pero como 
			-- estamos en el CATCH no hacemos comit.
			-- Si es -1 la transacción no es válida y se debe hacer un rollback
			-- Si es - Significa que no hay un transacción y que un rollback causaría un error
			-- Ver http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() <> -1
				-- Si la transacción es todavía válida, hacemos un rollback hasta el punto
				-- de restauración definido anteriormente.  
				-- Sólo podemos hacer un rollback si XACT_STATE() = -1
				-- OJO: Este es el mismo nombre utilizado anterioremente!!  
				ROLLBACK TRANSACTION UpdateManagerPS;

				-- Si la transaccion no es válida no se puede hacer un commit ni un rollback, 
				-- por lo que un rollback al punto de restauración no es permitido por que 
				-- el rollback al punto de restauración escribiría en el log de la base de 
				-- datos.  Símplemente debemos retornar al que nos llamó y este será 
				-- responsable de hacer rollback a la transacción. 

		-- Luego de hacer el rollback correspondiente, debemos propagar la información de error
		-- al SP que nos llamó. 
		--
		-- Ver http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH
END


GO
/****** Object:  StoredProcedure [dbo].[usp_TSK_UpdateTaskRecord]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TSK_UpdateTaskRecord]
	@varTaskName AS VARCHAR(50),
	@varTaskDescription AS VARCHAR(50),
	@dtStartDate AS DATETIME,
	@dtEndDate AS DATETIME,
	@longPeriodLength as BIGINT,
	@intIterations AS int,
	@boolEnabled as bit,
	@intIterationsExec as int,
	@dtLastExDate as DATETIME,
	@varTaskId AS VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @varFinalTaskName AS VARCHAR(50);
	DECLARE @varFinalTaskDescription AS VARCHAR(50);

	IF(@varTaskName = '')
		SELECT @varFinalTaskName = NULL 
	ELSE
		SELECT @varFinalTaskName = @varTaskName
		
	IF(@varTaskDescription = '')
		SELECT @varFinalTaskDescription = NULL 
	ELSE
		SELECT @varFinalTaskDescription = @varTaskDescription
	
	-- Detectamos si el SP fue llamado desde una transacción activa y 
	-- la guardamos para usarla más tarde.  En el SP, @TranCounter = 0
	-- significa que no existen transacciones activas y que este SP
	-- comenzó una.  @TranCounter > 0 significa que se inició una transacción
	-- antes de la que empezaremos en este SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;

	IF @TranCounter > 0
		-- Se llamó a este SP cuando ya existe una transacción activa.
		-- Creamos un punto de restauración para poder hacer sólo rollback
		-- de esta transacción si hay algún error.
		-- OJO:  Este nombre tiene que cambiarse!!!  Debe ser único para la 
		-- cadena de transacciones.  También debe cambiarse al final del SP!!!
		SAVE TRANSACTION UpdateTaskPS;
	ELSE
		-- Este SP comienza su propia transacción y no hay otra antes
		BEGIN TRANSACTION;
	BEGIN TRY
	
		UPDATE [dbo].[tbl_TSK_Task]
	    SET [TaskName] = @varFinalTaskName
		  ,[TaskDescription] = @varFinalTaskDescription
		  ,[StartDate] = @dtStartDate
		  ,[EndDate] = @dtEndDate
		  ,[PeriodLengthSeconds] = @longPeriodLength
		  ,[Iterations] = @intIterations
		  ,[Enabled] = @boolEnabled
		  ,[IterationsExecuted] = @intIterationsExec
		  ,[LastExecutionDate] = @dtLastExDate
		WHERE 
			[taskId] = @varTaskId
	
	-- Llegamos aquí si no hay errores;  debemos hacer un commit de la transacción
		-- que comenzamos, pero no debemos hacer un comit si hubo una transacción
		-- comenzada anteriormente.
		IF @TranCounter = 0
			-- @TranCounter = 0 significa que no se comenzó ninguna transacción antes de 
			-- esta transacción y por lo tando debemos hacer un comit de nuestra 
			-- stranacción.
			COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH

		-- Hubo un error. Debemos detemrinar que tipo de rollback debemos hacer.

		IF @TranCounter = 0
			-- Tenemos sólo la transacción que comenzamos en este SP.  Rollback
			-- toda la transacción.
			ROLLBACK TRANSACTION;
		ELSE
			-- Se comenzó una transacción antes de que llamen a este SP. Debemos hacer
			-- un rollback solo de las modificaciones que hicimos en este SP

			-- Vemos XACT_STATE y los posibles resultados son 0, 1, or -1.
			-- Si es 1, la transacción es válida y se puede hacer un comit. Pero como 
			-- estamos en el CATCH no hacemos comit.
			-- Si es -1 la transacción no es válida y se debe hacer un rollback
			-- Si es - Significa que no hay un transacción y que un rollback causaría un error
			-- Ver http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() <> -1
				-- Si la transacción es todavía válida, hacemos un rollback hasta el punto
				-- de restauración definido anteriormente.  
				-- Sólo podemos hacer un rollback si XACT_STATE() = -1
				-- OJO: Este es el mismo nombre utilizado anterioremente!!  
				ROLLBACK TRANSACTION UpdateTaskPS;

				-- Si la transaccion no es válida no se puede hacer un commit ni un rollback, 
				-- por lo que un rollback al punto de restauración no es permitido por que 
				-- el rollback al punto de restauración escribiría en el log de la base de 
				-- datos.  Símplemente debemos retornar al que nos llamó y este será 
				-- responsable de hacer rollback a la transacción. 

		-- Luego de hacer el rollback correspondiente, debemos propagar la información de error
		-- al SP que nos llamó. 
		--
		-- Ver http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH
END


GO
/****** Object:  StoredProcedure [dbo].[usp_VIEWSTATE_ExpireViewState]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vladimir Calderon
-- Create date: November 16 2011
-- Description:	Function that deletes all viewstates that have expired
-- =============================================
CREATE PROCEDURE [dbo].[usp_VIEWSTATE_ExpireViewState] 
AS
BEGIN
      SET NOCOUNT ON
      DELETE FROM dbo.tbl_ViewState
       WHERE GETUTCDATE() > DATEADD(minute, Timeout, LastAccessed)
END


GO
/****** Object:  StoredProcedure [dbo].[usp_VIEWSTATE_GetViewState]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vladimir Calderon
-- Create date: November 16 2011
-- Description:	Obtains a viewstate by GUID
-- =============================================
CREATE PROCEDURE [dbo].[usp_VIEWSTATE_GetViewState] (@viewStateId UNIQUEIDENTIFIER) AS
      SET NOCOUNT ON
      DECLARE @textPtr VARBINARY(16)
      DECLARE @length INT
     
      UPDATE dbo.tbl_ViewState
         SET LastAccessed = GETUTCDATE(),
             @length = DATALENGTH(Value)
       WHERE ViewStateId = @viewStateId
     
      IF @length IS NOT NULL BEGIN
             SELECT @length AS Length, Value FROM tbl_ViewState WHERE ViewStateId = @viewStateId
      END
     
      RETURN 0


GO
/****** Object:  StoredProcedure [dbo].[usp_VIEWSTATE_SetViewState]    Script Date: 12/4/2016 4:39:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vladimir Calderon
-- Create date: November 16 2011
-- Description:	Sets the viewstate for a session
-- =============================================
CREATE PROCEDURE [dbo].[usp_VIEWSTATE_SetViewState] (
	@viewStateId UNIQUEIDENTIFIER, 
	@value IMAGE, 
	@timeout INT = 180
) 
AS
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Detectamos si el SP fue llamado desde una transacción activa y 
	-- la guardamos para usarla más tarde.  En el SP, @TranCounter = 0
	-- significa que no existen transacciones activas y que este SP
	-- comenzó una.  @TranCounter > 0 significa que se inició una transacción
	-- antes de la que empezaremos en este SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;

	IF @TranCounter > 0
		-- Se llamó a este SP cuando ya existe una transacción activa.
		-- Creamos un punto de restauración para poder hacer sólo rollback
		-- de esta transacción si hay algún error.
		-- OJO:  Este nombre tiene que cambiarse!!!  Debe ser único para la 
		-- cadena de transacciones.  También debe cambiarse al final del SP!!!
		SAVE TRANSACTION VIEWSTATESetViewState;
	ELSE
		-- Este SP comienza su propia transacción y no hay otra antes
		BEGIN TRANSACTION;
	
	BEGIN TRY
	
      IF @viewStateId IS NULL BEGIN
		RAISERROR ('Received NULL viewstate ID', -- Message text.
               16, -- Severity.
               1 -- State.
               );
      END ELSE IF @timeout < 1 BEGIN
		RAISERROR ('Received timeout less than one', -- Message text.
               16, -- Severity.
               1 -- State.
               );
      END ELSE IF @value IS NULL BEGIN
		RAISERROR ('Received NULL viewstate ID', -- Message text.
               16, -- Severity.
               1 -- State.
               );
      END
      IF EXISTS(SELECT * FROM tbl_ViewState WHERE ViewStateId = @viewStateID) BEGIN 
             UPDATE dbo.tbl_ViewState
                SET LastAccessed = GETUTCDATE()
                       ,Value = @value
              WHERE ViewStateID = @viewStateId
      END ELSE BEGIN
             INSERT INTO dbo.tbl_ViewState (ViewStateId, Value, LastAccessed, Timeout) VALUES (@viewStateId, @value, GETUTCDATE(), @timeout)
      END
       
      IF @TranCounter = 0
			COMMIT TRANSACTION;

      RETURN 0
	END TRY
	BEGIN CATCH

		-- Hubo un error. Debemos detemrinar que tipo de rollback debemos hacer.

		IF @TranCounter = 0
			-- Tenemos sólo la transacción que comenzamos en este SP.  Rollback
			-- toda la transacción.
			ROLLBACK TRANSACTION;
		ELSE
			-- Se comenzó una transacción antes de que llamen a este SP. Debemos hacer
			-- un rollback solo de las modificaciones que hicimos en este SP

			-- Vemos XACT_STATE y los posibles resultados son 0, 1, or -1.
			-- Si es 1, la transacción es válida y se puede hacer un comit. Pero como 
			-- estamos en el CATCH no hacemos comit.
			-- Si es -1 la transacción no es válida y se debe hacer un rollback
			-- Si es - Significa que no hay un transacción y que un rollback causaría un error
			-- Ver http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() <> -1
				-- Si la transacción es todavía válida, hacemos un rollback hasta el punto
				-- de restauración definido anteriormente.  
				-- Sólo podemos hacer un rollback si XACT_STATE() = -1
				-- OJO: Este es el mismo nombre utilizado anterioremente!!  
				ROLLBACK TRANSACTION VIEWSTATESetViewState;

				-- Si la transaccion no es válida no se puede hacer un commit ni un rollback, 
				-- por lo que un rollback al punto de restauración no es permitido por que 
				-- el rollback al punto de restauración escribiría en el log de la base de 
				-- datos.  Símplemente debemos retornar al que nos llamó y este será 
				-- responsable de hacer rollback a la transacción. 

		-- Luego de hacer el rollback correspondiente, debemos propagar la información de error
		-- al SP que nos llamó. 
		--
		-- Ver http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH


GO
USE [master]
GO
ALTER DATABASE [KPIDB] SET  READ_WRITE 
GO
