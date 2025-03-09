
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
SELECT * FROM tblEmployee WHERE SUM(Salary)>4000;--Hata

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

