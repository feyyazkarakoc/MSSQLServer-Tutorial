/*Kaskad Referans Bütünlüðü Kýsýtlamasý
Kaskad referans bütünlüðü kýsýtlamasý, Microsoft SQL Server'ýn bir
kullanýcý bir anahtar deðerini silmeye veya güncellemeye çalýþtýðýnda
alacaðý eylemleri tanýmlamasýna olanak tanýr.
Örneðin, tblGender tablosundaki ID'si 1 olan bir satýrý silerseniz, 
bu durumda tblPerson tablosundaki o ID'ye baðlý olan satýrlar "yetersiz" 
(orphan) hale gelir. Bu durum, o satýrýn referansýný kaybettiði için bir sorun yaratýr.
SQL Server, bu tür durumlarda ne yapýlacaðýný belirlemek için kaskad referans 
bütünlüðü kýsýtlamasýný kullanabilir. Varsayýlan olarak, eðer böyle bir durum gerçekleþirse,
DELETE veya UPDATE ifadesi geri alýnýr (rollback) ve veritabanýnda yapýlan deðiþiklikler 
iptal edilir. Bu, verilerin tutarlýlýðýný korumak için önemli bir mekanizmadýr.
Kýsaca, bu kýsýtlama, veritabanýndaki iliþkilerin bütünlüðünü saðlamaya yardýmcý 
olur ve bir kaydý silerken veya güncellerken diðer tablolardaki iliþkili verilerin 
nasýl etkileneceðini kontrol eder.*/

SELECT * FROM tblGender
SELECT * FROM tblPerson

DELETE FROM tblGender WHERE ID=1 --Hata verir silmez

ALTER TABLE  tblPerson
ADD CONSTRAINT DF_tblPerson_GenderId
DEFAULT 3 FOR GenderId



DELETE FROM tblGender WHERE ID=1

DELETE FROM tblGender WHERE ID=3

INSERT INTO tblGender (ID,Gender) Values(1,'Male')
INSERT INTO tblGender (ID,Gender) Values(3,'Unknown')

INSERT INTO tblPerson (ID,Name,Email,GenderId) Values(11,'Feyyaz','f@f.com',1)

DELETE FROM tblGender WHERE ID=1

 

