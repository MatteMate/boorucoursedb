-- Додавання записів до таблиці uploader
INSERT INTO uploader (name, reg_date, status, is_admin, description, uploads, reputation) 
VALUES 
('User123', '2024-10-01', 0, 0, 'Newbie', 25, 100),
('Shine', '2024-09-10', 1, 1, 'Administrator', 10, 500);
GO

-- Додавання записів до таблиці content
INSERT INTO content (name, size, width, height, description, type, extension, length, sound, upload_time, uploader_id)
VALUES 
('Frieren', 1650, 3000, 3408, 'Art with Frieren', '0', 'jpg', NULL, NULL, '2024-10-15 10:30:00', 1),
('Frieren and Fern', 1140, 1806, 1096, 'Art with Frieren and Fern', '0', 'jpg', NULL, NULL, '2024-10-07 12:00:00', 2),
('Hitori', 630, 1618, 2048, 'Art with Hitori', '0', 'jpg', NULL, NULL, '2024-01-11 11:00:00', 2);
GO

-- Додавання записів до таблиці tags
INSERT INTO tags (tag_type, tag, description)
VALUES 
(3, 'girl', 'Tag related to content with girls'),
(2, 'fern', 'Tag related to content with Fern from "Frieren: Beyond Journey''s End"'),
(2, 'frieren', 'Tag related to content with Frieren from "Frieren: Beyond Journey''s End"'),
(1, 'sousou no frieren', 'Tag related to content from "Frieren: Beyond Journey''s End"'),
(0, 'senji', 'Tag for content made by senji'),
(0, 'quasarcake', 'Tag for content made by quasarcake'),
(2, 'hitori gotoh', 'Tag related to content with Hitori from "Bocchi the rock!"'),
(1, 'bocchi the rock', 'Tag related to content from "Bocchi the rock!"');
GO

-- Додавання записів до таблиці comments
INSERT INTO comments (comment, uploader_id)
VALUES 
('Wonderful picture!', 2),
('I love this character!', 1),
('Great work!', 1),
('Amazing!', 1),
('I''d love to see more of that.', 2);
GO

-- Додавання записів до таблиці post
INSERT INTO post (content_id, likes, rating)
VALUES 
(1, 150, 0),
(2, 200, 0),
(3, 220, 0);

-- Додавання тегів до постів
INSERT INTO post_tags (post_id, tag_id)
VALUES 
(1, 1),
(1, 3),
(1, 4),
(1, 5),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(2, 6),
(3, 1),
(3, 5),
(3, 6),
(3, 7);

-- Додавання коментарів до постів
INSERT INTO post_comments (post_id, comment_id)
VALUES 
(1, 1),
(1, 2),
(2, 4),
(3, 3),
(3, 5);