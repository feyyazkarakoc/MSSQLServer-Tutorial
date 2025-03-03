USE [Sample]
GO

Select * from tblGender
Select * from tblPerson

Insert into tblPerson (ID,Name,Email) Values (7,'Rich','r@r.com')

ALTER TABLE tblPerson
ADD CONSTRAINT DF_tblPerson_GenderId
DEFAULT 3 FOR GenderId

Insert into tblPerson (ID,Name,Email) Values (8,'Mike','m@m.com')

Insert into tblPerson (ID,Name,Email,GenderId) Values (9,'Sara','s@s.com',1)

Insert into tblPerson (ID,Name,Email,GenderId) Values (10,'John','j@j.com',null)

ALTER TABLE tblPerson
DROP CONSTRAINT DF_tblPerson_GenderId 