-- ��������� ���������� ��� ���� 1
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

--�����, � ���� ��������������� ��� 3
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

-- �����, ���������� � ����� 2024
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

-- ����� � 200 � ����� �������
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

-- �����, ���������� ������������ � id 2
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

-- �����, �� ������� ����� ����
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

-- �����, ����� ���� � ����� 1000
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

-- �����, ������ ���� ����� �� 1920, � ������ �� 1080
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

-- ����� � ����������� �� ����������� � id 2
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

-- �����, �� ������ 2 �������� � �����
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
