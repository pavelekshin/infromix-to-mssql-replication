USE [CVP]
GO
/****** Object:  UserDefinedDataType [dbo].[dSettingInfo]    Script Date: 28.01.2024 19:33:31 ******/
CREATE TYPE [dbo].[dSettingInfo] FROM [varchar](1000) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[dSettingName]    Script Date: 28.01.2024 19:33:31 ******/
CREATE TYPE [dbo].[dSettingName] FROM [varchar](100) NULL
GO
/****** Object:  UserDefinedFunction [dbo].[UTF8_TO_NVARCHAR]    Script Date: 28.01.2024 19:33:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[UTF8_TO_NVARCHAR](@in VarChar(MAX))
   RETURNS NVarChar(MAX)
AS
BEGIN

   --https://jasontpenny.com/blog/2009/07/31/sql-function-to-get-nvarchar-from-utf-8-stored-in-varchar/
   --https://techcommunity.microsoft.com/t5/sql-server-blog/introducing-utf-8-support-for-sql-server/ba-p/734928

   DECLARE @out NVarChar(MAX), @i int, @c int, @c2 int, @c3 int, @nc int
 
   SELECT @i = 1, @out = ''
    
   WHILE (@i <= Len(@in))
   BEGIN
      SET @c = Ascii(SubString(@in, @i, 1))
 
      IF (@c < 128)
      BEGIN
         SET @nc = @c
         SET @i = @i + 1
      END
      ELSE IF (@c > 191 AND @c < 224)
      BEGIN
         SET @c2 = Ascii(SubString(@in, @i + 1, 1))
          
         SET @nc = (((@c & 31) * 64 /* << 6 */) | (@c2 & 63))
         SET @i = @i + 2
      END
      ELSE
      BEGIN
         SET @c2 = Ascii(SubString(@in, @i + 1, 1))
         SET @c3 = Ascii(SubString(@in, @i + 2, 1))
          
         SET @nc = (((@c & 15) * 4096 /* << 12 */) | ((@c2 & 63) * 64 /* << 6 */) | (@c3 & 63))
         SET @i = @i + 3
      END
 
      SET @out = @out + NChar(@nc)
   END
   RETURN @out
END
GO
/****** Object:  Table [dbo].[call]    Script Date: 28.01.2024 19:33:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[call](
	[callguid] [char](32) NOT NULL,
	[callstartdate] [date] NOT NULL,
	[startdatetime] [datetime] NOT NULL,
	[enddatetime] [datetime] NULL,
	[localtimezoneoffset] [smallint] NULL,
	[subsystemtypeid] [smallint] NOT NULL,
	[calltypeid] [smallint] NULL,
	[ani] [varchar](32) NULL,
	[dnis] [varchar](32) NOT NULL,
	[uui] [varchar](100) NULL,
	[iidigits] [varchar](100) NULL,
	[uid] [varchar](50) NULL,
	[numoptout] [smallint] NOT NULL,
	[numonhold] [smallint] NOT NULL,
	[numtimeout] [smallint] NOT NULL,
	[numerror] [smallint] NOT NULL,
	[numappvisited] [smallint] NOT NULL,
	[totaltransfer] [smallint] NOT NULL,
	[dbdatetime] [datetime] NOT NULL,
 CONSTRAINT [PK_call] PRIMARY KEY CLUSTERED 
(
	[callguid] ASC,
	[callstartdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tIndexStateHistory]    Script Date: 28.01.2024 19:33:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tIndexStateHistory](
	[ReglamentDate] [datetime] NOT NULL,
	[TableName] [varchar](255) NOT NULL,
	[IndexName] [varchar](255) NOT NULL,
	[StartFragmentation] [datetime] NULL,
	[EndFragmentation] [datetime] NULL,
	[BeforeAvgFragmentation] [decimal](5, 2) NOT NULL,
	[AfterAvgFragmentation] [decimal](5, 2) NULL,
	[BeforeAvgPageSpaceUsed] [decimal](5, 2) NOT NULL,
	[AfterAvgPageSpaceUsed] [decimal](5, 2) NULL,
	[PageCount] [int] NOT NULL,
	[Query] [varchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[ReglamentDate] ASC,
	[TableName] ASC,
	[IndexName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tSettings]    Script Date: 28.01.2024 19:33:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tSettings](
	[SettingID] [int] IDENTITY(1,1) NOT NULL,
	[SettingName] [dbo].[dSettingName] NOT NULL,
	[SettingValue] [dbo].[dSettingInfo] NULL,
 CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED 
(
	[SettingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tSettingsTables]    Script Date: 28.01.2024 19:33:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tSettingsTables](
	[SettingID] [int] IDENTITY(1,1) NOT NULL,
	[Source] [dbo].[dSettingInfo] NOT NULL,
	[SourceTableName] [dbo].[dSettingInfo] NOT NULL,
	[TargetTableName] [dbo].[dSettingInfo] NOT NULL,
	[ReplicationType] [dbo].[dSettingInfo] NOT NULL,
	[ReplicationOverlapSeconds] [dbo].[dSettingInfo] NOT NULL,
	[TimeConstraintColumn] [dbo].[dSettingInfo] NULL,
 CONSTRAINT [PK_tSettingsTables] PRIMARY KEY CLUSTERED 
(
	[SettingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tSyncLog]    Script Date: 28.01.2024 19:33:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tSyncLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[OperationName] [varchar](32) NOT NULL,
	[TargetTableName] [varchar](256) NOT NULL,
	[RowsProcessed] [int] NULL,
	[State] [varchar](32) NOT NULL,
	[Error] [varchar](max) NULL,
	[Query] [varchar](4000) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vxmlcustomcontent]    Script Date: 28.01.2024 19:33:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vxmlcustomcontent](
	[elementid] [bigint] NOT NULL,
	[varname] [nvarchar](51) NOT NULL,
	[varvalue] [nvarchar](255) NULL,
	[eventdatetime] [datetime] NOT NULL,
	[dbdatetime] [datetime] NOT NULL,
	[callstartdate] [date] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vxmlelement]    Script Date: 28.01.2024 19:33:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vxmlelement](
	[elementid] [bigint] NOT NULL,
	[callstartdate] [date] NOT NULL,
	[callguid] [char](32) NOT NULL,
	[sessionid] [bigint] NOT NULL,
	[elementname] [nvarchar](51) NOT NULL,
	[enterdatetime] [datetime] NOT NULL,
	[exitdatetime] [datetime] NULL,
	[elementtypeid] [smallint] NOT NULL,
	[numberofinteractions] [smallint] NULL,
	[resultid] [smallint] NULL,
	[exitstate] [nvarchar](51) NULL,
	[dbdatetime] [datetime] NOT NULL,
 CONSTRAINT [PK_vxmlelement] PRIMARY KEY CLUSTERED 
(
	[elementid] ASC,
	[callstartdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vxmlelementdetail]    Script Date: 28.01.2024 19:33:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vxmlelementdetail](
	[elementid] [bigint] NOT NULL,
	[varname] [nvarchar](51) NOT NULL,
	[varvalue] [nvarchar](255) NULL,
	[vardatatypeid] [smallint] NOT NULL,
	[actiontypeid] [smallint] NOT NULL,
	[eventdatetime] [datetime] NOT NULL,
	[dbdatetime] [datetime] NOT NULL,
	[callstartdate] [date] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vxmlsession]    Script Date: 28.01.2024 19:33:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vxmlsession](
	[sessionid] [bigint] NOT NULL,
	[callstartdate] [date] NOT NULL,
	[callguid] [char](32) NOT NULL,
	[startdatetime] [datetime] NOT NULL,
	[enddatetime] [datetime] NULL,
	[appname] [nvarchar](51) NOT NULL,
	[sessionname] [nvarchar](96) NOT NULL,
	[sourceappname] [nvarchar](51) NULL,
	[eventtypeid] [smallint] NULL,
	[causeid] [smallint] NULL,
	[localtimezoneoffset] [smallint] NULL,
	[duration] [int] NULL,
	[subsystemname] [varchar](41) NOT NULL,
	[messagebusname] [varchar](42) NOT NULL,
	[dbdatetime] [datetime] NOT NULL,
 CONSTRAINT [PK_vxmlsession] PRIMARY KEY CLUSTERED 
(
	[sessionid] ASC,
	[callstartdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [dbdatetime_call]    Script Date: 28.01.2024 19:33:31 ******/
CREATE NONCLUSTERED INDEX [dbdatetime_call] ON [dbo].[call]
(
	[dbdatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [enddatetime_call]    Script Date: 28.01.2024 19:33:31 ******/
CREATE NONCLUSTERED INDEX [enddatetime_call] ON [dbo].[call]
(
	[enddatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [filterIndex_dbdatetime_enddatetime_is_null_search]    Script Date: 28.01.2024 19:33:31 ******/
CREATE NONCLUSTERED INDEX [filterIndex_dbdatetime_enddatetime_is_null_search] ON [dbo].[call]
(
	[dbdatetime] ASC
)
INCLUDE([enddatetime]) 
WHERE ([enddatetime] IS NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [startdatetime_call]    Script Date: 28.01.2024 19:33:31 ******/
CREATE NONCLUSTERED INDEX [startdatetime_call] ON [dbo].[call]
(
	[startdatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [DateTime_tSyncLog]    Script Date: 28.01.2024 19:33:31 ******/
CREATE NONCLUSTERED INDEX [DateTime_tSyncLog] ON [dbo].[tSyncLog]
(
	[DateTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [callstartdate_vxmlcustomcontent]    Script Date: 28.01.2024 19:33:31 ******/
CREATE NONCLUSTERED INDEX [callstartdate_vxmlcustomcontent] ON [dbo].[vxmlcustomcontent]
(
	[callstartdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [dbdatetime_vxmlcustomcontent]    Script Date: 28.01.2024 19:33:31 ******/
CREATE NONCLUSTERED INDEX [dbdatetime_vxmlcustomcontent] ON [dbo].[vxmlcustomcontent]
(
	[dbdatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [callguid_vxmlelement]    Script Date: 28.01.2024 19:33:31 ******/
CREATE NONCLUSTERED INDEX [callguid_vxmlelement] ON [dbo].[vxmlelement]
(
	[callguid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [dbdatetime_vxmlelement]    Script Date: 28.01.2024 19:33:31 ******/
CREATE NONCLUSTERED INDEX [dbdatetime_vxmlelement] ON [dbo].[vxmlelement]
(
	[dbdatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [enterdatetime_vxmlelement]    Script Date: 28.01.2024 19:33:31 ******/
CREATE NONCLUSTERED INDEX [enterdatetime_vxmlelement] ON [dbo].[vxmlelement]
(
	[enterdatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [sessionid_vxmlelement]    Script Date: 28.01.2024 19:33:31 ******/
CREATE NONCLUSTERED INDEX [sessionid_vxmlelement] ON [dbo].[vxmlelement]
(
	[sessionid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [callstartdate_vxmlelementdetail]    Script Date: 28.01.2024 19:33:31 ******/
CREATE NONCLUSTERED INDEX [callstartdate_vxmlelementdetail] ON [dbo].[vxmlelementdetail]
(
	[callstartdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [dbdatetime_vxmlelementdetail]    Script Date: 28.01.2024 19:33:31 ******/
CREATE NONCLUSTERED INDEX [dbdatetime_vxmlelementdetail] ON [dbo].[vxmlelementdetail]
(
	[dbdatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [elementid_vxmlelementdetail]    Script Date: 28.01.2024 19:33:31 ******/
CREATE NONCLUSTERED INDEX [elementid_vxmlelementdetail] ON [dbo].[vxmlelementdetail]
(
	[elementid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [eventdatetime_vxmlelementdetail]    Script Date: 28.01.2024 19:33:31 ******/
CREATE NONCLUSTERED INDEX [eventdatetime_vxmlelementdetail] ON [dbo].[vxmlelementdetail]
(
	[eventdatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [filterIndex_varname_search_elementid_varvalue_callstartdate]    Script Date: 28.01.2024 19:33:31 ******/
CREATE NONCLUSTERED INDEX [filterIndex_varname_search_elementid_varvalue_callstartdate] ON [dbo].[vxmlelementdetail]
(
	[varname] ASC
)
INCLUDE([elementid],[varvalue],[callstartdate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [appname_vxmlsession]    Script Date: 28.01.2024 19:33:31 ******/
CREATE NONCLUSTERED INDEX [appname_vxmlsession] ON [dbo].[vxmlsession]
(
	[appname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [callguid_vxmlsession]    Script Date: 28.01.2024 19:33:31 ******/
CREATE NONCLUSTERED INDEX [callguid_vxmlsession] ON [dbo].[vxmlsession]
(
	[callguid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [dbdatetime_vxmlsession]    Script Date: 28.01.2024 19:33:31 ******/
CREATE NONCLUSTERED INDEX [dbdatetime_vxmlsession] ON [dbo].[vxmlsession]
(
	[dbdatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [filterIndex_dbdatetime_enddatetime_is_null_search]    Script Date: 28.01.2024 19:33:31 ******/
CREATE NONCLUSTERED INDEX [filterIndex_dbdatetime_enddatetime_is_null_search] ON [dbo].[vxmlsession]
(
	[dbdatetime] ASC
)
INCLUDE([enddatetime]) 
WHERE ([enddatetime] IS NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [startdatetime_vxmlsession]    Script Date: 28.01.2024 19:33:31 ******/
CREATE NONCLUSTERED INDEX [startdatetime_vxmlsession] ON [dbo].[vxmlsession]
(
	[startdatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [dbo].[call] ADD  DEFAULT ((0)) FOR [numoptout]
GO
ALTER TABLE [dbo].[call] ADD  DEFAULT ((0)) FOR [numonhold]
GO
ALTER TABLE [dbo].[call] ADD  DEFAULT ((0)) FOR [numtimeout]
GO
ALTER TABLE [dbo].[call] ADD  DEFAULT ((0)) FOR [numerror]
GO
ALTER TABLE [dbo].[call] ADD  DEFAULT ((0)) FOR [numappvisited]
GO
ALTER TABLE [dbo].[call] ADD  DEFAULT ((0)) FOR [totaltransfer]
GO
/****** Object:  StoredProcedure [dbo].[sCleanupIndexStateHistoryTable]    Script Date: 28.01.2024 19:33:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sCleanupIndexStateHistoryTable]
as
begin
set nocount on

	declare 
		@IndexStateHistoryTableCleanup_Age [dbo].[dSettingInfo],
		@RowsProcessed int = 0,
		@RowCount int,
		@StateExecute varchar(32) = null,
		@ErrorExecute varchar(max) = null,
		@SQL nvarchar(4000),
		@IndexStateHistoryTableCleanup_Date datetime,
		@TargetTableName varchar(32) = 'dbo.tIndexStateHistory'


	select top 1 
		@IndexStateHistoryTableCleanup_Age = convert(int, SettingValue)
	from
		tSettings
	where
		SettingName = 'IndexStateHistoryTableCleanup_Age'

	if (@IndexStateHistoryTableCleanup_Age is null) 
		set @IndexStateHistoryTableCleanup_Age = 30


	set @IndexStateHistoryTableCleanup_Date = DATEADD(DAY,-1 * @IndexStateHistoryTableCleanup_Age,GETDATE())
	
	begin
		set @SQL = 
			' delete from ' + @TargetTableName + ' where ReglamentDate < ' + '''' + convert(nvarchar(10),@IndexStateHistoryTableCleanup_Date,121) + '''';

		begin transaction
		begin try
		begin
			exec sp_executesql @SQL
			select @RowCount = @@rowcount
		
			if(@RowCount = 0)
				set @StateExecute = 'Success'	
			set @RowsProcessed = @RowsProcessed + @RowCount
		end
		end try

		begin catch
			set @StateExecute = 'Fault'
			set @ErrorExecute = 
				'error_procedure: [dbo].[sCleanupIndexStateHistoryTable]; ' + 
				'error_line: ' + isnull(convert(varchar, error_line()),'') + '; ' +
				'error_message: ' + isnull(error_message(),'');
			rollback transaction
		end catch	
		
		if @@trancount > 0
		begin
			set @StateExecute = 'Success'
			commit transaction
		end

		insert into 
			tSyncLog ([DateTime], [OperationName], [TargetTableName], [RowsProcessed], [State], [Error], [Query])
		values
			(getdate(), 'Cleanup', convert(varchar(256), @TargetTableName), @RowsProcessed, @StateExecute, @ErrorExecute, @SQL)

		end			
	end

GO
/****** Object:  StoredProcedure [dbo].[sCleanupReportTables]    Script Date: 28.01.2024 19:33:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sCleanupReportTables]
as
begin
set nocount on

	declare 
		@TargetTableName [dbo].[dSettingInfo],
		@ReplicationType [dbo].[dSettingInfo],
		@ReportTablesCleanup_Age [dbo].[dSettingInfo],
		@RowsDeletePerTime [dbo].[dSettingInfo],
		@RowsProcessed int = 0,
		@RowCount int,
		@StateExecute varchar(32) = null,
		@ErrorExecute varchar(max) = null,
		@SQL nvarchar(4000),
		@ReportTablesCleanup_Date datetime


	declare SettingsTablesCursor cursor 
	read_only
	local
	static
	forward_only
	for
		select
			st.TargetTableName, st.ReplicationType
		from 
			tSettingsTables st
		where 
			st.ReplicationType != 'NoReplication'

	open SettingsTablesCursor

	select top 1
		@ReportTablesCleanup_Age = convert(int, SettingValue)
	from
		tSettings
	where
		SettingName = 'ReportTablesCleanup_Age' 

	select top 1
		@RowsDeletePerTime = SettingValue
	from
		tSettings
	where
		SettingName = 'RowsDeletePerTime'


	if (@ReportTablesCleanup_Age is null) 
		set @ReportTablesCleanup_Age = 60

	if (@RowsDeletePerTime is null)
		set @RowsDeletePerTime = '50000'

	set @ReportTablesCleanup_Date = DATEADD(DAY,-1 * @ReportTablesCleanup_Age,GETDATE())
	
	fetch next
	from 
		SettingsTablesCursor
	into 
		@TargetTableName, @ReplicationType;

	while @@fetch_status = 0 
	begin
		
	if(@ReplicationType = 'Incremental')
		begin
			set @RowsProcessed = 0
			set @SQL = 
				' delete top(' + @RowsDeletePerTime + ') from ' + @TargetTableName + ' where callstartdate < ' + '''' + convert(nvarchar(10),@ReportTablesCleanup_Date,121) + '''';

			begin try
				while(1 = 1)
				begin

					begin transaction

					exec sp_executesql @SQL
					select @RowCount = @@rowcount
			
					if @@trancount > 0
						commit transaction
					
					if(@RowCount = 0)
					begin
						set @StateExecute = 'Success'
						break
					end
					set @RowsProcessed = @RowsProcessed + @RowCount
				end
			end try
		
			begin catch
				set @StateExecute = 'Fault'
				set @ErrorExecute = 
					'error_procedure: [dbo].[sCleanupReportTables]; ' + 
					'error_line: ' + isnull(convert(varchar, error_line()),'') + '; ' +
					'error_message: ' + isnull(error_message(),'');
			
				if @@trancount > 0
					rollback transaction
			end catch	

			insert into 
				tSyncLog ([DateTime], [OperationName], [TargetTableName], [RowsProcessed], [State], [Error], [Query])
			values
				(getdate(), 'Cleanup', convert(varchar(256), @TargetTableName), @RowsProcessed, @StateExecute, @ErrorExecute, @SQL)

		end
		
		fetch next
		from 
			SettingsTablesCursor
		into 
			@TargetTableName, @ReplicationType;
		
	end
	
	close SettingsTablesCursor
	deallocate SettingsTablesCursor
end
GO
/****** Object:  StoredProcedure [dbo].[sCleanupSyncLogTable]    Script Date: 28.01.2024 19:33:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sCleanupSyncLogTable]
as
begin
set nocount on

	declare 
		@SyncLogTableCleanup_Age [dbo].[dSettingInfo],
		@RowsProcessed int = 0,
		@RowCount int,
		@StateExecute varchar(32) = null,
		@ErrorExecute varchar(max) = null,
		@SQL nvarchar(4000),
		@SyncLogTableCleanup_Date datetime,
		@TargetTableName varchar(32) = 'dbo.tSyncLog'


	select top 1 
		@SyncLogTableCleanup_Age = convert(int, SettingValue)
	from
		tSettings
	where
		SettingName = 'SyncLogTableCleanup_Age'

	if (@SyncLogTableCleanup_Age is null) 
		set @SyncLogTableCleanup_Age = 30


	set @SyncLogTableCleanup_Date = DATEADD(DAY,-1 * @SyncLogTableCleanup_Age,GETDATE())
	
	begin
		set @SQL = 
			' delete from ' + @TargetTableName + ' where DateTime < ' + '''' + convert(nvarchar(10),@SyncLogTableCleanup_Date,121) + '''';

		begin transaction
		begin try
		begin
			exec sp_executesql @SQL
			select @RowCount = @@rowcount
		
			if(@RowCount = 0)
				set @StateExecute = 'Success'
		
			set @RowsProcessed = @RowsProcessed + @RowCount
		end
		end try
		

		begin catch
			set @StateExecute = 'Fault'
			set @ErrorExecute = 
				'error_procedure: [dbo].[sSyncTablesIncremental]; ' + 
				'error_line: ' + isnull(convert(varchar, error_line()),'') + '; ' +
				'error_message: ' + isnull(error_message(),'');
			rollback transaction
		end catch	
		

		if @@trancount > 0
		begin
			set @StateExecute = 'Success'
			commit transaction
		end

		insert into 
			tSyncLog ([DateTime], [OperationName], [TargetTableName], [RowsProcessed], [State], [Error], [Query])
		values
			(getdate(), 'Cleanup', convert(varchar(256), @TargetTableName), @RowsProcessed, @StateExecute, @ErrorExecute, @SQL)

		end			
	end

GO
/****** Object:  StoredProcedure [dbo].[sOnReglamentIndex]    Script Date: 28.01.2024 19:33:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sOnReglamentIndex]
    @MinFragmentation int = 8,
    @MaxFragmentation int = 30
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @ReglamentDate DATETIME = GETDATE()

	--- Перестройка индексов
	INSERT INTO tIndexStateHistory (ReglamentDate
						,TableName
						,IndexName
						,BeforeAvgFragmentation
						,BeforeAvgPageSpaceUsed
						,[PageCount])
	SELECT	@ReglamentDate AS ReglamentDate
		   ,OBJECT_NAME(ifp.object_id) AS TableName
		   ,i.name AS IndexName
		   ,ifp.avg_fragmentation_in_percent AS BeforeAvgFragmentation
		   ,ifp.avg_page_space_used_in_percent AS BeforeAvgPageSpaceUsed
		   ,ifp.page_count AS [PageCount]
	FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'SAMPLED') ifp
	INNER JOIN sys.indexes i WITH(NOLOCK)
	ON	(ifp.OBJECT_ID = i.OBJECT_ID AND ifp.index_id = i.index_id)
	AND	ifp.database_id = DB_ID()
	AND	ifp.index_type_desc IN ('CLUSTERED INDEX', 'NONCLUSTERED INDEX')
	AND ifp.alloc_unit_type_desc = 'IN_ROW_DATA'

	DECLARE @Script NVARCHAR(MAX)
	DECLARE @TableName VARCHAR(255)
	DECLARE @IndexName VARCHAR(255)

    --Проверим только процент фрагментации BeforeAvgFragmentation
	DECLARE cIndex CURSOR 
	read_only
	local
	static
	forward_only
	FOR
		SELECT	CASE 
					WHEN ish.BeforeAvgFragmentation >= @MaxFragmentation THEN 'ALTER INDEX [' + ish.IndexName + '] ON [' + ish.TableName + '] REBUILD WITH (SORT_IN_TEMPDB = ON, MAXDOP = 2)' 
					WHEN ish.BeforeAvgFragmentation >= @MinFragmentation AND ish.BeforeAvgFragmentation < @MaxFragmentation THEN 'ALTER INDEX [' + ish.IndexName+ '] ON [' + ish.TableName + '] REORGANIZE'
				END AS Script
				,ish.TableName
				,ish.IndexName
		FROM tIndexStateHistory ish
		WHERE ish.ReglamentDate=@ReglamentDate
			 AND ish.BeforeAvgFragmentation >= @MinFragmentation

	OPEN cIndex

	FETCH NEXT FROM cIndex INTO @Script, @TableName, @IndexName

	WHILE @@FETCH_STATUS = 0 BEGIN

		UPDATE tIndexStateHistory 
		SET StartFragmentation=GETDATE(), Query = @Script
		WHERE ReglamentDate=@ReglamentDate
		  AND TableName=@TableName
		  AND IndexName=@IndexName
	
		EXEC sys.sp_executesql @Script

		UPDATE ish SET EndFragmentation=GETDATE()
					  ,AfterAvgFragmentation=ifp.avg_fragmentation_in_percent
					  ,AfterAvgPageSpaceUsed=ifp.avg_page_space_used_in_percent
		FROM tIndexStateHistory ish
		INNER JOIN sys.indexes i WITH(NOLOCK) ON i.object_id=object_id(ish.TableName) AND i.name=ish.IndexName
		INNER JOIN sys.dm_db_index_physical_stats (DB_ID(), object_id(@TableName), NULL, NULL, 'SAMPLED') AS ifp ON i.object_id = ifp.object_id AND i.index_id = ifp.index_id
		WHERE ish.ReglamentDate=@ReglamentDate
		  AND ish.TableName=@TableName
		  AND ish.IndexName=@IndexName

		FETCH NEXT FROM cIndex INTO @Script, @TableName, @IndexName
	END

	CLOSE cIndex
	DEALLOCATE cIndex

	--- Обновление статистики (старее 7 дней)

	DECLARE @DateNow DATE = DATEADD(dd, -7, GETDATE())

	SET @Script=''

	SELECT @Script+='UPDATE STATISTICS [' + SCHEMA_NAME(o.[schema_id]) + '].[' + o.name + '] [' + s.name + '] WITH FULLSCAN' + CASE WHEN s.no_recompute = 1 THEN ', NORECOMPUTE' ELSE '' END + CHAR(13)
	FROM sys.stats s WITH(NOLOCK)
	JOIN sys.objects o WITH(NOLOCK) ON s.[object_id] = o.[object_id]
	WHERE o.[type] IN ('U', 'V')
		AND o.is_ms_shipped = 0
		AND ISNULL(STATS_DATE(s.[object_id], s.stats_id), GETDATE()) < @DateNow

	EXEC sys.sp_executesql @Script

END
GO
/****** Object:  StoredProcedure [dbo].[sQueryGetColumns]    Script Date: 28.01.2024 19:33:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sQueryGetColumns]
@TargetTableName [dbo].[dSettingInfo],
@QueryColumns VARCHAR(4000) OUTPUT

as
begin
	set nocount on

	declare @ColumnName varchar(100)

	begin
		declare TablesCursor cursor 
		read_only
		local
		static
		forward_only
		for 

		select name
		from sys.all_columns
			where object_id = OBJECT_ID(@TargetTableName); 

		open TablesCursor
		fetch next from TablesCursor into @ColumnName
		while @@fetch_status = 0  
		begin
			if lower(@ColumnName) = 'varvalue' and @TargetTableName = 'dbo.vxmlelementdetail'
				set @QueryColumns = concat(@QueryColumns, 'dbo.UTF8_TO_NVARCHAR(src.', @ColumnName, ') ', 'as ', @ColumnName, ',')
			else
				set @QueryColumns = concat(@QueryColumns, 'src.', @ColumnName, ',')
			fetch next from TablesCursor into @ColumnName
		end 
	close TablesCursor  
	deallocate TablesCursor

	if len(@QueryColumns) > 1
		set @QueryColumns = left(@QueryColumns, len(@QueryColumns)-1)
	end
end
GO
/****** Object:  StoredProcedure [dbo].[sQueryGetParameters]    Script Date: 28.01.2024 19:33:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sQueryGetParameters]
@TargetTableName [dbo].[dSettingInfo],
@QueryParameters VARCHAR(4000) OUTPUT

as
begin
	set nocount on

	declare @ColumnName varchar(100),
			@is_nullable bit

	if exists(
		select col_name(ic.object_id,ic.column_id) as ColumnName
		from    sys.indexes as i INNER JOIN 
				sys.index_columns as ic on  i.object_id = ic.object_id
					and i.index_id = ic.index_id
					where   i.is_primary_key = 1
					and i.object_id = object_id(@TargetTableName))
	begin
		declare TablesCursor cursor 
		read_only
		local
		static
		forward_only
		for 

		select  col_name(ic.object_id,ic.column_id) as ColumnName
		from    sys.indexes as i INNER JOIN 
				sys.index_columns as ic on  i.object_id = ic.object_id
					and i.index_id = ic.index_id
					where   i.is_primary_key = 1
					and i.object_id = object_id(@TargetTableName)

		open TablesCursor
		fetch next from TablesCursor into @ColumnName  
		while @@fetch_status = 0  
		begin  
			set @QueryParameters =  concat(@QueryParameters, 'src.', @ColumnName, ' = ', 'dst.', @ColumnName, ' AND ')
			fetch next from TablesCursor into @ColumnName 
		end 
		close TablesCursor  
		deallocate TablesCursor

		if len(@QueryParameters) > 3
			set @QueryParameters = left(@QueryParameters, len(@QueryParameters)-3)
	end
	else
		begin
			declare TablesCursor cursor 
			read_only
			local
			static
			forward_only
			for 

			select name, is_nullable
			from sys.all_columns
				where object_id = OBJECT_ID(@TargetTableName); 

			open TablesCursor
			fetch next from TablesCursor into @ColumnName, @is_nullable
			while @@fetch_status = 0  
			begin  
				if lower(@ColumnName) like '%datetime%'
					set @QueryParameters =  concat(@QueryParameters, 'convert(datetime,src.', @ColumnName, ') = ', 'dst.', @ColumnName, ' AND ')
				else if @is_nullable = 1
					begin
						if lower(@ColumnName) = 'varvalue' and @TargetTableName = 'dbo.vxmlelementdetail'
							set @QueryParameters = concat(@QueryParameters, '((dbo.UTF8_TO_NVARCHAR(src.', @ColumnName, ') = ', 'dst.', @ColumnName, ')' , ' OR (src.',@ColumnName,' is null AND dst.',@ColumnName,' is null)) AND ')
						else
							set @QueryParameters = concat(@QueryParameters, '((src.', @ColumnName, ' = ', 'dst.', @ColumnName, ')' , ' OR (src.',@ColumnName,' is null AND dst.',@ColumnName,' is null)) AND ')
					end
				else
					set @QueryParameters =  concat(@QueryParameters, 'src.', @ColumnName, ' = ', 'dst.', @ColumnName, ' AND ')

				fetch next from TablesCursor into @ColumnName, @is_nullable
		end 
		close TablesCursor  
		deallocate TablesCursor

		if len(@QueryParameters) > 3
			set @QueryParameters = left(@QueryParameters, len(@QueryParameters)-3)
	end
end

GO
/****** Object:  StoredProcedure [dbo].[sSettingsTableUpdate]    Script Date: 28.01.2024 19:33:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sSettingsTableUpdate] (@value dSettingInfo, @name dSettingName)
as
begin
	UPDATE [dbo].[tSettings]
		set SettingValue = @value
	where
		SettingName = @name
end
GO
/****** Object:  StoredProcedure [dbo].[sSyncReportTables]    Script Date: 28.01.2024 19:33:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sSyncReportTables]
as
begin
set nocount on

	declare 
		@Source varchar(32),
		@SourceTableName varchar(256),
		@TargetTableName [dbo].[dSettingInfo],
		@ReplicationType [dbo].[dSettingInfo],
		@CVP_Source [dbo].[dSettingInfo],
		@RowsCopyPerTime int = null,
		@ReplicationOverlapSeconds int = null,
		@CVP_Path varchar(32) = 'LinkedServer_Source';




	declare SettingsTablesCursor cursor 
	read_only
	local
	static
	forward_only
	for
		select
			st.Source, st.SourceTableName, st.TargetTableName, st.ReplicationType, st.ReplicationOverlapSeconds
		from 
			tSettingsTables st
		where 
			st.ReplicationType != 'NoReplication'

	open SettingsTablesCursor

	select top 1 
		@RowsCopyPerTime = convert(int, SettingValue)
	from
		tSettings
	where
		SettingName = 'RowsCopyPerTime'


	if (@RowsCopyPerTime is null) 
		set @RowsCopyPerTime = 50000

	select top 1 
		@CVP_Source = SettingValue
	from
		tSettings
	where
		SettingName = @CVP_Path

	fetch next
	from 
		SettingsTablesCursor
	into 
		@Source, @SourceTableName, @TargetTableName, @ReplicationType, @ReplicationOverlapSeconds;

	while @@fetch_status = 0 
	begin
		set @Source =
			replace(@Source,
			'<LinkedServer_Source>', @CVP_Source)
			
		if(@ReplicationType = 'Incremental')
		begin
			exec dbo.sSyncTablesIncremental 
				@Source,
				@SourceTableName,
				@TargetTableName,
				@RowsCopyPerTime,
				@ReplicationOverlapSeconds
		end
		else
		if(@ReplicationType = 'Update')
		begin
			exec dbo.sSyncTablesUpdate 
				@Source,
				@SourceTableName,
				@TargetTableName,
				@RowsCopyPerTime
		end
		
		fetch next
		from 
			SettingsTablesCursor
		into 
			@Source, @SourceTableName, @TargetTableName, @ReplicationType, @ReplicationOverlapSeconds;
		
	end
	
	close SettingsTablesCursor
	deallocate SettingsTablesCursor
end
GO
/****** Object:  StoredProcedure [dbo].[sSyncTablesIncremental]    Script Date: 28.01.2024 19:33:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sSyncTablesIncremental]
@Source [dbo].[dSettingInfo],
@SourceTableName [dbo].[dSettingInfo],
@TargetTableName [dbo].[dSettingInfo],
@RowsCopyPerTime int,
@ReplicationOverlapSeconds int
as
begin
set nocount on
	declare 
		@RowsProcessed int = 0,
		@StateExecute varchar(32) = null,
		@ErrorExecute varchar(max) = null,
		@RowCount int,
		@LinkedServer nvarchar(64),
		@OPENQUERY nvarchar(4000),
		@SQL nvarchar(4000),
		@callstartdate nvarchar(10),
		@dbdatetime nvarchar(23),
		@QueryParameters varchar(4000),
		@QueryColumns varchar(4000),
		@BackwardRowCopySearch int

	set @BackwardRowCopySearch = 1.5 * @RowsCopyPerTime

	set @LinkedServer = '[' + @Source + ']';

	set @SQL = 
		'select 
			@dbdatetime = convert(varchar(23),max(dbdatetime),121) 
		from ' + @TargetTableName

	exec sp_executesql
		@SQL, 
		N'@dbdatetime nvarchar(23) OUTPUT',
		@dbdatetime = @dbdatetime output;

	if(@dbdatetime is not null)
		set @dbdatetime =  convert(varchar(23),DATEADD(SS, -1 * @ReplicationOverlapSeconds, @dbdatetime), 121) 
	else
		set @dbdatetime = '1990-01-01 00:00:00.000'
	
	set @callstartdate =  convert(varchar(10), cast(@dbdatetime as date)) 

	exec dbo.sQueryGetParameters @TargetTableName, @QueryParameters = @QueryParameters OUTPUT
	exec dbo.sQueryGetColumns @TargetTableName, @QueryColumns = @QueryColumns OUTPUT

	set @OPENQUERY = 
		' INSERT INTO ' + @TargetTableName + 
		' SELECT ' + @QueryColumns + ' FROM OPENQUERY('+ @LinkedServer + ',''' +
						' SELECT FIRST ' + convert(varchar, @RowsCopyPerTime) +  '	*  FROM ' + @SourceTableName + 
						' WHERE callstartdate >= ' + 'TO_DATE("' + @callstartdate + '", "%Y-%m-%d")' + 
						' AND dbdatetime >= ' + 'TO_DATE("' + @dbdatetime + '","%Y-%m-%d %H:%M:%S.%F3")' + ' ORDER BY dbdatetime ASC'') src' +
						' WHERE NOT EXISTS ( ' +
						' SELECT * FROM ( ' +
						' SELECT TOP ' + convert(varchar, @BackwardRowCopySearch) +  ' * FROM ' + @TargetTableName + ' ORDER BY dbdatetime DESC) dst ' +
						' WHERE ' + @QueryParameters + ' ) '
		
	begin transaction
	begin try
		exec sp_executesql @OPENQUERY
		select @RowCount = @@rowcount
		set @RowsProcessed = @RowsProcessed + @RowCount
	end try
	
	begin catch
		set @StateExecute = 'Fault'
		set @ErrorExecute = 
			'error_procedure: [dbo].[sSyncTablesIncremental]; ' + 
			'error_line: ' + isnull(convert(varchar, error_line()),'') + '; ' +
			'error_message: ' + isnull(error_message(),'');

		rollback transaction
	end catch
		
		
	if @@trancount > 0
	begin
		set @StateExecute = 'Success'
		commit transaction
	end

	insert into 
		tSyncLog ([DateTime], [OperationName], [TargetTableName], [RowsProcessed], [State], [Error], [Query])
	values
		(getdate(), 'IncrementalSync', convert(varchar(256), @TargetTableName), @RowsProcessed, @StateExecute, @ErrorExecute, @OPENQUERY)
END
GO
/****** Object:  StoredProcedure [dbo].[sSyncTablesUpdate]    Script Date: 28.01.2024 19:33:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sSyncTablesUpdate]
@Source [dbo].[dSettingInfo],
@SourceTableName [dbo].[dSettingInfo],
@TargetTableName [dbo].[dSettingInfo],
@RowsCopyPerTime int = 10000
as
begin
set nocount on
	
	declare 
		@RowsProcessed int = 0,
		@StateExecute varchar(32) = null,
		@ErrorExecute varchar(max) = null,
		@RowCount int,
		@LinkedServer nvarchar(64),
		@OPENQUERY nvarchar(4000),
		@SQL nvarchar(4000),
		@callstartdate nvarchar(10),
		@dbdatetime nvarchar(23),
		@LastDbdatetimeInUpdate nvarchar(23),
		@ParameterName varchar(100)



	set @LinkedServer = '[' + @Source + ']';

	select top 1 
		@LastDbdatetimeInUpdate = convert(nvarchar(23), SettingValue)
	from
		tSettings
	where
		SettingName = 'LastDbdatetimeInUpdate_' + @TargetTableName

	if(@TargetTableName = 'dbo.vxmlsession')
		set @SQL = 
		'select 
			@dbdatetime = convert(varchar(23),max(dbdatetime),121) 
		from ' + @TargetTableName + ' where enddatetime is null '
	else
		set @SQL = 
		'select 
			@dbdatetime = convert(varchar(23),min(dbdatetime),121) 
		from ' + @TargetTableName + ' where enddatetime is null'

	exec sp_executesql
		@SQL, 
		N'@dbdatetime nvarchar(23) OUTPUT',
		@dbdatetime = @dbdatetime output;

	if @dbdatetime is null
		return 2

	if(@dbdatetime = @LastDbdatetimeInUpdate)
		begin
			if(@TargetTableName = 'dbo.vxmlsession')
				set @SQL = 
				'select 
					@dbdatetime = convert(varchar(23),min(dbdatetime),121) 
				from ' + @TargetTableName + ' where enddatetime is null and callstartdate = ' + '''' + convert(varchar(10), @LastDbdatetimeInUpdate,121) + ''''
			else
				set @SQL = 
				'select 
					@dbdatetime = convert(varchar(23),min(dbdatetime),121) 
				from ' + @TargetTableName + ' where enddatetime is null and dbdatetime <> ' + '''' + @LastDbdatetimeInUpdate + ''''

			exec sp_executesql
				@SQL, 
				N'@dbdatetime nvarchar(23) OUTPUT',
				@dbdatetime = @dbdatetime output;

			if @dbdatetime is null
				return 2
		end

	set @ParameterName = 'LastDbdatetimeInUpdate_' + @TargetTableName	
	exec dbo.sSettingsTableUpdate @value = @dbdatetime, @name = @ParameterName

	set @callstartdate =  convert(varchar(10), cast(@dbdatetime as date)) 

	if (@TargetTableName = 'dbo.call')
		set @OPENQUERY = 
			' UPDATE dst' +
			' SET dst.enddatetime = convert(datetime,src.enddatetime) ' +
			' FROM ' +  @TargetTableName + ' dst' +
			' INNER JOIN OPENQUERY('+ @LinkedServer + ',''' +
							' SELECT FIRST ' + convert(varchar, @RowsCopyPerTime) +  ' callguid, enddatetime  FROM ' + @SourceTableName + 
							' WHERE dbdatetime >= TO_DATE("' + @dbdatetime + '", "%Y-%m-%d %H:%M:%S.%F3")' +  
							' and callstartdate >= TO_DATE("' + @callstartdate + '", "%Y-%m-%d")' +  
							' AND enddatetime is not null '') src' +
			' ON dst.callguid = src.callguid ' +
			' WHERE dst.enddatetime is null '
	else if (@TargetTableName = 'dbo.vxmlsession')
		set @OPENQUERY = 
			' UPDATE dst' +
			' SET dst.enddatetime = convert(datetime,src.enddatetime), dst.duration = src.duration, dst.causeid = src.causeid, dst.eventtypeid = src.eventtypeid ' +
			' FROM ' +  @TargetTableName + ' dst' +
			' INNER JOIN OPENQUERY('+ @LinkedServer + ',''' +
							' SELECT FIRST ' + convert(varchar, @RowsCopyPerTime) +  ' sessionid, enddatetime, duration, causeid, eventtypeid  FROM ' + @SourceTableName + 
							' WHERE dbdatetime <= TO_DATE("' + @dbdatetime + '", "%Y-%m-%d %H:%M:%S.%F3")' +  
							' AND callstartdate <= TO_DATE("' + @callstartdate + '", "%Y-%m-%d")' +  
							' AND enddatetime is not null ORDER BY dbdatetime DESC'') src' +
			' ON dst.sessionid = src.sessionid ' +
			' WHERE dst.enddatetime is null '
	else
		return -1
			
	begin transaction
	begin try
		begin
			exec sp_executesql @OPENQUERY
			select @RowCount = @@rowcount
			set @RowsProcessed = @RowsProcessed + @RowCount
		end
	end try
		

	begin catch
		set @StateExecute = 'Fault'
		set @ErrorExecute = 
			'error_procedure: [dbo].[sSyncTablesUpdate]; ' + 
			'error_line: ' + isnull(convert(varchar, error_line()),'') + '; ' +
			'error_message: ' + isnull(error_message(),'');

		rollback transaction
	end catch
		
		
	if @@trancount > 0
	begin
		set @StateExecute = 'Success'
		commit transaction
	end

	insert into 
		tSyncLog ([DateTime], [OperationName], [TargetTableName], [RowsProcessed], [State], [Error], [Query])
	values
		(getdate(), 'Update', convert(varchar(256), @TargetTableName), @RowsProcessed, @StateExecute, @ErrorExecute, @OPENQUERY)
END
GO
