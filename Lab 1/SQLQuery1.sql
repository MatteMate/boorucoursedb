CREATE DATABASE booru;
GO

USE booru;
GO

CREATE TABLE uploader (
    uploader_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    reg_date DATETIME NOT NULL,
    status BIT NOT NULL,
	is_admin BIT NOT NULL,
    description NVARCHAR(255) NULL,
    uploads INT NOT NULL,
    reputation INT NOT NULL
);
GO


CREATE TABLE content (
    content_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    size INT NOT NULL,
    width INT NOT NULL,
    height INT NOT NULL,
    description NVARCHAR(255) NULL,
    type BIT NOT NULL,
    extension VARCHAR(4) NOT NULL,
    length INT NULL,
    sound BIT NULL,
    upload_time DATETIME NOT NULL,
    uploader_id INT NOT NULL,
    FOREIGN KEY (uploader_id) REFERENCES uploader(uploader_id)
);
GO


CREATE TABLE tags (
    tag_id INT IDENTITY(1,1) PRIMARY KEY,
    tag_type TINYINT NOT NULL CHECK (tag_type BETWEEN 0 AND 3),
    tag NVARCHAR(50) NOT NULL,
    description NVARCHAR(255) NULL
);
GO


CREATE TABLE comments (
    comment_id INT IDENTITY(1,1) PRIMARY KEY,
    comment NVARCHAR(255) NOT NULL,
    uploader_id INT NOT NULL,
    FOREIGN KEY (uploader_id) REFERENCES uploader(uploader_id)
);
GO


CREATE TABLE post (
    post_id INT IDENTITY(1,1) PRIMARY KEY,
    content_id INT NOT NULL,
    likes INT NOT NULL,
    rating BIT NOT NULL,
    FOREIGN KEY (content_id) REFERENCES content(content_id)
);
GO

CREATE TABLE post_tags (
    post_id INT,
    tag_id INT,
    PRIMARY KEY (post_id, tag_id),
    FOREIGN KEY (post_id) REFERENCES post(post_id),
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id)
);
GO

CREATE TABLE post_comments (
    post_id INT,
    comment_id INT,
    PRIMARY KEY (post_id, comment_id),
    FOREIGN KEY (post_id) REFERENCES post(post_id),
    FOREIGN KEY (comment_id) REFERENCES comments(comment_id)
);
GO
