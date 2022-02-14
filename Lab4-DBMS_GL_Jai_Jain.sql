create database EComm;
use EComm;

create table supplier (
supp_id int(3) primary key auto_increment,
supp_name varchar(30) not null,
supp_city varchar(30) not null,
supp_phone  varchar(10) not null);

desc supplier;

create table customer (
cus_id int(3) primary key auto_increment,
cus_name varchar(30) not null,
cus_phone  varchar(10) not null,
cus_city varchar(30) not null,
cus_gender char(1) not null);

desc customer;

create table category (
cat_id int(3) primary key auto_increment,
cat_name varchar(50) not null);

desc category;

create table product (
pro_id int(3) primary key auto_increment,
pro_name varchar(50) not null,
pro_desc longtext,
cat_id int(3),
foreign key(cat_id) references category(cat_id));

desc product;

create table productDetails (
prod_id int(3) primary key auto_increment,
pro_id int(3),
foreign key(pro_id) references product(pro_id),
supp_id int(3),
foreign key(supp_id) references supplier(supp_id),
price decimal(10, 2) not null);

desc productDetails;

create table orders (
ord_id int(3) primary key auto_increment,
ord_amount decimal(10,2) not null,
ord_date date default current_timestamp,
cus_id int(3),
foreign key(cus_id) references customer(cus_id),
prod_id int(3),
foreign key(prod_id) references productDetails(prod_id));

desc orders;

create table rating (
rat_id int(3) primary key auto_increment,
cus_id int(3),
foreign key(cus_id) references customer(cus_id),
supp_id int(3),
foreign key(supp_id) references supplier(supp_id),
rat_ratStars int(1), 
check(rat_ratStars >= 0),
check(rat_ratStars <= 5));

desc rating;

insert into supplier(supp_name, supp_city, supp_phone) values ("Rajesh Retails", "Delhi", "1234567890");
insert into supplier(supp_name, supp_city, supp_phone) values ("Appario Ltd.", "Mumbai", "2589631470");
insert into supplier(supp_name, supp_city, supp_phone) values ("Knome products", "Banglore", "9785462315");
insert into supplier(supp_name, supp_city, supp_phone) values ("Bansal Retails", "Kochi", "8975463285");
insert into supplier(supp_name, supp_city, supp_phone) values ("Mittal Ltd.", "Lucknow", "7898456532");

insert into customer (cus_name, cus_phone, cus_city, cus_gender) values ("AAKASH", "9999999999", "DELHI", "M");
insert into customer (cus_name, cus_phone, cus_city, cus_gender) values ("AMAN", "9785463215", "NOIDA", "M");
insert into customer (cus_name, cus_phone, cus_city, cus_gender) values ("NEHA", "9999999999", "MUMBAI", "F");
insert into customer (cus_name, cus_phone, cus_city, cus_gender) values ("MEGHA", "9994562399", "KOLKATA", "F");
insert into customer (cus_name, cus_phone, cus_city, cus_gender) values ("PULKIT", "7895999999", "LUCKNOW", "M");

insert into category(cat_name) values ("BOOKS");
insert into category(cat_name) values ("GAMES");
insert into category(cat_name) values ("GROCERIES");
insert into category(cat_name) values ("ELECTRONICS");
insert into category(cat_name) values ("CLOTHES");

insert into product(pro_name, pro_desc, cat_id) values("GTA V", "DFJDJFDJFDJFDJFJF", 2);
insert into product(pro_name, pro_desc, cat_id) values("TSHIRT", "DFDFJDFJDKFD", 5);
insert into product(pro_name, pro_desc, cat_id) values("ROG LAPTOP", "DFNTTNTNTERND", 4);
insert into product(pro_name, pro_desc, cat_id) values("OATS", "REURENTBTOTH", 3);
insert into product(pro_name, pro_desc, cat_id) values("HARRY POTTER", "NBEMCTHTJTH", 1);

insert into productDetails (pro_id, supp_id, price) values (1, 2, 1500);
insert into productDetails (pro_id, supp_id, price) values (3, 5, 30000);
insert into productDetails (pro_id, supp_id, price) values (5, 1, 3000);
insert into productDetails (pro_id, supp_id, price) values (2, 3, 2500);
insert into productDetails (pro_id, supp_id, price) values (4, 1, 1000);

insert into orders (ord_amount, ord_date, cus_id, prod_id) values (1500, "2021-10-12", 3, 5);
insert into orders (ord_amount, ord_date, cus_id, prod_id) values (30500, "2021-09-16", 5, 2);
insert into orders (ord_amount, ord_date, cus_id, prod_id) values (2000, "2021-10-05", 1, 1);
insert into orders (ord_amount, ord_date, cus_id, prod_id) values (3500, "2021-08-16", 4, 3);
insert into orders (ord_amount, ord_date, cus_id, prod_id) values (2000, "2021-10-06", 2, 1);

insert into rating (cus_id, supp_id, rat_ratStars) values (2, 2, 4);
insert into rating (cus_id, supp_id, rat_ratStars) values (3, 4, 3);
insert into rating (cus_id, supp_id, rat_ratStars) values (5, 1, 5);
insert into rating (cus_id, supp_id, rat_ratStars) values (1, 3, 2);
insert into rating (cus_id, supp_id, rat_ratStars) values (4, 5, 4);

# Query1
## inner join
select cus_gender, count(cus_id) as `count` from customer inner join orders using(cus_id) where ord_amount >= 3000 group by cus_gender;

# Query2
## with inner join
select orders.*, product.pro_name from orders inner join productDetails using(prod_id) inner join product using(pro_id) where cus_id = 2;
## without inner join
select orders.*, product.pro_name from orders, productDetails, product 
where orders.prod_id = productDetails.prod_id 
and productDetails.pro_id = product.pro_id 
and orders.cus_id = 2;

# Query3
## nested query
select * from supplier where supp_id in (select supp_id from productDetails group by supp_id having count(prod_id) > 1) group by supp_id;

# Query4
## nested query
select * from category 
where cat_id = (
	select cat_id from product 
    where pro_id = (
		select pro_id from productDetails 
        where prod_id = (
			select prod_id from orders having min(ord_amount)
		)
	)
);

# Query5
## inner join
select pro_id, pro_name from product
inner join productDetails using(pro_id)
inner join orders using(prod_id)
where ord_date > "2021-10-05";

# Query6
select cus_name, cus_gender from customer where cus_name like "A%" or cus_name like "%A";

# Query7 - Stored Procedure
## only query
select supp_id as `Supplier ID`, rat_ratStars as `Rating`, 
case
	when rat_ratStars > 4 then "Genuine Supplier"
    when rat_ratStars > 2 then "Average Supplier"
    else "Supplier should not be considered"
end as `Verdict`
from rating
inner join supplier using(supp_id);

## Creating a procedure
DELIMITER &&
Create procedure getVerdict()
	begin
		select supp_id as `Supplier ID`, rat_ratStars as `Rating`, 
		case
			when rat_ratStars > 4 then "Genuine Supplier"
			when rat_ratStars > 2 then "Average Supplier"
			else "Supplier should not be considered"
			end as `Verdict` 
		from rating inner join supplier using(supp_id);
	end 
&&

## calling procedure
call getVerdict;

