DELIMITER $$
create procedure check_loan_status(in student_no int, in isbn_in char(17))
begin
	DECLARE finished INTEGER DEFAULT 0;
	Declare copy_found integer default 0;
	DECLARE val_code INT;
	declare emb bit;
    declare loan_duration INT;
	DEClARE curCode
		CURSOR FOR 
			select code from copy where isbn=isbn_in;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;
        
	-- Check if student has embaro --
    select embargo into emb from student where no= student_no;
    if (emb <=>1) then 
		signal sqlstate '45000'
			Set message_text="Student No has a ban placed on them";
	End if;
	
    -- Get all copies of the book --
    open curCode;
    getCopy: LOOP
    FETCH curCode INTO val_code;
		IF finished = 1 THEN 
			LEAVE getCopy;
		END IF;
        select count(*) into copy_found from loan where ret is NULL and code=val_code;

		if (copy_found <=>0) then
			select duration into loan_duration from copy where code = val_code;
			insert into loan values (val_code,student_no, CURDATE(), CURDATE()+loan_duration, NULL);
			LEAVE getCopy;
		End if;
	END LOOP getCopy;
	CLOSE curCode;
	if (copy_found >0) then 
		signal sqlstate '45000'
			Set message_text="Unfortunately no copies of book available";
	End if;
END$$

DELIMITER ;