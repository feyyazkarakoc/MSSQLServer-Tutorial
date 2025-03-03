/*Kaskad Referans B�t�nl��� K�s�tlamas�
Kaskad referans b�t�nl��� k�s�tlamas�, Microsoft SQL Server'�n bir
kullan�c� bir anahtar de�erini silmeye veya g�ncellemeye �al��t���nda
alaca�� eylemleri tan�mlamas�na olanak tan�r.
�rne�in, tblGender tablosundaki ID'si 1 olan bir sat�r� silerseniz, 
bu durumda tblPerson tablosundaki o ID'ye ba�l� olan sat�rlar "yetersiz" 
(orphan) hale gelir. Bu durum, o sat�r�n referans�n� kaybetti�i i�in bir sorun yarat�r.
SQL Server, bu t�r durumlarda ne yap�laca��n� belirlemek i�in kaskad referans 
b�t�nl��� k�s�tlamas�n� kullanabilir. Varsay�lan olarak, e�er b�yle bir durum ger�ekle�irse,
DELETE veya UPDATE ifadesi geri al�n�r (rollback) ve veritaban�nda yap�lan de�i�iklikler 
iptal edilir. Bu, verilerin tutarl�l���n� korumak i�in �nemli bir mekanizmad�r.
K�saca, bu k�s�tlama, veritaban�ndaki ili�kilerin b�t�nl���n� sa�lamaya yard�mc� 
olur ve bir kayd� silerken veya g�ncellerken di�er tablolardaki ili�kili verilerin 
nas�l etkilenece�ini kontrol eder.*/

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

 

