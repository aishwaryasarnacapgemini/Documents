/*
TABLES AND PROCEDURES


	PROJECT NAME   :  PECUNIA
	USE CASE       :  ADMIN AND EMPLOYEE
	DEVELOPER NAME :  AISHWARYA SARNA
	CREATION DATE  :  01/10/2019
	MODIFIED DATE  :  04/10/2019


*/




--CREATION OF DATABSE
create database Pecunia
go 

use Pecunia
go

--creation of schema
create schema SystemUser
go

--creating type
create type Email from varchar(40)
go

--creating type
create type Password from varchar(15)
go

USE Pecunia
go


/*TABLES*/
--creating table for Admins
create table SystemUser.Admins
(
	AdminID varchar(36) primary key,
	AdminName varchar(40) not null,
	AdminEmail Email not null,
	AdminPassword Password not null,
	CreationDateTime datetime,
	LastModifiedDateTime datetime,
	IsActive bit,
	EmployeeID varchar(36) foreign key (EmployeeID) references SystemUser.Employees(EmployeeID)
);
go


--creating table for Employees
create table SystemUser.Employees(
	EmployeeID varchar(36) primary key,
	EmployeeName varchar(40) not null,
	EmployeeEmail Email not null,
	EmployeePassword Password not null,
	Mobile char(10),
	CreationDateTime datetime,
	LastModifiedDateTime datetime,
	IsActive bit
);
go



/*PROCEDURES FOR ADMIN*/
--procedure for displaying password and email
create procedure GetAdminByEmailandPassword(@adminEmail Email, @adminPassword Password)
as
begin
	if not exists(select AdminEmail,AdminPassword from SystemUser.Admins where AdminEmail = @adminEmail and AdminPassword = @adminPassword)
	throw 50014, 'Email and Password not found',1
	else
	select * from SystemUser.Admins
end
go



--procedure for updating admin email 
create procedure UpdateAdminEmail(@adminID varchar(36), @adminEmail Email)
as
begin
	if isnull(@adminID,'')=''
	throw 50012, 'Admin ID is invalid', 1
	if not exists(select AdminID from SystemUser.Admins where AdminID = @adminID)
	throw 50012, 'Admin ID not found',1
	if exists(select AdminEmail from SystemUser.Admins where AdminEmail = @adminEmail)
	throw 50012, 'Email already exists', 1
	else
	update SystemUser.Admins set AdminEmail = @adminEmail where AdminID = @adminID
end
go


--procedure for updating admin password
create procedure UpdateAdminPassword(@adminID varchar(36), @adminPassword Password)
as
begin
	if isnull(@adminID,'')=''
	throw 50013, 'Admin ID is invalid', 1
	if not exists(select AdminID from SystemUser.Admins where AdminID = @adminID)
	throw 50013, 'Admin ID not found',1
	if exists(select AdminPassword from SystemUser.Admins where AdminPassword = @adminPassword)
	throw 50012, 'Password already exists', 1
	else
	update SystemUser.Admins set AdminPassword = @adminPassword where AdminID = @adminID
end
go





/*PROCEDURES FOR EMPLOYEES*/
--procedure for adding employees
create procedure AddEmployees(@empid varchar(36), @empname varchar(40), @empemail Email, @emppassword Password, @empmobile char(10))
as
begin
DECLARE @creationDate datetime = SYSDATETIME() 
DECLARE @lastModifiedDateTime datetime = SYSDATETIME()
DECLARE @isActive bit = 1;
	if isnull(@empid,'')=''
	throw 50001, 'Employee ID is invalid', 1
	if exists (select EmployeeID from SystemUser.Employees where EmployeeID = @empid)
	throw 50001, 'Employee ID already exists', 1
	if @empname = ''
	throw 50001, 'Name cannot be blank', 1
	if @empemail is null 
	throw 50001, 'Email cannot be blank', 1
	if exists (select EmployeeEmail from SystemUser.Employees where EmployeeEmail = @empemail)
	throw 50001, 'Email already exists', 1
	if @emppassword is null
	throw 50001, 'Password cannot be blank', 1
	if @empmobile is null
	throw 50001, 'Mobile cannot be blank', 1
	if 	exists (select Mobile from SystemUser.Employees where Mobile = @empmobile)
	throw 50001, 'Mobile number already exists', 1
	else
	insert into SystemUser.Employees(EmployeeID, EmployeeName, EmployeeEmail, EmployeePassword, Mobile, CreationDateTime, LastModifiedDateTime, isActive) 
	values (@empid, @empname, @empemail, @emppassword, @empmobile, @creationDate, @lastModifiedDateTime, @isActive) 
end
go

exec AddEmployees 'Aishwarya', 'aishwarya@gmail.com', 'Aishwarya#123', '9234567895'
go
exec GetAllEmployees
go


--procedure for displaying employees by email id and password 
create procedure GetEmployeeByEmailandPassword(@empEmail Email, @empPassword Password)
as
begin
	if not exists(select EmployeeEmail,EmployeePassword from SystemUser.Employees where EmployeeEmail = @empEmail and EmployeePassword = @empPassword)
	throw 50014, 'Email and Password not found',1
	else
	select * from SystemUser.Employees
end
go

--displaying all employee details in the employees table
create procedure GetAllEmployees
as
begin
	select * from SystemUser.Employees
end
go

--displaying an employee with a specific employee id
create procedure GetEmployeeByEmployeeID(@empid varchar(36))
as
begin
	if @empid = ''
	throw 50002, 'Employee ID cannot be null',1
	if not exists(select EmployeeID from SystemUser.Employees where EmployeeID = @empid)
	throw 50002, 'Employee ID not found',1
	else
	select * from SystemUser.Employees where EmployeeID = @empid  
end
go


--displaying employees with a specific name
create procedure GetEmployeesByName(@empname varchar(40))
as
begin
	if @empname = ''
	throw 50003, 'Employee Name cannot be blank',1
	if not exists (select EmployeeName from SystemUser.Employees where EmployeeName = @empname)
	throw 50003, 'Employee Name not found',1
	else
	select EmployeeName from SystemUser.Employees where EmployeeName = @empname
end
go


--displaying an employee with a specific email 
create procedure GetEmployeeByEmail(@empemail Email)
as
begin
	if @empemail =''
	throw 50004, 'Employee Email cannot be blank',1
	if not exists (select EmployeeEmail from SystemUser.Employees where EmployeeEmail = @empemail)
	throw 50004, 'Employee Email not found',1
	else
	select EmployeeEmail from SystemUser.Employees where EmployeeEmail = @empemail
end
go


--displaying an employee with specific email and password
create procedure GetEmployeeEmailandPassword(@empemail Email, @emppassword Password)
as
begin
	if @empemail = '' or @emppassword = ''
	throw 50005, 'Employee Email and Password cannot be blank', 1
	if not exists (select EmployeeEmail, EmployeePassword from SystemUser.Employees where EmployeeEmail = @empemail and EmployeePassword = @emppassword)
	throw 50005, 'Employee Email and Password not found',1
	else
	select EmployeeEmail, EmployeePassword from SystemUser.Employees where EmployeeEmail = @empemail and EmployeePassword = @emppassword
end
go


--updating all the details of the employee
create procedure UpdateAllEmployeeDetails(@empid varchar(36), @empname varchar(40), @empemail Email, @emppassword Password, @empmobile char(10))
as
begin
	if isnull(@empid,'')=''
	throw 50006, 'Employee ID is invalid', 1
	if not exists(select EmployeeID from SystemUser.Employees where EmployeeID = @empid)
	throw 50006, 'Employee ID not found',1
	if @empname = '' or @empemail ='' or  @emppassword ='' or @empmobile =''
	throw 50006, 'Employee Name, Email, Password and Mobile should be valid', 1
	if exists (select EmployeeEmail from SystemUser.Employees where EmployeeEmail = @empemail)
	throw 50006, 'Email already exists',1
	if exists (select Mobile from SystemUser.Employees where Mobile = @empmobile)
	throw 50006, 'Mobile number already exists',1
	else
	update SystemUser.Employees set EmployeeName = @empname, EmployeeEmail = @empemail, EmployeePassword = @emppassword, Mobile = @empmobile, LastModifiedDateTime = SYSDATETIME() where EmployeeID = @empid
end
go


--updating name of the employee
create procedure UpdateEmployeeName(@empid varchar(36), @empname varchar(40))
as
begin
	if isnull(@empid,'')=''
	throw 50007, 'Employee ID is invalid', 1
	if not exists(select EmployeeID from SystemUser.Employees where EmployeeID = @empid)
	throw 50007, 'Employee ID not found',1
	if @empname = ''
	throw 50007, 'Employee Name cannot be blank', 1
	else
	update SystemUser.Employees set EmployeeName = @empname, LastModifiedDateTime = SYSDATETIME() where EmployeeID = @empid
end
go


--updating email of the employee
create procedure UpdateEmployeeEmail(@empid varchar(36), @empemail Email)
as
begin
	if isnull(@empid,'')=''
	throw 50008, 'Employee ID is invalid', 1
	if not exists(select EmployeeID from SystemUser.Employees where EmployeeID = @empid)
	throw 50008, 'Employee ID not found',1
	if @empemail = '' or @empemail is null
	throw 50008, 'Employee Email cannot be null or blank', 1
	if exists(select EmployeeEmail from SystemUser.Employees where EmployeeEmail = @empemail)
	throw 50008, 'Email already exists', 1
	else
	update SystemUSer.Employees set EmployeeEmail = @empemail, LastModifiedDateTime = SYSDATETIME() where EmployeeID = @empid
end
go


--updating password of the employee
create procedure UpdateEmployeePassword(@empid varchar(36), @emppassword Password)
as
begin
	if isnull(@empid,'')=''
	throw 50009, 'Employee ID is invalid', 1
	if not exists(select EmployeeID from SystemUser.Employees where EmployeeID = @empid)
	throw 50009, 'Employee ID not found',1
	if @emppassword is null or @emppassword = '' 
	throw 50009, 'Employee Password cannot be null or blank', 1
	else
	if exists (select EmployeePassword from SystemUser.Employees where EmployeePassword = @emppassword)
	throw 50009, 'Password already exists', 1
	update SystemUSer.Employees set EmployeePassword = @emppassword, LastModifiedDateTime = SYSDATETIME() where EmployeeID = @empid
end
go


--updating mobile numbaer of the employee
create procedure UpdateEmployeeMobile(@empid varchar(36), @empmobile char(10))
as
begin
	if isnull(@empid,'')=''
	throw 50010, 'Employee ID is invalid', 1
	if not exists(select EmployeeID from SystemUser.Employees where EmployeeID = @empid)
	throw 50010, 'Employee ID not found',1
	if @empmobile is null or @empmobile = ''
	throw 50010, 'Employee Mobile cannot be null', 1
	if exists(select Mobile from SystemUser.Employees where Mobile = @empmobile)
	throw 50010, 'Mobile Number already exists',1
	else
	update SystemUser.Employees set Mobile = @empmobile, LastModifiedDateTime = SYSDATETIME() where EmployeeID = @empid
end
go


--deleting employee with a specific employee id
create procedure DeleteEmployee(@empid varchar(36))
as
begin
	if isnull(@empid,'')=''
	throw 50011, 'Employee ID is invalid', 1
	if not exists(select EmployeeID from SystemUser.Employees where EmployeeID = @empid)
	throw 50011, 'Employee ID not found',1
	update SystemUser.Employees set IsActive = 0 where EmployeeID = @empid
end
go
