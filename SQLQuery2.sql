--PART 10 ***************************************************************************

--List of columns ve full isim kullanmak  *'dan daha performanslýdýr
USE [Sample]
GO

SELECT [ID]--SQL Server Management Studio (SSMS), otomatik olarak köþeli parantezleri ekleyebilir.
      ,[Name]
      ,[Email]
      ,[GenderId]
      ,[Age]
      ,[City]
  FROM [Sample].[dbo].[tblPerson]--Full name avantajlý

GO



 /*dbo (Database Owner), veritabanýndaki varsayýlan þema (schema) adýdýr.
Schema, veritabaný nesnelerini gruplamak için kullanýlan bir isim alanýdýr (namespace).

dbo, SQL Server'da varsayýlan þemadýr ve süper yetkili kullanýcýya (db_owner) aittir.
Eðer tablo bir þema belirtilmeden oluþturulursa, dbo altýnda oluþur.

Sen dbo yazmazsan ne olur?
SQL Server, önce senin kullanýcýna atanmýþ þemayý arar, eðer bulamazsa dbo þemasýný varsayar.
Yani, SELECT * FROM tblPerson; yazarsan da ayný sonucu alýrsýn!*/


/*GO, SQL Server için geçerli bir komut deðildir, sadece SSMS ve SQLCMD gibi araçlar tarafýndan yorumlanýr.
SSMS gibi araçlarda batch (toplu iþlem) sýnýrýný belirler, ama SQL Server için zorunlu deðildir. */


