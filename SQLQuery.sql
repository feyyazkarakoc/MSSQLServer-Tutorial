
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

/*Check kısıtlaması, bir sütuna girebilecek değerlerin aralığını
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

--Constrainti ekledik, 0 ile 150 arasında olmalı 
INSERT INTO tblPerson VALUES(14,'Zeliha','z@z.com',2,-996) --Hata

INSERT INTO tblPerson VALUES(14,'Zeliha','z@z.com',2,25)

INSERT INTO tblPerson VALUES(15,'Züleyha','z@z.com',2,NULL) -- 0 ile 150 arasında olmalı 
--CK olmasına rağmen null eklenir

ALTER TABLE tblPerson
DROP CONSTRAINT CK_tblPerson_Age

ALTER TABLE tblPerson
ADD CONSTRAINT CK_tblPerson_Age CHECK (Age>0 AND Age<150)

INSERT INTO tblPerson VALUES(16,'Zeki','z@z.com',1,950) --Hata





--PART 7 ***************************************************************************

/* Kimlik Sütunu (Identity Column),otomatik artan (auto-increment) değerler
oluşturmak için kullanılan bir sütun türüdür.Primary Key (PK) ile sıkça kullanılır, ancak
zorunlu değildir.
Elle değer eklenemez (Varsayılan olarak SQL Server kendi yönetir).

İlk parametre (seed): Başlangıç değeri
İkinci parametre (increment): Kaç artacağını belirler

Eğer belirli bir ID değeri elle eklemek istiyorsan:
SET IDENTITY_INSERT Employees ON: Kimlik sütununa elle değer eklemeye izin verir.

SET IDENTITY_INSERT Employees OFF: Daha sonra tekrar kapatılmalıdır (OFF).

Eğer kimlik değerlerini sıfırlamak istersen:
DBCC CHECKIDENT ('Employees', RESEED, 1);
Sonraki eklenen kayıt 2 ile başlayacaktır (1 değil).
*/



SELECT * FROM tblPerson1

INSERT INTO tblPerson1 VALUES('Ali')
INSERT INTO tblPerson1 VALUES('Veli')

DELETE FROM tblPerson1  WHERE PersonId = 1

INSERT INTO tblPerson1 VALUES('Can')

INSERT INTO tblPerson1 VALUES(1,'Nuri')--Hata

SET IDENTITY_INSERT tblPerson1 ON

INSERT INTO tblPerson1 (PersonId,Name) VALUES(1,'Nuri')

INSERT INTO tblPerson1  VALUES('Ayşe')--Hata

SET IDENTITY_INSERT tblPerson1 OFF

INSERT INTO tblPerson1  VALUES('Ayşe')

DELETE FROM tblPerson1

SELECT * FROM tblPerson1

INSERT INTO tblPerson1  VALUES('Ayşe')--6'dan başladı

DELETE FROM tblPerson1

DBCC CHECKIDENT(tblPerson1,RESEED,0)

INSERT INTO tblPerson1  VALUES('Ayşe')--1'den başladı











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
değer farklı kapsamları (scope) da içerebilir. 
@@IDENTITY, çağrıldığı yerden bağımsız olarak en son kimlikdeğerini döndürür. Ancak, bu değer, bir 
tetikleyici (trigger) veya başka bir işlemle değişmiş olabilir, bu yüzden dikkatli kullanılmalıdır.

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
tekrar etmesini engelleyen bir kısıtlamadır. Birincil Anahtar (PRIMARY KEY) gibi çalışır, 
ancak farklı olarak:
- Bir tabloda birden fazla UNIQUE kısıtlaması olabilir.
- NULL değerlerine izin verebilir (ancak genellikle sadece bir tane NULL kabul eder).
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

--DISTINCT ifadesi, sorgu sonucunda tekrarlanan satırları kaldırarak yalnızca benzersiz satırları döndürür.
SELECT DISTINCT City FROM tblPerson--4 satır geldi
SELECT DISTINCT Name, City FROM tblPerson--5 satır geldi.Name ve City sütunlarının birleşimi üzerinden
--DISTINCT işlemi uygulanır.Yani, her bir Name-City çifti benzersiz olmalıdır. 

SELECT * FROM tblPerson WHERE City = 'London'

SELECT * FROM tblPerson WHERE City <> 'London'--Not equal
SELECT * FROM tblPerson WHERE City != 'London'--Not equal

/* 
=	Eşit (Equal to)
<>	Eşit değil (Not equal to)
>	Büyüktür (Greater than)
>=	Büyüktür veya eşit (Greater than or equal to)
<	Küçüktür (Less than)
<=	Küçüktür veya eşit (Less than or equal to)
IN	Belirli değerler listesi (Specify a list of values)
BETWEEN	Aralık belirtme (Specify a range)
LIKE	Desen belirtme (Specify a pattern)

Joker Karakterler
%	Sıfır veya daha fazla karakter belirtir.
_	Tek bir karakter belirtir.
[]	Parantez içindeki herhangi bir karakteri belirtir.
[^]	Parantez içindeki karakterler dışındaki herhangi bir karakteri belirtir.
*/


SELECT * FROM tblPerson WHERE Age=20 OR Age=23 OR Age=29

SELECT * FROM tblPerson WHERE Age IN (20, 23, 29)

SELECT * FROM tblPerson WHERE Age BETWEEN 20 AND 25

SELECT * FROM tblPerson WHERE City LIKE 'L%' 

INSERT INTO tblPerson VALUES (6,'Mary','mary.com',1,45,'London')

SELECT * FROM tblPerson WHERE Email LIKE '%@%' 

SELECT * FROM tblPerson WHERE Email NOT LIKE '%@%'

INSERT INTO tblPerson VALUES
(7, 'Ali', 'a@b.com', 1, 30, 'Ankara'),
(8, 'Ayşe', 'c@d.com', 2, 28, 'İstanbul');

SELECT * FROM tblPerson WHERE Email LIKE '_@_.com'

SELECT * FROM tblPerson WHERE Name LIKE '[MST]%'

SELECT * FROM tblPerson WHERE Name LIKE '[^MST]%'

SELECT * FROM tblPerson WHERE (City= 'London' OR  City= 'Mumbai') AND Age>=25 

SELECT * FROM tblPerson ORDER BY Name --default asc
SELECT * FROM tblPerson ORDER BY Name DESC

SELECT * FROM tblPerson ORDER BY Name DESC, Age ASC 
--Önce Name sütununa göre azalan (DESC) sırayla sıralar
--Aynı isimler varsa, bunları Age sütununa göre artan (ASC) sırayla sıralar

SELECT TOP 4 * FROM tblPerson
SELECT TOP 4 Name, Age FROM tblPerson
SELECT TOP 50 PERCENT * FROM tblPerson

--Yaşı en büyük
SELECT TOP 1 * FROM tblPerson ORDER BY Age DESC







--PART 11 ***************************************************************************

/* 1. Satırları Gruplama (GROUP BY)
GROUP BY ifadesi, aynı değerlere sahip satırları bir grup halinde birleştirerek özet bilgiler 
çıkarmak için kullanılır. Genellikle toplama (SUM), ortalama (AVG), en büyük (MAX), en küçük (MIN),
sayma (COUNT) gibi fonksiyonlarla birlikte kullanılır.

2. Grupları Filtreleme (HAVING)
WHERE, satırları filtreler (gruplamadan önce).
HAVING, oluşturulan grupları filtreler (gruplamadan sonra).
HAVING, genellikle agregat (toplama) fonksiyonları ile birlikte kullanılır.

3. WHERE ve HAVING Arasındaki Fark
Kriter	               WHERE	              HAVING
Ne zaman uygulanır?	 Gruplamadan önce	Gruplamadan sonra
Hangi veriyi filtreler?	Tek tek satırları	Gruplanmış veriyi
Agregat fonksiyonlarla kullanılabilir mi?	 Hayır	Evet

WHERE ve HAVING ifadeleri arasındaki farklar:

1.WHERE:
SELECT, INSERT, UPDATE, ve DELETE gibi SQL komutları ile kullanılabilir. Yani, 
verileri sorgularken veya güncellerken belirli koşulları filtrelemek için kullanılır.
HAVING:
Sadece SELECT sorgularında kullanılabilir. Özellikle gruplama (aggregate) işlemlerinden
sonra grupları filtrelemek için kullanılır.

2. WHERE:
Satırları gruplamadan önce filtreler. Yani, veriler üzerinde işlem yapmadan önce koşul belirler.
HAVING:
Gruplama işleminden sonra filtreler. Toplama (aggregate) fonksiyonları ile birlikte kullanılarak 
gruplar üzerinde koşul belirler.

3.WHERE:
Toplama fonksiyonları (örneğin, COUNT, SUM, AVG) kullanılamaz. Eğer kullanılacaksa, bu fonksiyonlar
bir alt sorguda (subquery) yer almalıdır.
HAVING:
Toplama fonksiyonları ile birlikte kullanılabilir. Bu, gruplama işleminden sonra belirli koşulları 
uygulamak için gereklidir.

Sonuç
GROUP BY → Satırları belirli bir sütuna göre gruplar.
HAVING → Gruplara koşul ekleyerek filtreleme yapar.
  */




CREATE TABLE tblEmployee
(
ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
Name NVARCHAR(50),
Gender NVARCHAR(10),
Salary INT,
City NVARCHAR(50)
);

DELETE FROM tblEmployee;
DBCC CHECKIDENT(tblEmployee,RESEED,0)

INSERT INTO tblEmployee(Name, Gender, Salary, City) VALUES 
('Tom', 'Male', 4000, 'London')
,('Pam', 'Female', 3000, 'New York')
,('John', 'Male', 3500, 'London')
,('Sam', 'Male', 4500, 'London')
,('Todd', 'Male', 2800, 'Sydney')
,('Ben', 'Male', 7000, 'New York')
,('Sara', 'Female', 4800, 'Sydney')
,('Valanie', 'Female', 5500, 'New York')
,('James', 'Male', 6500, 'London')
,('Russell', 'Male', 8800, 'London');




SELECT SUM(Salary) FROM tblEmployee;

SELECT MIN(Salary) FROM tblEmployee;

SELECT MAX(Salary) FROM tblEmployee;

SELECT * FROM tblEmployee;

SELECT City, SUM(Salary) AS TotalSalary
FROM tblEmployee
GROUP BY City;



SELECT City, Gender, SUM(Salary) AS TotalSalary
FROM tblEmployee
GROUP BY City;--Hata. Gender için ya aggregate func eklenmeli, ya da gender, group clause'e eklenmeli.

SELECT * FROM tblEmployee;
-- 1. yol
SELECT City, Gender, SUM(Salary) AS TotalSalary
FROM tblEmployee
GROUP BY City, Gender
ORDER BY City;

--or

-- 2. yol
SELECT City, Gender, SUM(Salary) AS TotalSalary
FROM tblEmployee
GROUP BY Gender, City;

-- 1 ve 2 aynı sonucu verir


SELECT * FROM tblEmployee;

SELECT City, Gender, SUM(Salary) AS TotalSalary, COUNT(ID) AS TotalEmployees--[Total Employees]
FROM tblEmployee
GROUP BY City, Gender
ORDER BY City;

SELECT * FROM tblEmployee;

--Sadece erkekler (Filter Group clause)
--1. yol
SELECT Gender, City, SUM(Salary) AS TotalSalary, COUNT(ID) AS TotalEmployees
FROM tblEmployee
WHERE Gender = 'Male'
GROUP BY City, Gender;

--2. yol
SELECT Gender, City, SUM(Salary) AS TotalSalary, COUNT(ID) AS TotalEmployees
FROM tblEmployee
GROUP BY City, Gender
HAVING Gender = 'Male';

-- Aggregation sadece WHERE ile kullanılamaz.
SELECT * FROM tblEmployee WHERE SUM(Salary)>5000;--Hata

-- Aggregation sadece HAVING ile kullanılabilir.
SELECT Gender, City, SUM(Salary) AS TotalSalary, COUNT(ID) AS TotalEmployees
FROM tblEmployee
GROUP BY City, Gender
HAVING SUM(Salary)>5000;




--PART 12 ***************************************************************************


CREATE TABLE tblDepartment
(
     ID INT PRIMARY KEY,
     DepartmentName NVARCHAR(50),
     Location NVARCHAR(50),
     DepartmentHead NVARCHAR(50)
);


INSERT INTO tblDepartment VALUES
(1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christie'),
(4, 'Other Department', 'Sydney', 'Cindrella');




CREATE TABLE tblEmployees
(
     ID INT PRIMARY KEY,
     Name NVARCHAR(50),
     Gender NVARCHAR(50),
     Salary INT,
     DepartmentId INT FOREIGN KEY REFERENCES tblDepartment(ID)
);



INSERT INTO tblEmployees VALUES
(1, 'Tom', 'Male', 4000, 1),
(2, 'Pam', 'Female', 3000, 3),
(3, 'John', 'Male', 3500, 1),
(4, 'Sam', 'Male', 4500, 2),
(5, 'Todd', 'Male', 2800, 2),
(6, 'Ben', 'Male', 7000, 1),
(7, 'Sara', 'Female', 4800, 3),
(8, 'Valarie', 'Female', 5500, 1),
(9, 'James', 'Male', 6500, NULL),
(10, 'Russell', 'Male', 8800, NULL);




--inner join/join
SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployees 
INNER JOIN tblDepartment --JOIN
ON tblEmployees.DepartmentId=tblDepartment.ID;

SELECT * FROM tblEmployees;
SELECT * FROM tblDepartment;


/* LEFT JOIN tblDepartment
tblEmployees tablosundaki tüm kayıtları getirir.
tblDepartment tablosuyla DepartmentId = ID eşleşmesi yapar.
Eğer eşleşme bulunamazsa, tblDepartment tarafındaki sütunlar NULL olur.*/
--left outer join/left join
SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployees 
LEFT JOIN tblDepartment --LEFT OUTER JOIN
ON tblEmployees.DepartmentId=tblDepartment.ID;


SELECT * FROM tblEmployees;
SELECT * FROM tblDepartment;


/* RIGHT JOIN kullanıldığında, sağdaki (RIGHT) tabloyu yani tblDepartment tablosunu tamamen korur.
Eşleşen tblEmployees kayıtlarını getirir, ancak eşleşme yoksa tblEmployees sütunları NULL olur.*/
--right outer join/right join
SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployees 
RIGHT JOIN tblDepartment --RIGHT OUTER JOIN
ON tblEmployees.DepartmentId=tblDepartment.ID;


--full outer join/full join
SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployees 
FULL JOIN tblDepartment --FULL OUTER JOIN
ON tblEmployees.DepartmentId=tblDepartment.ID;


--cross join
SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployees 
CROSS JOIN tblDepartment;


/* Kartezyen Çarpım (Cartesian Product), iki kümenin tüm elemanlarının birbirleriyle
eşleşmesi sonucu oluşan yeni bir kümedir.CROSS JOIN, SQL'de iki tablonun her satırını
diğer tablodaki tüm satırlarla birleştiren bir işlem türüdür.
Kartezyen Çarpım = İki kümenin her elemanının diğer kümenin her elemanıyla eşleşmesi
CROSS JOIN = SQL'de iki tablonun her satırının birbirleriyle eşleşmesi
Sonuç Kümesi = İlk tablodaki satır sayısı × İkinci tablodaki satır sayısı
Genellikle filtre (WHERE) eklenmezse çok büyük ve gereksiz veri üretebilir!*/



-- ***************************************************************************
-- Advanced or intelligent joins in sql server - Part 13


SELECT * FROM tblEmployees;
SELECT * FROM tblDepartment;

SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployees
LEFT JOIN tblDepartment
ON tblEmployees.DepartmentId=tblDepartment.ID
WHERE tblDepartment.ID IS NULL;





SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployees
RIGHT JOIN tblDepartment
ON tblEmployees.DepartmentId=tblDepartment.ID
WHERE tblEmployees.DepartmentId IS NULL;


SELECT Name, Gender, Salary, DepartmentName
FROM tblEmployees
FULL JOIN tblDepartment
ON tblEmployees.DepartmentId=tblDepartment.ID
WHERE tblEmployees.DepartmentId IS NULL OR
      tblDepartment.ID IS NULL;




-- ***************************************************************************
-- Self join in sql server - Part 14

DROP TABLE tblEmployees;

DROP TABLE tblEmployee;

CREATE TABLE tblEmployees
(
     EmployeeId INT PRIMARY KEY,
     Name NVARCHAR(50),
     ManagerId INT
);



INSERT INTO tblEmployees VALUES
(1, 'Mike', 3),
(2, 'Rob', 1),
(3, 'Todd', NULL),
(4, 'Ben', 1),
(5, 'Samm', 1);

SELECT * FROM tblEmployees;
-- En çok kullanılan
SELECT E.Name Employee, M.Name Manager
FROM tblEmployees E
JOIN tblEmployees M
ON E.ManagerId=M.EmployeeId;

-- Çok kullanılan
SELECT E.Name AS Employee, M.Name AS Manager
FROM tblEmployees AS E
LEFT JOIN tblEmployees AS M
ON E.ManagerId=M.EmployeeId;


-- Nadir kullanılır
SELECT E.Name AS Employee, M.Name AS Manager
FROM tblEmployees AS E
RIGHT JOIN tblEmployees AS M
ON E.ManagerId=M.EmployeeId;


-- Nadir kullanılır
SELECT E.Name AS Employee, M.Name AS Manager
FROM tblEmployees AS E
FULL JOIN tblEmployees AS M
ON E.ManagerId=M.EmployeeId;


SELECT E.Name AS Employee, M.Name AS Manager
FROM tblEmployees AS E
CROSS JOIN tblEmployees AS M;




-- ***************************************************************************
-- Different ways to replace NULL in sql server - Part 15


/* ISNULL():Tek Alternatif Değer Belirleme (Sadece SQL Server)
Eğer verilen sütun NULL ise, yerine belirlenen bir varsayılan değeri döndürür.

COALESCE():İlk NULL Olmayan Değeri Döndürme
Birden fazla sütun veya sabit değer alabilir.
Sırayla bakar, NULL olmayan ilk değeri döndürür.

CASE:NULL Değerleri Koşula Göre Yönetme
NULL olup olmadığını kontrol etmek için kullanılabilir.
Farklı NULL durumlarına göre farklı değerler döndürebilir.
CASE 
     WHEN ... THEN ...
     WHEN ... THEN ...
     ELSE ...
END 
*/

USE [Sample]
GO

SELECT ISNULL(NULL,'No Manager')
SELECT ISNULL(NULL,'No Manager') AS MANAGER
SELECT ISNULL('Pragim','No Manager') AS MANAGER

SELECT E.Name AS Employee, ISNULL(M.Name,'No Manager') AS Manager
FROM tblEmployees AS E
LEFT JOIN tblEmployees AS M
ON E.ManagerId=M.EmployeeId;


SELECT COALESCE(NULL,'No Manager')
SELECT COALESCE('Pragim','No Manager')
SELECT COALESCE('Pragim','No Manager') AS Manager

SELECT E.Name AS Employee, COALESCE(M.Name,'No Manager') AS Manager
FROM tblEmployees AS E
LEFT JOIN tblEmployees AS M
ON E.ManagerId=M.EmployeeId;


SELECT E.Name AS Employee, 
CASE 
    WHEN M.Name IS NULL THEN 'No Manager'
	ELSE M.Name 
END
AS Manager
FROM tblEmployees AS E
LEFT JOIN tblEmployees AS M
ON E.ManagerId=M.EmployeeId;



-- ***************************************************************************
-- Coalesce function in sql server Part 16


/* COALESCE() returns the first Non NULL value.*/

DROP TABLE tblEmployees;

CREATE TABLE tblEmployees
(
     Id INT PRIMARY KEY,
     FirstName NVARCHAR(50),
	 MiddleName NVARCHAR(50),
	 LastName NVARCHAR(50),
);



INSERT INTO tblEmployees VALUES
(1, 'Sam', NULL, NULL),
(2, NULL,'Todd', 'Tanzan'),
(3, NULL, NULL, 'Sara'),
(4, 'Ben', 'Parker', NULL),
(5, 'James', 'Nick', 'Nancy');

SELECT * FROM tblEmployees;


SELECT Id,COALESCE(FirstName,MiddleName,LastName) AS Name
FROM tblEmployees;




-- ***************************************************************************
-- Union and union all in sql server Part 17

/*UNION ve UNION ALL:Satırları Birleştirir

UNION: İki veya daha fazla sorgunun sonucunu birleştirir.
JOIN gibi tabloları sütunlara göre bağlamaz, sadece satırları alt alta ekler.
Birleştirilen sorguların sütun sayısı ve veri türleri aynı olmalıdır.

Tekrar Eden Satırları Kaldırır (Distinct)
Aynı satır birden fazla kez varsa, tekrarlanan kayıtları kaldırır (DISTINCT gibi davranır).

UNION ALL:Tekrar Eden Satırları da Gösterir
UNION’dan farkı: Tekrar eden satırları kaldırmaz.
Daha hızlı çalışır çünkü DISTINCT hesaplaması yapmaz.


JOIN: Sütunları Birleştirir
Farklı tablolardaki ilişkili verileri birleştirir.
Tabloların ortak bir sütununa göre bağlanması gerekir.
*/


CREATE TABLE tblIndiaCustomers
(
     Id INT PRIMARY KEY,
     Name NVARCHAR(50),
	 Email NVARCHAR(50),
);



INSERT INTO tblIndiaCustomers VALUES
(1, 'Raj', 'R@R.com'),
(2, 'Sam', 'S@S.com');


CREATE TABLE tblUKCustomers
(
     Id INT PRIMARY KEY,
     Name NVARCHAR(50),
	 Email NVARCHAR(50),
);



INSERT INTO tblUKCustomers VALUES
(1, 'Ben', 'B@B.com'),
(2, 'Sam', 'S@S.com');


SELECT * FROM tblIndiaCustomers;
SELECT * FROM tblUKCustomers;

SELECT Id, Name FROM tblIndiaCustomers
UNION ALL
SELECT Id, Name, Email FROM tblUKCustomers;--Error

SELECT  Name, Email, Id FROM tblIndiaCustomers
UNION ALL
SELECT Id, Name, Email FROM tblUKCustomers;--Error

SELECT * FROM tblIndiaCustomers
UNION ALL
SELECT * FROM tblUKCustomers;

SELECT * FROM tblIndiaCustomers
UNION 
SELECT * FROM tblUKCustomers;


SELECT * FROM tblIndiaCustomers
ORDER BY Name
UNION ALL
SELECT * FROM tblUKCustomers;-- Error


SELECT * FROM tblIndiaCustomers
UNION ALL
SELECT * FROM tblUKCustomers
ORDER BY Name;

SELECT * FROM tblIndiaCustomers
UNION ALL
SELECT * FROM tblUKCustomers
UNION ALL
SELECT * FROM tblUKCustomers
UNION ALL
SELECT * FROM tblIndiaCustomers
ORDER BY Name;




-- ***************************************************************************
-- Stored procedures in sql server Part 18


/*
Saklı prosedür (Stored Procedure), SQL Server'da bir veya daha fazla SQL komutunu
içeren ve tekrar tekrar çalıştırılabilen önceden derlenmiş (compiled) bir kod bloğudur.
Avantajları:
Kod Tekrarını Önler: Aynı sorguları tekrar tekrar yazmaya gerek kalmaz.
Performans Artışı: Önceden derlendiği için daha hızlı çalışır.
Güvenlik Sağlar: Parametreli yapısı sayesinde SQL Injection saldırılarına karşı daha güvenlidir.
Bakımı Kolaydır: Tek bir yerde değişiklik yaparak birden fazla kullanım noktasında güncelleme sağlar.

Mevcut bir saklı prosedürü değiştirmek için ALTER PROCEDURE kullanılır.

Mevcut bir saklı prosedürün kodunu/tanımını görmek için sp_helptext sistem saklı prosedürü kullanılır.

Mevcut bir saklı prosedürü silmek için DROP PROCEDURE kullanılır.

Saklı prosedürlerin kodlarını şifrelemek için WITH ENCRYPTION 
kullanılır. Bu, prosedürün içeriğini şifreleyerek, doğrudan görüntülenmesini engeller. sp_helptext 
spGetEmployees_Encrypted kullanılırsa hata alınır. sp_helptext ve sys.sql_modules ile içerik görülemez.
*/

USE [Sample]
GO

DROP TABLE tblEmployees;

CREATE TABLE tblEmployees (
    Id INT PRIMARY KEY,
    Name NVARCHAR(50),
    Gender NVARCHAR(10),
    DepartmentId INT
);


INSERT INTO tblEmployees (Id, Name, Gender, DepartmentId) VALUES 
(1, 'Sam', 'Male', 1),
(2, 'Ram', 'Male', 1),
(3, 'Sara', 'Female', 3),
(4, 'Todd', 'Male', 2),
(5, 'John', 'Male', 3),
(6, 'Sana', 'Female', 2),
(7, 'James', 'Male', 1),
(8, 'Rob', 'Male', 2),
(9, 'Steve', 'Male', 1),
(10, 'Pam', 'Female', 2);


CREATE PROCEDURE spGetEmployees -- CREATE PROC
AS
BEGIN
     SELECT Name, Gender FROM tblEmployees
END;

spGetEmployees--highlight, then execute

EXEC spGetEmployees;

EXECUTE spGetEmployees;

SELECT * FROM tblEmployees;


CREATE PROCEDURE spGetEmployeesByGenderAndDepartment
@Gender NVARCHAR(20),
@DepartmentId INT
AS
BEGIN
     SELECT Name, Gender, DepartmentId FROM tblEmployees 
	 WHERE Gender = @Gender AND DepartmentId = @DepartmentId
END;

spGetEmployeesByGenderAndDepartment; --Error: ...expects parameter '@Gender', which was not supplied
spGetEmployeesByGenderAndDepartment 1, 'Male';-- Error: ...converting data type varchar to int
spGetEmployeesByGenderAndDepartment @DepartmentId = 1, @Gender='Male';
spGetEmployeesByGenderAndDepartment 'Male', 1;


sp_helptext spGetEmployees; /*CREATE PROCEDURE spGetEmployees 
                              AS 
							  BEGIN      
							  SELECT Name, Gender FROM tblEmployees 
							  END;*/


ALTER PROCEDURE spGetEmployees 
AS
BEGIN
     SELECT Name, Gender FROM tblEmployees
	 ORDER BY Name
END;

spGetEmployees;

DROP PROC spGetEmployees;

--To encrypt the text of the SP, use WITH ENCRYPTION option.
ALTER PROC spGetEmployeesByGenderAndDepartment
@Gender NVARCHAR(20),
@DepartmentId INT
WITH ENCRYPTION
AS
BEGIN
     SELECT Name, Gender, @DepartmentId 
	 FROM tblEmployees
	 WHERE Gender = @Gender AND DepartmentId = @DepartmentId
END;

sp_helptext spGetEmployeesByGenderAndDepartment;--The text for object 'spGetEmployeesByGenderAndDepartment'
--is encrypted.





-- ***************************************************************************
-- Stored procedures with output parameters Part 19


/*Stored Procedure’ler sadece veri getirmek için değil, bir değer döndürmek için de kullanılabilir.
Çıktı parametreleri (OUTPUT) kullanarak, bir prosedür içinde hesaplanan veya değiştirilen bir değeri
dışarıya aktarabiliriz.

Stored Procedure çağırırken, OUTPUT parametresini bir değişkende saklamamız gerekir.
DECLARE @AvgSal DECIMAL(10,2);  -- Çıktı değerini saklayacak değişken

OUTPUT Parametreleri Nerede Kullanılır?
Bir prosedürün döndürdüğü tek bir değeri almak için (SUM, AVG, MAX, COUNT)
Birden fazla sonucu aynı anda almak için (örneğin min/max maaş)
Bir işlemin sonucunu dışarıya aktarmak için (örneğin kayıt başarılı mı?)

SONUÇ
1️.OUTPUT parametreleri, prosedürün dışına veri aktarmak için kullanılır.
2️.Değişken tanımlanmalı (DECLARE @var) ve OUTPUT ile çağrılmalı.
3️.Tek veya birden fazla değer döndürebilir.
*/


DROP TABLE tblEmployees;

CREATE TABLE tblEmployees (
    Id INT PRIMARY KEY,
    Name NVARCHAR(50),
    Gender NVARCHAR(10),
    DepartmentId INT
);


INSERT INTO tblEmployees(Id, Name, Gender, DepartmentId) VALUES 
(1, 'Sam', 'Male', 1),
(2, 'Ram', 'Male', 1),
(3, 'Sara', 'Female', 3),
(4, 'Todd', 'Male', 2),
(5, 'John', 'Male', 3),
(6, 'Sana', 'Female', 2),
(7, 'James', 'Male', 1),
(8, 'Rob', 'Male', 1),
(9, 'Steve', 'Male', 1),
(10, 'Pam', 'Female', 2);



CREATE PROCEDURE spGetEmployeeCountByGender
@Gender NVARCHAR(20),
@EmployeeCount INT OUTPUT
AS
BEGIN
     SELECT @EmployeeCount = COUNT(Id) 
     FROM tblEmployees 
     WHERE Gender = @Gender
End


DECLARE @EmployeeTotal INT
EXECUTE spGetEmployeeCountByGender 'Male', @EmployeeTotal OUTPUT --If you don't specify the OUTPUT keyword,
--when executing the stored procedure, the @EmployeeTotal variable will be NULL.
PRINT @EmployeeTotal

-- You can pass parameters in any order, when you use the parameter names. 
DECLARE @EmployeeTotal INT
EXECUTE spGetEmployeeCountByGender @EmployeeCount = @EmployeeTotal OUTPUT, @Gender = 'Male'
PRINT @EmployeeTotal


--The following system stored procedures, are extremely useful when working procedures.

sp_help spGetEmployeeCountByGender /*View the information about the stored procedure, like parameter
names, their datatypes etc. sp_help can be used with any database object, like tables, views, SP's, 
triggers etc. Alternatively, you can also press ALT+F1, when the name of the object is highlighted.*/


sp_helptext spGetEmployeeCountByGender -- View the Text of the stored procedure

sp_depends spGetEmployeeCountByGender /*View the dependencies of the stored procedure. This system 
SP is very useful, especially if you want to check, if there are any stored procedures that are 
referencing a table that you are abput to drop. sp_depends can also be used with other database 
objects like table etc.*/

-- Note: All parameter and variable names in SQL server, need to have the @symbol.


-- ***************************************************************************
-- Stored procedure output parameters or return values Part 20



CREATE PROC spGetNameById
@Id INT,
@Name NVARCHAR(20) OUTPUT
AS
BEGIN
     SELECT Name
	 FROM tblEmployees
	 WHERE Id = @Id
END


--****************************************

CREATE PROCEDURE spGetTotalCount1
    @TotalCount INT OUTPUT
AS
BEGIN
    SELECT @TotalCount = COUNT(Id) FROM tblEmployees;
END;



DECLARE @Total1 INT;
EXEC spGetTotalCount1 @Total1 OUTPUT;
PRINT @Total1;  -- Çalışan sayısını ekrana yazdırır.



CREATE PROCEDURE spGetTotalCount2
AS
BEGIN
     RETURN (SELECT COUNT(Id) FROM tblEmployees);
END;


DECLARE @Total2 INT;
EXECUTE @Total2 = spGetTotalCount2;
PRINT @Total2;

--*********************************

CREATE PROC spGetNameById1
@Id INT,
@Name NVARCHAR(20) OUTPUT--return sadece integer döndürürken output'ta data type esnekliği var, istediğimizi yazabiliriz
AS
BEGIN 
     SELECT @Name = Name 
	 FROM tblEmployees 
	 WHERE Id = @Id;
END;

DECLARE @Name NVARCHAR(20)
EXECUTE spGetNameById1 1,@Name OUTPUT--OUT
PRINT 'Name = '+@Name



CREATE PROC spGetNameById2
@Id INT
AS
BEGIN 
     RETURN (SELECT Name 
	 FROM tblEmployees 
	 WHERE Id = @Id);
END;

DECLARE @Name NVARCHAR(20);
EXECUTE @Name = spGetNameById2 1;
PRINT 'Name = '+@Name;--HATA return sadece INTEGER döndürür


/*OUTPUT Parametre Kullanımı
Bu yöntem bir "referans" yöntemiyle değer döndürme işlemidir.
Stored Procedure bir değer döndürmez, OUTPUT parametresine değeri aktarır.

RETURN Kullanımı
SQL Server’da RETURN yalnızca bir INTEGER döndürebilir.
Fonksiyon gibi çalışır, doğrudan bir değer döndürür.

Farkları Nelerdir?
Özellik	                      OUTPUT Parametre	                                    RETURN Kullanımı 
Dönen Değer	        Bir değişkeni günceller ve dışarı aktarır.	                  Doğrudan bir INTEGER döndürür.
RETURN Veri Tipi	Herhangi bir veri tipi olabilir (INT, VARCHAR, DECIMAL, vs.)  Sadece INT döndürebilir!
Birden Fazla Değer  Evet, birden fazla OUTPUT parametresi olabilir.	        Hayır, sadece tek bir INT döndürebilir.
Fonksiyon Gibi Kullanılabilir mi?	 Hayır	                                  Evet (Ama sadece INT döndürür.)


SONUÇ
OUTPUT kullanımı daha esnek, çünkü her türlü veri tipini döndürebilir ve birden fazla değeri döndürebilir.
RETURN kullanımı daha basittir ama sadece INT döndürebilir ve tek bir değer döndürebilir.
*/