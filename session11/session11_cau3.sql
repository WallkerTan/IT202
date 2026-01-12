
USE social_network_pro;
DROP PROCEDURE IF EXISTS CalculateBonusPoints;

DELIMITER $$

CREATE PROCEDURE CalculateBonusPoints(
  IN    p_user_id INT,
  INOUT p_bonus_points INT
)
BEGIN
  DECLARE v_post_count INT DEFAULT 0;

  -- Đếm số bài viết của user
  SELECT COUNT(*) 
  INTO v_post_count
  FROM posts
  WHERE user_id = p_user_id;

  -- Cộng điểm thưởng theo số bài viết
  IF v_post_count >= 20 THEN
    SET p_bonus_points = p_bonus_points + 100;
  ELSEIF v_post_count >= 10 THEN
    SET p_bonus_points = p_bonus_points + 50;
  END IF;
END$$

DELIMITER ;

-- 3) Gọi thủ tục với user cụ thể và điểm khởi đầu
SET @bonus_points = 100;
CALL CalculateBonusPoints(1, @bonus_points);

-- 4) Lấy giá trị p_bonus_points sau khi thủ tục chạy
SELECT @bonus_points AS bonus_points_after_calculation;

-- 5) Xóa thủ tục vừa tạo
DROP PROCEDURE IF EXISTS CalculateBonusPoints;
