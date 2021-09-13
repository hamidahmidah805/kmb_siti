-- komentar untuk 1 baris

/* untuk komentar yang 
 * lebih dari 1 baris
 */


/* 1. Untuk mengecek data dapat menggunakan * namun dibuat LIMIT 
 * agar lebih cepat runningnya
 */

select * 
from datasource.departments limit 10;

/* 2. DISTINCT = UNIQUE 
 * DISTINCT (nama_kolom)
 */

select distinct(department_id)
from datasource.employees  ;

/* 3. ORDER BY = SORT 
 * - bisa menggunakan nama_kolom 
 *   bisa menggunakan urutan kolom 
 *   (karena urutan kolom yg akan diambil akan sesuai dengan urutan kolom yg akan ditampilkan)
 * - bisa diurutkan berdasarkan >1 kolom (berlaku hirarki)
 */

-- menggunakan nama_kolom
select distinct(manager_id), department_id 
from datasource.employees 
order by manager_id desc ; 

-- untuk komentar yang 1 baris
select distinct(manager_id), department_id 
from datasource.employees 
order by 1 desc; 

-- order by >1 kolom
select distinct(manager_id), department_id , first_name
from datasource.employees 
order by manager_id, department_id desc;

/* 4. CREATE TABLE
 * 	CREATE TABLE nama_database(opsional).nama_skema.nama_tabel(
 * 		nama_kolom1 tipe_data1
 * 		nama_kolom2 tipe_data2
 * 	)
 * Macam-macam tipe data
 * - INT : bilangan bulat (1,4,6,2,66,892,...)
 * - FLOAT : bilangan real (22.34, 65.89)
 * - VARCHAR : teks
 * - DATE : "tahun-bulan-tanggal"
 * - TIMESTAMP : "tahun-bulan-tanggal jam:menit:detik" 
 * - BIGINT : integer namun untuk integer yg lebih besar ( 137493029030484020390)
 */

create table batch_kmb.midah_users(
	id int, 
	nama varchar,
	KTP bigint,
	birthday date, 
	gaji float
)

/* 5. INSERT INTO (insert values to table)
 * 		INSERT INTO nama_skema.nama_tabel VALUES
 * 		(1, ‘Udin’, ‘1990-01-01, 123123123, ‘Pelanggan Premium’),
 * 		(2, ‘Usep’, ‘1991-01-01, 32132121, ‘Pelanggan Biasa’)
 */

insert into batch_kmb.midah_users values
(1,'Siti Hamidah',123456789,'1999-12-03',12000000),
(2,'Nurhasanah',321321321,'1999-11-29',10000000)

select * 
from midah_users ;

-- untuk ID yang otomatis unique bisa menggunakan auto increment

select * 
from batch_kmb.midah_users
order by 5 desc;

/* 6. UPDATE 
 * 		UPDATE nama_skema.nama_tabel
 * 		SELECT BIRTHDATE = ‘1997-01-01’
 * 		WHERE ID = 4
 * 		(kalo ga pake WHERE nanti jadinya 1 kolom keubah semua)
 */

update batch_kmb.midah_users 
set gaji = 13000000
where nama='Nurhasanah';

/* 7. ALTER COLUMN 
 * 	 Menambah Kolom
 * 			ALTER TABLE nama_skema.nama_tabel ADD ALAMAT VARCHAR;
 * 			ALTER TABLE nama_skema.nama_tabel ADD PEKERJAAN VARCHAR;
 * 	 Menghapus Kolom
 * 			ALTER TABLE nama_skema.nama_tabel DROP COLUMN ALAMAT ;
 * 			ALTER TABLE nama_skema.nama_tabel DROP COLUMN PEKERJAAN ;
 * 
 */

------ MENAMBAH KOLOM ------
alter table batch_kmb.midah_users 
add address varchar;

-- ngisi kolom baru address pake update 
update batch_kmb.midah_users 
set address = 'Bogor'
where id=1;


update batch_kmb.midah_users 
set address = 'Jakarta'
where id= 2;




------ MENGHAPUS KOLOM -------

select * from batch_kmb.midah_users ;

alter table batch_kmb.midah_users 
drop column address;


/* 7. DELETE FROM (Menghapus Baris tertentu)
 * DELETE FROM nama_skema.nama_tabel 
 * WHERE kondisi;
 * (bisa menghapus 1/>1 baris atau dengan kondisi yang lebih spesifik)
 */

delete from batch_kmb.midah_users 
where id=1;

/* 8.  TRUNCATE TABLE (Bersihin isi tabel secara keseluruhan)
 * 		TRUNCATE TABLE nama_skema.nama_tabel
 */

truncate table batch_kmb.midah_users ;

/* DROP TABLE
 * DROP TABLE nama_skema.nama_tabel
 * (sangat tidak direkomendasikan)
 */

drop table batch_kmb.midah_users ;

-- Materinya sudah selesai, bisa langsung dilakukan dokumentasi dari materi Basic SQL --


 





