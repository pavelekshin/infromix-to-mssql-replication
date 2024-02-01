USE [master]
GO

/****** Object:  LinkedServer [cvpreporting.example.com] Script Date: 26.01.2024 16:25:27 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'cvpreporting.example.com', @srvproduct=N'Ifxoledbc', @provider=N'MSDASQL', @datasrc=N'CVPReporting', @provstr=N'Driver={IBM INFORMIX ODBC DRIVER (64-bit)};DATABASE=cvp_data ;HOST=192.168.100.100;PROTOCOL=onsoctcp ;'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'cvpreporting.example.com',@useself=N'False',@locallogin=NULL,@rmtuser=N'cvp_dbuser',@rmtpassword='########'
GO

EXEC master.dbo.sp_serveroption @server=N'cvpreporting.example.com', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'cvpreporting.example.com', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'cvpreporting.example.com', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'cvpreporting.example.com', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'cvpreporting.example.com', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'cvpreporting.example.com', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'cvpreporting.example.com', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'cvpreporting.example.com', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'cvpreporting.example.com', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'cvpreporting.example.com', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'cvpreporting.example.com', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'cvpreporting.example.com', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'cvpreporting.example.com', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO

