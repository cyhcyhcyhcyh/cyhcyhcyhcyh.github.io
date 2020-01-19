# 在user_template表给每个分配了模板的人增加共同联系人个人模板，使其顺序排在直接关系后面
# 将非直接关系和全部关系模板display_order + 1, 然后先删后建共同联系人模板
DELIMITER //
CREATE PROCEDURE testcyh()
BEGIN
	DECLARE old_id INT;
	DECLARE old_order INT;
	DECLARE flag INT DEFAULT 0;
	DECLARE s_list CURSOR FOR SELECT id FROM user_login WHERE EXISTS (SELECT 1 FROM user_template WHERE user_id = user_login.id);
	DECLARE s_id CURSOR FOR SELECT display_order FROM user_template WHERE user_id = old_id AND global_template_id = 59;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET flag = 1;
	OPEN s_list;
		FETCH s_list INTO old_id;
		WHILE flag <> 1 DO
			OPEN s_id;
				FETCH s_id INTO old_order;
				IF (old_order IS NOT NULL)
				THEN
					DELETE FROM user_template WHERE global_template_id = 97 AND user_id = old_id;
					UPDATE user_template SET display_order = display_order+1 WHERE global_template_id NOT IN (149,159,49,59) AND user_id = old_id;
					INSERT INTO user_template(user_id, title, description, global_template_id, display_order, visible, setting_type, ext_type, update_time, create_time) VALUES(old_id, '搜索共同联系人', '二度搜索找出共同联系人', 97, old_order, 1, 'com.sophon.object.SameContactPerson', 3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
				END IF;
			CLOSE s_id;
			SET flag = 0;
			FETCH s_list INTO old_id;
		END WHILE;
	CLOSE s_list;
END
//
DELIMITER ;
CALL testcyh();
# DROP PROCEDURE if exists testcyh;
