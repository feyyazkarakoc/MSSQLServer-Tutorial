--PART 10 ***************************************************************************

--List of columns ve full isim kullanmak  *'dan daha performansl�d�r
USE [Sample]
GO

SELECT [ID]--SQL Server Management Studio (SSMS), otomatik olarak k��eli parantezleri ekleyebilir.
      ,[Name]
      ,[Email]
      ,[GenderId]
      ,[Age]
      ,[City]
  FROM [Sample].[dbo].[tblPerson]--Full name avantajl�

GO



 /*dbo (Database Owner), veritaban�ndaki varsay�lan �ema (schema) ad�d�r.
Schema, veritaban� nesnelerini gruplamak i�in kullan�lan bir isim alan�d�r (namespace).

dbo, SQL Server'da varsay�lan �emad�r ve s�per yetkili kullan�c�ya (db_owner) aittir.
E�er tablo bir �ema belirtilmeden olu�turulursa, dbo alt�nda olu�ur.

Sen dbo yazmazsan ne olur?
SQL Server, �nce senin kullan�c�na atanm�� �emay� arar, e�er bulamazsa dbo �emas�n� varsayar.
Yani, SELECT * FROM tblPerson; yazarsan da ayn� sonucu al�rs�n!*/


/*GO, SQL Server i�in ge�erli bir komut de�ildir, sadece SSMS ve SQLCMD gibi ara�lar taraf�ndan yorumlan�r.
SSMS gibi ara�larda batch (toplu i�lem) s�n�r�n� belirler, ama SQL Server i�in zorunlu de�ildir. */


