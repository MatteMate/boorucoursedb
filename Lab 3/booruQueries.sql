-- Виведення інформації про пост 1
SELECT 
    p.post_id,
    p.likes,
    p.rating,
    c.name AS content_name,
    c.description AS content_description,
    (
        SELECT STRING_AGG(t.tag, ', ')
        FROM post_tags pt
        JOIN tags t ON pt.tag_id = t.tag_id
        WHERE pt.post_id = p.post_id
        GROUP BY pt.post_id
    ) AS tags,
    (
        SELECT STRING_AGG(co.comment, ' | ')
        FROM post_comments pc
        JOIN comments co ON pc.comment_id = co.comment_id
        WHERE pc.post_id = p.post_id
        GROUP BY pc.post_id
    ) AS comments
FROM 
    post p
JOIN 
    content c ON p.content_id = c.content_id
WHERE 
    p.post_id = 1;

--Пости, у яких використовується тег 3
SELECT 
    p.post_id,
    p.likes,
    p.rating,
    c.name AS content_name,
    c.description AS content_description,
    (
        SELECT STRING_AGG(t.tag, ', ')
        FROM post_tags pt
        JOIN tags t ON pt.tag_id = t.tag_id
        WHERE pt.post_id = p.post_id
        GROUP BY pt.post_id
    ) AS tags,
    (
        SELECT STRING_AGG(co.comment, ' | ')
        FROM post_comments pc
        JOIN comments co ON pc.comment_id = co.comment_id
        WHERE pc.post_id = p.post_id
        GROUP BY pc.post_id
    ) AS comments
FROM 
    post p
JOIN 
    content c ON p.content_id = c.content_id
JOIN 
    post_tags pt ON p.post_id = pt.post_id
WHERE 
    pt.tag_id = 3;

-- Пости, завантажені у жовтні 2024
SELECT 
    p.post_id,
    p.likes,
    p.rating,
    c.name AS content_name,
    c.description AS content_description,
    c.upload_time
FROM 
    post p
JOIN 
    content c ON p.content_id = c.content_id
WHERE 
    c.upload_time >= '2024-10-01' AND c.upload_time < '2024-11-01';

-- Пости з 200 і більше лайками
SELECT 
    p.post_id,
    p.likes,
    p.rating,
    c.name AS content_name,
    c.description AS content_description
FROM 
    post p
JOIN 
    content c ON p.content_id = c.content_id
WHERE 
    p.likes >= 200;

-- Пости, завантажені користувачем з id 2
SELECT 
    p.post_id,
    p.likes,
    p.rating,
    c.name AS content_name,
    c.description AS content_description,
    c.upload_time,
    u.uploader_id,
    u.name AS uploader_name
FROM 
    post p
JOIN 
    content c ON p.content_id = c.content_id
JOIN 
    uploader u ON c.uploader_id = u.uploader_id
WHERE 
    c.uploader_id = 2;

-- Пости, які являють собою фото
SELECT 
    p.post_id,
    p.likes,
    p.rating,
    c.name AS content_name,
    c.description AS content_description,
    c.upload_time
FROM 
    post p
JOIN 
    content c ON p.content_id = c.content_id
WHERE 
    c.type = '0';

-- Пости, розмір яких є більше 1000
SELECT 
    p.post_id,
    p.likes,
    p.rating,
    c.name AS content_name,
    c.description AS content_description,
    c.upload_time,
	c.size
FROM 
    post p
JOIN 
    content c ON p.content_id = c.content_id
WHERE 
    c.size > 1000;

-- Пости, ширина яких більша за 1920, а висота за 1080
SELECT 
    p.post_id,
    p.likes,
    p.rating,
    c.name AS content_name,
    c.description AS content_description,
    c.upload_time,
    c.width,
    c.height
FROM 
    post p
JOIN 
    content c ON p.content_id = c.content_id
WHERE 
    c.width > 1920 AND c.height > 1080;

-- Пости з коментарями від користувача з id 2
SELECT 
    p.post_id,
    p.likes,
    p.rating,
    c.name AS content_name,
    c.description AS content_description,
    co.comment AS user_comment,
    co.uploader_id,
    u.name AS uploader_name
FROM 
    post p
JOIN 
    post_comments pc ON p.post_id = pc.post_id
JOIN 
    comments co ON pc.comment_id = co.comment_id
JOIN 
    content c ON p.content_id = c.content_id
JOIN 
    uploader u ON co.uploader_id = u.uploader_id
WHERE 
    co.uploader_id = 2;

-- Пости, де наявно 2 коментарі і більше
SELECT 
    p.post_id,
    p.likes,
    p.rating,
    c.name AS content_name,
    c.description AS content_description,
    COUNT(co.comment_id) AS comment_count
FROM 
    post p
JOIN 
    post_comments pc ON p.post_id = pc.post_id
JOIN 
    comments co ON pc.comment_id = co.comment_id
JOIN 
    content c ON p.content_id = c.content_id
GROUP BY 
    p.post_id, p.likes, p.rating, c.name, c.description
HAVING 
    COUNT(co.comment_id) >= 2;

-- Вставка запису

-- uploader
INSERT INTO uploader (name, reg_date, status, is_admin, description, uploads, reputation)
VALUES ('ArtFanatic', '2024-11-27', 0, 0, 'Fan of arts', 12, 300);

-- content
INSERT INTO content (name, size, width, height, description, type, extension, length, sound, upload_time, uploader_id)
VALUES ('Sunset Art', 1200, 1920, 1080, 'A beautiful sunset art', 0, 'jpg', NULL, NULL, '2024-11-27 18:00:00', 1);

-- tags
INSERT INTO tags (tag_type, tag, description)
VALUES (2, 'sunset', 'Tag related to sunset-themed content');

-- comments
INSERT INTO comments (comment, uploader_id)
VALUES ('This artwork is so calming!', 1);

-- post
INSERT INTO post (content_id, likes, rating)
VALUES (1, 50, 0);

-- post_tags
INSERT INTO post_tags (post_id, tag_id)
VALUES (1, 21);

-- post_comments
INSERT INTO post_comments (post_id, comment_id)
VALUES (1, 16);

-- Оновлення запису

-- uploader
UPDATE uploader
SET description = 'Trustworthy uploader', uploads = uploads + 1
WHERE uploader_id = 1;

-- content
UPDATE content
SET description = 'Art with Frieren and magic', size = size + 100
WHERE content_id = 1;

-- tags
UPDATE tags
SET description = 'Tag related to content with girls (adult)'
WHERE tag_id = 1;

-- comments
UPDATE comments
SET comment = 'Love it so much!'
WHERE comment_id = 1;

-- post
UPDATE post
SET likes = likes + 10
WHERE post_id = 1;

-- post_tags
UPDATE post_tags
SET tag_id = 22
WHERE post_id = 1 AND tag_id = 21;

-- post_comments
UPDATE post_comments
SET comment_id = 17
WHERE post_id = 1 AND comment_id = 16;

-- Вставка множини записів

-- Створення тимчасової таблиці для масової вставки
CREATE TABLE #temp_uploaders (
    name NVARCHAR(100),
    reg_date DATE,
    status BIT,
    is_admin BIT,
    description NVARCHAR(255),
    uploads INT,
    reputation INT
);

-- Вставка даних
INSERT INTO #temp_uploaders
VALUES 
('User1', '2024-11-01', 0, 0, 'New User', 10, 100),
('User2', '2024-10-20', 0, 1, 'Admin User', 20, 500);

-- Переміщення даних до основної таблиці
INSERT INTO uploader (name, reg_date, status, is_admin, description, uploads, reputation)
SELECT * FROM #temp_uploaders;

-- Видалення тимчасової таблиці
DROP TABLE #temp_uploaders;

-- Пошук за параметрами

DECLARE @ContentName NVARCHAR(100) = 'Frieren';
DECLARE @UploaderID INT = 1;

SELECT * 
FROM content
WHERE (@ContentName IS NULL OR name LIKE '%' + @ContentName + '%')
  AND (@UploaderID IS NULL OR uploader_id = @UploaderID);

-- Пошук за параметрами

DECLARE @TagType INT = 2;
DECLARE @Tag NVARCHAR(100) = 'sunset';

SELECT *
FROM tags
WHERE (@TagType IS NULL OR tag_type = @TagType)
  AND (@Tag IS NULL OR tag LIKE '%' + @Tag + '%');

-- Пошук постів із найбільшою кількістю лайків, пов'язаних з тегом "frieren"
SELECT TOP 5 p.post_id AS PostID, c.name AS ContentName, p.likes, t.tag
FROM post p
JOIN content c ON p.content_id = c.content_id
JOIN post_tags pt ON p.post_id = pt.post_id
JOIN tags t ON pt.tag_id = t.tag_id
WHERE t.tag = 'frieren'
ORDER BY p.likes DESC;

-- Вивести топ-5 користувачів за кількістю завантаженого контенту
SELECT TOP 5 u.uploader_id AS UploaderID, u.name AS UploaderName, u.uploads
FROM uploader u
ORDER BY u.uploads DESC;

-- Пошук контенту, завантаженого в жовтні 2024 року, який є зображенням
DECLARE @StartDate DATETIME = '2024-10-01';
DECLARE @EndDate DATETIME = '2024-10-31';
DECLARE @ContentType BIT = 0;

SELECT c.content_id AS ContentID, c.name AS ContentName, c.upload_time, c.type
FROM content c
WHERE c.upload_time BETWEEN @StartDate AND @EndDate
  AND (@ContentType IS NULL OR c.type = @ContentType)
ORDER BY c.upload_time DESC;

-- Вивести коментарі до постів із рейтингом вище 0
DECLARE @MinRating BIT = 0;

SELECT pc.post_id AS PostID, c.comment, p.rating
FROM post_comments pc
JOIN comments c ON pc.comment_id = c.comment_id
JOIN post p ON pc.post_id = p.post_id
WHERE p.rating > @MinRating
ORDER BY p.rating DESC, pc.post_id;