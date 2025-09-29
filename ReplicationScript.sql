 -- Create a database
 Create database DoMoreWithDataDB

 -- Switch to the database
 use DomoreWithDataDB

 -- Set the database to full recovery mode 
 Alter database DoMoreWithDataDB 
 set recovery full

 -- Let create a sample table 
 create table staff(
	staffId int identity(1,1) primary key,
	staffName nvarchar(50)
)

-- Insert record to the table
insert into staff
values
('Taiwo'),
('Ramon')

-- create another sample table
create table students(
	studentId int identity(1,1) primary key,
	studentName nvarchar(50)
)

-- Insert record to the table
insert into students
values
('Ade'),
('White')

-- Create Destination Database 
Create database DomoreWithDataDB_Replica



 -- Configure distribution and publisher together
USE master
GO

EXEC sp_adddistributor 
    @distributor = N'SHAKORYSMARTTECH', 
    @password = N''
GO

EXEC sp_adddistributiondb 
    @database = N'distribution', 
    @data_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA', 
    @log_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Data', 
    @log_file_size = 2, 
    @min_distretention = 0, 
    @max_distretention = 72, 
    @history_retention = 48, 
    @security_mode = 1
GO

-- Enable this server as Publisher
EXEC sp_adddistpublisher 
    @publisher = N'SHAKORYSMARTTECH', 
    @distribution_db = N'distribution', 
    @security_mode = 1, 
    @working_directory = N'C:\ReplicationData', 
    @trusted = N'false', 
    @thirdparty_flag = 0, 
    @publisher_type = N'MSSQLSERVER'
GO

-- Enable the database for publishing
EXEC sp_replicationdboption 
    @dbname = N'DoMoreWithDataDB',
    @optname = N'publish',
    @value = N'true'
GO

-- Check if server is now both distributor and publisher
SELECT name, is_distributor, is_publisher 
FROM sys.servers 
WHERE name = @@SERVERNAME

-- Check if database is enabled for publishing
SELECT name, is_published 
FROM sys.databases 
WHERE name = 'DoMoreWithDataDB'

-- Check distribution database exists
SELECT name FROM sys.databases WHERE name = 'distribution'


-- Let insert more record in our table
use DoMoreWithDataDB

insert into staff
values
('Shakiru'),
('Kenny')

select * from staff