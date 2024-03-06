# infromix-to-mssql-replication\

Incremetal replication from Cisco CVP Reporting (IBM Infromix) to MSSQL\
Solution maded for custom reporting based on call labels setted on IVR application, also benefit of this solution is speed up the reports, cause you have the full control of tables/index/statistics and exucution plan and it's optimization.


![db_schema](https://github.com/pavelekshin/infromix-to-mssql-replication/assets/55947022/66ee13b1-0e52-4058-bfcb-b2ce60094537)

Source DB schema and table description on [Cisco.com](https://www.cisco.com/c/en/us/td/docs/voice_ip_comm/cust_contact/contact_center/customer_voice_portal/cvp12_0/configuration/guide/ccvp_b_reporting-guide-for-cvp-1201/ccvp_b_reporting-guide-for-cvp-1201_chapter_0100.html)

# Sync tables:
1. call
1. vxmlsession
1. vxmlelement
1. vxmlelementdetail
1. vxmlcustomcontent

# Destination DB tables:
1. call
1. vxmlsession
1. vxmlelement
1. vxmlelementdetail
1. vxmlcustomcontent
1. tIndexStateHistory - logs table for index reglament procedure
1. tSetting - global settings, RowCopyPerTime, Cleanup_Age, LinkedServer name, etc
1. tSettingsTables - settings for copyed and updated tables, sSyncReportTables use this table
1. tSyncLog - stored infromation about each run of copy/update/cleanup procedure

# DB procedure:
1. sCleanupIndexStateHistoryTable - cleanup procedure for table tIndexStateHistory
1. sCleanupReportTables - cleanup procedure for tables in tSettingsTables
1. sCleanupSyncLogTable - cleanup procedure for table tSyncLog
1. sOnReglamentIndex - procedure for reglament work on indexes (reorganization/rebuild/update statistics)
1. sQueryGetColumns - helper procedure which preparing query columns
1. sQueryGetParameters - helper procedure which preparing query parameters
1. sSyncReportTables - main procedure which use tSettingsTables and run according job for each table
1. sSettingsTableUpdate - helper procedure for update tSettings tables setting
1. sSyncTablesIncremental - procedure for incremental copy with OPENQUERY
1. sSyncTablesUpdate - procedure for update tables with OPENQUERY

# DB function:
UTF8_TO_NVARCHAR - helper scalar function which convert Unicode to NVARCHAR.

> [!NOTE]
> SQL Server 2019 (15.x) introduces full support for the widely used UTF-8 character encoding as an import or export encoding, and as database-level or column-level collation for string data. UTF-8 is allowed in the char and varchar data types, and it's enabled when you create or change an object's collation to a collation that has a UTF8 suffix.\
> Detailed on [Microsoft](https://learn.microsoft.com/en-us/sql/relational-databases/collations/collation-and-unicode-support?view=sql-server-ver16#utf8)

# Known issues:
1. In source DB, tables "call" and "vxmlsession" enddatetime column values is assigned after the call completes
2. In source DB, tables "call" and "vxmlsession" enddatetime column values may not be assigned for some reasons and stay NULL
3. In source DB, table "vxmlelementdetail" may contains repeated rows

> [!IMPORTANT]
> 1. Convert "varvalue" column data which may contains non-Latin char from source "vxmlelementdetail" table to NVARCHAR using scalar function dbo.UTF8_TO_NVARCHAR(varvalue) as varvalue
> 1. Convert date/datetime from source to according date/datetime in MSSQL 
> 1. Update enddatetime value for "call" and "vxmlsession" tables because it’s presented in source tables with NULL value for non-end call (you may have a call lasting up to an hour and a half)
