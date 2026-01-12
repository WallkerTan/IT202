-- 1) Sử dụng lại database
USE social_network_pro;

-- 2) Tạo stored procedure: đăng bài + thông báo cho bạn bè accepted (2 chiều)
DROP PROCEDURE IF EXISTS NotifyFriendsOnNewPost;

DELIMITER $$

CREATE PROCEDURE NotifyFriendsOnNewPost(
  IN p_user_id INT,
  IN p_content TEXT
)
BEGIN
  DECLARE v_post_id INT;
  DECLARE v_author_name VARCHAR(100);
  DECLARE v_now DATETIME;

  SET v_now = NOW();

  -- Lấy full_name người đăng
  SELECT full_name INTO v_author_name
  FROM users
  WHERE user_id = p_user_id;

  -- Thêm bài viết mới
  INSERT INTO posts (user_id, content, created_at)
  VALUES (p_user_id, p_content, v_now);

  SET v_post_id = LAST_INSERT_ID();

  -- Gửi thông báo cho tất cả bạn bè accepted (cả 2 chiều), không gửi cho chính mình
  INSERT INTO notifications (user_id, type, content, is_read, created_at)
  SELECT DISTINCT
    f.friend_uid,
    'new_post',
    CONCAT(v_author_name, ' đã đăng một bài viết mới'),
    0,
    v_now
  FROM (
      SELECT friend_id AS friend_uid
      FROM friends
      WHERE user_id = p_user_id AND status = 'accepted'

      UNION

      SELECT user_id AS friend_uid
      FROM friends
      WHERE friend_id = p_user_id AND status = 'accepted'
  ) AS f
  WHERE f.friend_uid <> p_user_id;

  -- Trả về post_id vừa tạo để tiện kiểm tra
  SELECT v_post_id AS new_post_id;
END$$

DELIMITER ;

-- 3) Gọi procedure và thêm bài viết mới
SET @t0 = NOW();
CALL NotifyFriendsOnNewPost(1, 'Test: mình vừa đăng bài mới, thông báo tới bạn bè accepted nhé!');

-- 4) Select ra những thông báo của bài viết vừa đăng (lọc theo thời gian vừa gọi)
SELECT n.notification_id, n.user_id, u.full_name AS receiver_name, n.type, n.content, n.is_read, n.created_at
FROM notifications n
JOIN users u ON u.user_id = n.user_id
WHERE n.type = 'new_post'
  AND n.created_at >= @t0
ORDER BY n.notification_id DESC;

-- (tuỳ chọn) xem bài viết vừa tạo của user 1
SELECT post_id, user_id, content, created_at
FROM posts
WHERE user_id = 1
ORDER BY post_id DESC
LIMIT 1;

-- 5) Xóa thủ tục vừa tạo
DROP PROCEDURE IF EXISTS NotifyFriendsOnNewPost;
