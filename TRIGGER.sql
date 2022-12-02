DELIMITER $$
CREATE TRIGGER before_loan_update 
    before UPDATE ON loan
    FOR EACH ROW 
    begin
    if old.due<new.ret
    then
		 INSERT INTO loan_audit 
		 SET action = 'update',
			 code = OLD.code,
			 no = OLD.no,
			 taken=OLD.taken,
			 due=OLD.due,
			 ret=new.ret;
	END IF;
END$$
DELIMITER ;