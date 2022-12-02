create table book (
isbn char(17) NOT NULL unique primary key,
title varchar(30),
author varchar(30)
);

create table copy(
code int primary key,
isbn char(17),
duration tinyint  ,
foreign key (isbn) references book(isbn),
constraint duration check(duration in (7,14,21))
);

create table student(
no int not null primary key,
name varchar(30),
school char(3),
embargo bit default 0
);

create table loan(
code int,
no int,
taken date,
due date,
ret date,
foreign key (code) references copy(code) ,
foreign key (no) references student(no)
);
insert into loan values (1011, 2002, '2020-01-10', '2020-01-31', '2020-01-10') ,
(1011, 2002, '2020-02-05', '2020-02-26', '2020-02-23'),
 ( 1013, 2003, '2019-03-02', '2019-08-16', '2019-08-16'),
(1013, 2002, '2019-08-02', '2019-08-16', '2019-08-16'),
(2011, 2004, '2018-02-01', '2018-02-22', '2018-02-20'),
(3011, 2005, '2019-10-10', '2019-10-17', '2019-10-20');

insert into loan (code,no,taken,due) values (1011, 2003, '2020-05-10', '2020-05-31'),
(3011, 2002, '2020-07-03', '2020-07-10');

insert into book values ("111-2-33-444444-5","Pro JavaFX","Dave Smith"),("222-3-44-555555-6","Oracle Systems","Kate Roberts"),("333-4-55-666666-7","Expert jQuery","Mike Smith");
insert into copy values (1011,"111-2-33-444444-5",21),(1012,"111-2-33-444444-5",14),(1013,"111-2-33-444444-5",7),(2011,"222-3-44-555555-6",21),(3011,"333-4-55-666666-7",7),
(3012,"333-4-55-666666-7",14);
insert into student values (2001,"Mike","CMP",0),
(2002,"Andy",	"CMP", 1),
(2003,"Sarah","ENG",0),
(2004,	"Karen", "ENG", 1),
(2005,	"Lucy", "BUE",	0);




create view get_student as
select * from student where school = "cmp"
with check option;

insert into get_student values (2010,	"Karen", "ENG", 1);

CREATE TABLE loan_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
	code int,
	no int,
	taken date,
	due date,
	ret date,
    action VARCHAR(50) DEFAULT NULL
);
