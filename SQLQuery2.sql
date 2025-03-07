--PART 10 ***************************************************************************

--List of columns ve full isim kullanmak  *'dan daha performanslýdýr
USE [Sample]
GO

SELECT [ID]
      ,[Name]
      ,[Email]
      ,[GenderId]
      ,[Age]
      ,[City]
  FROM [Sample].[dbo].[tblPerson]--Full name avantajlý

GO


