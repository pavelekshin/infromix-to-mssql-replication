# infromix-to-mssql-replication\

Incremetal replication from Cisco CVP Reporting (IBM Infromix) to MSSQL\
Solution made for acceleration of custom reports and reducing workload on CVP Reporting instance, benefit of this solution is speed up the reports, cause you gain the full control of tables/indexs/statistics/exucution plan and it's optimization.
<br>
<br>

![db_schema](https://github.com/pavelekshin/infromix-to-mssql-replication/blob/main/pic/db_schema.png)

Source DB schema and table description on [Cisco.com](https://www.cisco.com/c/en/us/td/docs/voice_ip_comm/cust_contact/contact_center/customer_voice_portal/cvp12_0/configuration/guide/ccvp_b_reporting-guide-for-cvp-1201/ccvp_b_reporting-guide-for-cvp-1201_chapter_0100.html) <br>
<br>


# Prerequisite:
1. Depending on which Windows operating system version (32-bit or 64-bit) is used, install according IBM Informix Client SDK for Windows Operating Systems, which contains ODBC driver for IBM Informix
1. Configure ODBC driver on Windows used ODBC Data Sources Administrator (32-bit or 64-bit)
1. Configure Linked server on MSSQL to use previously configured ODBC connection - f.e check data/linked_server.sql

* _On my deployment I used - clientsdk.4.10.FC14.windows64.zip_
* _For more information about connecting to CVP Reporting instance, check Cisco [documentation](https://www.cisco.com/c/en/us/td/docs/voice_ip_comm/cust_contact/contact_center/customer_voice_portal/cvp12_0/configuration/guide/ccvp_b_reporting-guide-for-cvp-1201/ccvp_b_reporting-guide-for-cvp-1201_chapter_010.html#task_98BAFAACB233B9D2CF42DAACE1C8DF84)_

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

# Jobs:
1. job_runSyncReportTable - run increment copy and update procedure
1. job_runOnReglamentIndex - run reglament procedure and disabled/enabled incremental copy job while the run
1. job_cleanupTasks - run cleanup procedure
1. job_maintenanceplan_db - run maintenanceplan plan for backup database
1. job_maintenanceplan_log - run maintenanceplan plan for backup transaction log (if you plan to use DB recovery mode: FULL)

* _Configure database maintenance plan according your best practice_

# DB function:
UTF8_TO_NVARCHAR - helper scalar function which convert Unicode to NVARCHAR.

> [!NOTE]
> SQL Server 2019 (15.x) introduces full support for the widely used UTF-8 character encoding as an import or export encoding, and as database-level or column-level collation for string data. UTF-8 is allowed in the char and varchar data types, and it's enabled when you create or change an object's collation to a collation that has a UTF8 suffix.\
> Detailed on [Microsoft](https://learn.microsoft.com/en-us/sql/relational-databases/collations/collation-and-unicode-support?view=sql-server-ver16#utf8)

# Known issues:
1. In source DB, in the "call" and "vxmlsession" tables, enddatetime column is filled after the call is completed
2. In source DB, in the "call" and "vxmlsession" tables, enddatetime column may not be filled for some reasons and stay NULL
3. In source DB, in the "vxmlelementdetail" table may contains repeated rows

> [!IMPORTANT]
> 1. Convert "varvalue" column data which may contains non-Latin char from source "vxmlelementdetail" table to NVARCHAR using scalar function dbo.UTF8_TO_NVARCHAR(varvalue)
> 1. Convert date/datetime from source to according date/datetime in MSSQL 
> 1. Periodically trying to update enddatetime value for "call" and "vxmlsession" tables because it’s presented in source tables with NULL value for uncompleted calls (we may have a call lasting up to an hour)

> [!TIP]
> Tune the number of copied records and linked server name on tSetting and time and frequency running jobs according your workload and your tasks.
