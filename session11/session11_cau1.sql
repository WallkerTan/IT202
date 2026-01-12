
DROP PROCEDURE IF EXISTS sp_get_posts_by_user;

DELIMITER $$

CREATE PROCEDURE sp_get_posts_by_user(IN p_user_id INT)
BEGIN
  SELECT
    post_id   AS PostID,
    content   AS `Nội dung`,
    created_at AS `Thời gian tạo`
  FROM posts
  WHERE user_id = p_user_id
  ORDER BY created_at DESC, post_id DESC;
END$$

DELIMITER ;
CALL sp_get_posts_by_user(7);

DROP PROCEDURE IF EXISTS sp_get_posts_by_user;
