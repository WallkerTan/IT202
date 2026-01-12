
USE social_network_pro;
DROP PROCEDURE IF EXISTS CalculatePostLikes;

DELIMITER $$

CREATE PROCEDURE CalculatePostLikes(
  IN  p_post_id INT,
  OUT total_likes INT
)
BEGIN
  SELECT COUNT(*) INTO total_likes
  FROM likes
  WHERE post_id = p_post_id;
END$$

DELIMITER ;

SET @total_likes = 0;
CALL CalculatePostLikes(101, @total_likes);

SELECT @total_likes AS total_likes;

-- 4) Xóa thủ tục vừa tạo
DROP PROCEDURE IF EXISTS CalculatePostLikes;
