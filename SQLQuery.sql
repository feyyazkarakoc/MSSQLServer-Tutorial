
--PART 1 ***************************************************************************

Alter Database Sample2 Modify Name = Sample3



sp_renameDB 'Sample3','Sample4'


Drop database Sample4

Drop database master

Alter Database Sample4 Set SINGLE_USER With Rollback Immediate

Drop database Sample4



--PART 2 ***************************************************************************








--PART 3 ***************************************************************************

Use [Sample]
Go

Create Table tblGender
(
ID int NOT NULL Primary Key,
Gender nvarchar(50) NOT NULL
)

Alter table tblPerson add constraint tblPerson_GenderID_FK
Foreign Key (GenderId) references tblGender(ID)




--PART 4 ***************************************************************************


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






--PART 5 ***************************************************************************


/*Kaskad Referans Bütünlüğü Kısıtlaması
Kaskad referans bütünlüğü kısıtlaması, Microsoft SQL Server'ın bir
kullanıcı bir anahtar değerini silmeye veya güncellemeye çalıştığında
alacağı eylemleri tanımlamasına olanak tanır.
Örneğin, tblGender tablosundaki ID'si 1 olan bir satırı silerseniz, 
bu durumda tblPerson tablosundaki o ID'ye bağlı olan satırlar "yetersiz" 
(orphan) hale gelir. Bu durum, o satırın referansını kaybettiği için bir sorun yaratır.
SQL Server, bu tür durumlarda ne yapılacağını belirlemek için kaskad referans 
bütünlüğü kısıtlamasını kullanabilir. Varsayılan olarak, eğer böyle bir durum gerçekleşirse,
DELETE veya UPDATE ifadesi geri alınır (rollback) ve veritabanında yapılan değişiklikler 
iptal edilir. Bu, verilerin tutarlılığını korumak için önemli bir mekanizmadır.
Kısaca, bu kısıtlama, veritabanındaki ilişkilerin bütünlüğünü sağlamaya yardımcı 
olur ve bir kaydı silerken veya güncellerken diğer tablolardaki ilişkili verilerin 
nasıl etkileneceğini kontrol eder.*/

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

 









--PART 6 ***************************************************************************

/*Check kısıtlaması, SQL Server'da bir sütuna girebilecek değerlerin aralığını
sınırlamak için kullanılır. Bu, veritabanındaki verilerin doğruluğunu ve tutarlılığını
sağlamak amacıyla yapılır.*/

/*Eğer Boolean ifadesi (yani kısıtlama koşulu) doğruysa, check kısıtlaması geçerli kabul
edilir. Aksi takdirde, yani ifade yanlışsa, SQL Server hata verir ve işlemi gerçekleştirmez.
Eğer AGE sütunu NULL değerine sahipse, bu durumda check kısıtlaması devreye girmez; çünkü NULL,
belirli bir değeri temsil etmez.*/

ALTER TABLE tblPerson
ADD Age INT NULL

SELECT * FROM tblGender
SELECT * FROM tblPerson

INSERT INTO tblPerson VALUES(14,'Zeliha','z@z.com',2,-996)

DELETE FROM tblPerson WHERE ID=14

--Constrainti ekledik
INSERT INTO tblPerson VALUES(14,'Zeliha','z@z.com',2,-996) --Hata

INSERT INTO tblPerson VALUES(14,'Zeliha','z@z.com',2,25)

INSERT INTO tblPerson VALUES(15,'Züleyha','z@z.com',2,NULL) -- 0 ile 150 arasında olmalı CK olmasına rağmen null eklenir

ALTER TABLE tblPerson
DROP CONSTRAINT CK_tblPerson_Age

ALTER TABLE tblPerson
ADD CONSTRAINT CK_tblPerson_Age CHECK (Age>0 AND Age<150)

INSERT INTO tblPerson VALUES(16,'Zeki','z@z.com',1,950) --Hata





--PART 7 ***************************************************************************

/* Kimlik Sütunu (Identity Column), Microsoft SQL Server'da otomatik artan (auto-increment) değerler
oluşturmak için kullanılan bir sütun türüdür.Primary Key (PK) ile sıkça kullanılır, ancak zorunlu değildir.
Elle değer eklenemez (Varsayılan olarak SQL Server kendi yönetir).

İlk parametre (seed) → Başlangıç değeri
İkinci parametre (increment) → Kaç artacağını belirler

Eğer belirli bir ID değeri elle eklemek istiyorsan:
SET IDENTITY_INSERT Employees ON;→ Kimlik sütununa elle değer eklemeye izin verir.

SET IDENTITY_INSERT Employees OFF;Daha sonra tekrar kapatılmalıdır (OFF).

Eğer kimlik değerlerini sıfırlamak istersen:
DBCC CHECKIDENT ('Employees', RESEED, 1);
Sonraki eklenen kayıt 2 ile başlayacaktır (1 değil).
*/



SELECT * FROM tblPerson1

INSERT INTO tblPerson1 VALUES('Ali')
INSERT INTO tblPerson1 VALUES('Veli')

DELETE FROM tblPerson1  WHERE PersonId = 1

INSERT INTO tblPerson1 VALUES('Can')

INSERT INTO tblPerson1 VALUES(1,'Nur')--Hata

SET IDENTITY_INSERT tblPerson1 ON

INSERT INTO tblPerson1 (PersonId,Name) VALUES(1,'Nur')

INSERT INTO tblPerson1  VALUES('Ayşe')--Hata

SET IDENTITY_INSERT tblPerson1 OFF

INSERT INTO tblPerson1  VALUES('Ayşe')

DELETE FROM tblPerson1

SELECT * FROM tblPerson1

INSERT INTO tblPerson1  VALUES('Ayşe')--6'dan başladı

DELETE FROM tblPerson1

DBCC CHECKIDENT(tblPerson1,RESEED,0)

INSERT INTO tblPerson1  VALUES('Ayşe')--1'de n başladı











--PART 8 ***************************************************************************


/* Kimlik sütunu (Identity Column) genellikle birincil anahtar (Primary Key - PK) olarak kullanılır ve
otomatik artan değerler üretir. Bazen, tabloya yeni bir kayıt eklendiğinde son eklenen kimlik değerini 
almak veya mevcut kimlik sütunu değerlerini görüntülemek gerekebilir.

1. SCOPE_IDENTITY() fonksiyonu, mevcut oturumda ve çağrıldığı kapsamda (scope) en son oluşturulan
kimlik sütunu değerini döndürür. Eğer bir tabloya yeni bir satır eklediyseniz ve o ekleme işleminden 
hemen sonra kimlik değerini almak istiyorsanız, bu fonksiyonu kullanabilirsiniz.

Aynı işlem kapsamında (scope) oluşturulan son kimlik değerini döndürür.En güvenilir yöntemdir, 
çünkü sadece mevcut oturumda (session) ve aynı işlem içinde (scope) oluşturulan değeri getirir.

2. @@IDENTITY değişkeni, mevcut oturumda en son oluşturulan kimlik sütunu değerini döndürür, ancak bu 
değer farklı kapsamları (scope) da içerebilir. @@IDENTITY, çağrıldığı yerden bağımsız olarak en son kimlik
değerini döndürür. Ancak, bu değer, bir tetikleyici (trigger) veya başka bir işlemle değişmiş olabilir, 
bu yüzden dikkatli kullanılmalıdır.

Son eklenen kimlik değerini döndürür, ancak tüm oturum için geçerlidir.Tetikleyiciler (TRIGGER) varsa,
yanlış değer dönebilir! Eğer tabloda tetikleyici (TRIGGER) varsa, farklı bir tablodaki kimlik değerini döndürebilir!

3. IDENT_CURRENT(TableName)fonksiyonu, belirli bir tablo için en son oluşturulan kimlik sütunu değerini döndürür.
Bu değer, oturumdan bağımsızdır ve herhangi bir işlemden etkilenmez.Belirli bir tablo için en son kimlik değerini 
almak istediğinizde kullanışlıdır.

Belirtilen tablo için son kimlik değerini döndürür.Oturum (session) ve işlem (scope) bağımsızdır. Tüm 
kullanıcılar için geçerlidir, dikkatli kullanılmalıdır. Bu yöntem, başka kullanıcılar da işlem yapıyorsa 
yanlış değer döndürebilir.

Farklar
SCOPE_IDENTITY(): Aynı oturumda ve aynı kapsamda en son kimlik değeri.
@@IDENTITY: Aynı oturumda en son kimlik değeri, ancak farklı kapsamları içerebilir.
IDENT_CURRENT(TableName): Belirli bir tablo için en son kimlik değeri, herhangi bir oturumdan bağımsız.*/



CREATE TABLE Test1 
(
ID INT IDENTITY(1,1),
Value NVARCHAR(20)
)

CREATE TABLE Test2 
(
ID INT IDENTITY(1,1),
Value NVARCHAR(20)
)


INSERT INTO Test1 VALUES ('X')

SELECT * FROM Test1

SELECT SCOPE_IDENTITY()

INSERT INTO Test1 VALUES ('X')

SELECT SCOPE_IDENTITY()

SELECT @@IDENTITY


CREATE TRIGGER trForInsert ON Test1 FOR INSERT
AS
BEGIN
    INSERT INTO Test2 VALUES('YYY')
END


INSERT INTO Test1 VALUES ('X')

SELECT * FROM Test1
SELECT * FROM Test2

SELECT SCOPE_IDENTITY()

SELECT @@IDENTITY


--User 1 (Diğer query window User 2)

SELECT * FROM Test1
SELECT * FROM Test2



DELETE FROM Test1
DELETE FROM Test2

INSERT INTO Test2 VALUES ('ZZZ')

SELECT SCOPE_IDENTITY()
SELECT @@IDENTITY
SELECT IDENT_CURRENT('Test2')



--PART 9 ***************************************************************************

/* UNIQUE Constraint, bir tablodaki belirli bir sütundaki veya sütun grubundaki değerlerin
tekrar etmesini engelleyen bir kısıtlamadır. Birincil Anahtar (PRIMARY KEY) gibi çalışır, ancak farklı olarak:
Bir tabloda birden fazla UNIQUE kısıtlaması olabilir.
NULL değerlerine izin verebilir (ancak genellikle sadece bir tane NULL kabul eder).
*/




SELECT * FROM tblPerson
SELECT * FROM tblGender

DELETE FROM tblPerson WHERE ID=8
DELETE FROM tblPerson WHERE ID=10
DELETE FROM tblPerson WHERE ID=15

ALTER TABLE tblPerson
ADD CONSTRAINT UQ_tblPerson_Email UNIQUE(Email)

DELETE FROM tblPerson

INSERT INTO tblPerson VALUES(1,'abc','a@a.com',2,20)
INSERT INTO tblPerson VALUES(2,'xyz','a@a.com',2,30)--Hata

ALTER TABLE tblPerson
DROP CONSTRAINT UQ_tblPerson_Email 

INSERT INTO tblPerson VALUES(2,'xyz','a@a.com',2,30)--Hata vermedi


--PART 10 ***************************************************************************
SELECT * FROM tblPerson
SELECT * FROM tblGender

DELETE FROM tblPerson

INSERT INTO tblGender VALUES(1,'Male')

ALTER TABLE tblPerson
ADD City NVARCHAR(50) NULL

INSERT INTO tblPerson VALUES
(1,'Tom','t@t.com',1,23,'London'),
(2,'John','j@j.com',1,20,'New York'),
(3,'Mary','m@m.com',2,21,'Sydney'),
(4,'Josh','josh@j.com',1,29,'London'),
(5,'Sara','sara@s.com',2,25,'Mumbai');


SELECT * FROM tblPerson