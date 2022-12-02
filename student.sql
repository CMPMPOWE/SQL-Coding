-- 1.	Fetch every book’s isbn, title & author. -- 
select isbn,title,author from book;
-- 2.	Fetch every student’s no, name & school in descending order by school.--
select no,name,school from student order by school desc;
-- 3.	Fetch any book’s isbn & title where that book’s author contains the string “Smith”.--
select isbn,title from book where author like '%Smith%';
-- 4.	Calculate the latest due date for any book copy.--
select code,max(due) from loan group by code; 
-- 5.	Modify the query from Q4 to now fetch only the student no.--
select student_record.student_no from (select no as student_no,code as c,max(due) as d from loan group by code) as student_record; 


-- 6.	Modify the query from Q5 to also fetch the student name. --
select name, no from student where no in (select student_record.student_no  from 
(select no as student_no,code as c,max(due) as d from loan group by code) as student_record); 

-- 7.	Fetch the student no, copy code & due date for loans in the current year --
-- which have not yet been returned. --
select no,code,due from loan where ret is NULL and YEAR(taken) = YEAR(CURRENT_DATE());
1.	Display the student’s no & 
name along with the due date for loans in the current year
 which have not yet been returned in ascending order by date.
o	Tips . . The WHERE clause is the same as Q7.

select student.no,student.name,due from loan inner join student on student.no=loan.no
where ret is NULL and YEAR(taken) = YEAR(CURRENT_DATE()) order by taken asc;
-- 8.	Uniquely fetch the student no & name along with the book isbn & --
-- title for students who have loaned a 7 day duration book.--
-- o	Tips . . DISTINCT, INNER JOIN--
select distinct (student.no),student.name,book.title,book.isbn from 
loan inner join copy on copy.code=loan.code 
inner join book on copy.isbn=book.isbn
inner join student on student.no=loan.no
where copy.duration=7;
-- 9.	Solve the problem from Q6 using JOINS where possible.--
-- o	Tips . . INNER JOIN, Sub-Query --
select name, no from student inner join 
(select no as student_no,code as c,max(due) as d from loan group by code) as student_record
 on no= student_record.student_no;
-- 10.	Calculate then display the loan frequency for every book. o	Tips . . COUNT(), INNER JOIN, GROUP BY--
select book.isbn,book.title,count(*) as loan_frequency from 
loan inner join copy on copy.code=loan.code 
inner join book on copy.isbn=book.isbn group by book.isbn;
-- 11.	Modify the query from Q10 to only show a book when it has been loaned two or more times. --
select book.isbn,book.title,count(*) as loan_frequency from 
loan inner join copy on copy.code=loan.code 
inner join book on copy.isbn=book.isbn group by book.isbn having loan_frequency>1;