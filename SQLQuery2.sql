--PART 10 ***************************************************************************

--List of columns ve full isim kullanmak  *'dan daha performansl�d�r
USE [Sample]
GO

SELECT [ID]
      ,[Name]
      ,[Email]
      ,[GenderId]
      ,[Age]
      ,[City]
  FROM [Sample].[dbo].[tblPerson]--Full name avantajl�

GO


