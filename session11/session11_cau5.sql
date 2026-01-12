-- 1) Sử dụng lại database
USE social_network_pro;

-- 2) Tạo procedure CreatePostWithValidation
DROP PROCEDURE IF EXISTS CreatePostWithValidation;

DELIMITER $$

CREATE PROCEDURE CreatePostWithValidation(
  IN  p_user_id INT,
  IN  p_content TEXT,
  OUT result_message VARCHAR(255)
)
BEGIN
  IF CHAR_LENGTH(p_content) < 5 THEN
    SET result_message = 'Nội dung quá ngắn';
  ELSE
    INSERT INTO posts (user_id, content)
    VALUES (p_user_id, p_content);

    SET result_message = 'Thêm bài viết thành công';
  END IF;
END$$

DELIMITER ;

-- 3) Gọi thủ tục và thử các trường hợp

SET @msg = '';
CALL CreatePostWithValidation(1, 'Hi', @msg);
SELECT @msg AS result_message;

SET @msg = '';
CALL CreatePostWithValidation(1, 'Hôm nay mình học Stored Procedure trong MySQL', @msg);
SELECT @msg AS result_message;

-- 4) Kiểm tra kết quả
SELECT post_id, user_id, content, created_at
FROM posts
WHERE user_id = 1
ORDER BY post_id DESC
LIMIT 5;

-- 5) Xóa thủ tục
DROP PROCEDURE IF EXISTS CreatePostWithValidation;
