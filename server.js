const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const path = require('path');
const sharp = require('sharp');
const ffmpeg = require('fluent-ffmpeg');
const multer = require('multer');

const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'booru',
    password: '2828137137',
    port: 5432
});

async function getImageDimensions(filePath) {
    try {
        const metadata = await sharp(filePath).metadata();
        return {
            width: metadata.width || 0,
            height: metadata.height || 0
        };
    } catch (err) {
        console.error('Error reading image dimensions:', err);
        return { width: 0, height: 0 };
    }
}

function getVideoDetails(filePath) {
    return new Promise((resolve, reject) => {
        ffmpeg.ffprobe(filePath, (err, metadata) => {
            if (err) return reject(err);

            const videoStream = metadata.streams.find(s => s.codec_type === 'video');
            if (!videoStream) {
                return resolve({ width: 0, height: 0, length: 0, sound: false });
            }
            const audioStream = metadata.streams.find(s => s.codec_type === 'audio');
            resolve({
                width: parseInt(videoStream.width, 10) || 0,
                height: parseInt(videoStream.height, 10) || 0,
                length: parseFloat(metadata.format.duration) || 0,
                sound: !!audioStream
            });
        });
    });
}

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, path.join(__dirname, 'public', 'posts'));
    },
    filename: (req, file, cb) => {
        cb(null, file.originalname);
    }
});
const upload = multer({ storage: storage });

app.get('/', (req, res) => {
    res.send('Server is up and running!');
});

app.get('/api/posts', async (req, res) => {
    try {
        const query = `
            SELECT
                p.post_id,
                c.name,
                c.path_to_file,
                c.size,
                c.width,
                c.height,
                c.upload_time,
                u.name AS uploader_name,
                c.description,
                p.likes,
                CASE 
                    WHEN p.rating = false THEN 'General'
                    WHEN p.rating = true THEN 'Sensitive'
                END AS rating,
                ARRAY_AGG(DISTINCT CASE WHEN t.tag_type = 0 THEN t.tag END) AS artist_tags,
                ARRAY_AGG(DISTINCT CASE WHEN t.tag_type = 1 THEN t.tag END) AS copyrights_tags,
                ARRAY_AGG(DISTINCT CASE WHEN t.tag_type = 2 THEN t.tag END) AS character_tags,
                ARRAY_AGG(DISTINCT CASE WHEN t.tag_type = 3 THEN t.tag END) AS general_tags,
                COALESCE(
                    JSON_AGG(
                        DISTINCT jsonb_build_object('author', u2.name, 'text', co.comment)
                    ) FILTER (WHERE co.comment IS NOT NULL), '[]'
                ) AS comments,
                ARRAY_AGG(DISTINCT jsonb_build_object('tag', t.tag, 'description', t.description)) AS tag_descriptions,
                u.reg_date,
                CASE 
                    WHEN u.status = true THEN 'Online'
                    WHEN u.status = false THEN 'Offline'
                END AS status,
                CASE 
                    WHEN u.is_admin = true THEN 'Admin'
                    WHEN u.is_admin = false THEN 'User'
                END AS role,
                u.description AS user_description,
                u.uploads,
                u.reputation
            FROM post p
            JOIN content c ON p.content_id = c.content_id
            LEFT JOIN post_tags pt ON p.post_id = pt.post_id
            LEFT JOIN tags t ON pt.tag_id = t.tag_id
            LEFT JOIN post_comments pc ON p.post_id = pc.post_id
            LEFT JOIN comments co ON pc.comment_id = co.comment_id
            LEFT JOIN uploader u ON c.uploader_id = u.uploader_id
            LEFT JOIN uploader u2 ON co.uploader_id = u2.uploader_id
            GROUP BY p.post_id, c.name, c.path_to_file, c.size, c.width, c.height, c.upload_time, 
                     u.name, c.description, p.likes, p.rating, u.reg_date, u.status, u.is_admin, 
                     u.description, u.uploads, u.reputation
            ORDER BY p.post_id DESC;
        `;
        const result = await pool.query(query);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error fetching posts');
    }
});

app.get('/api/uploaders', async (req, res) => {
    try {
        const result = await pool.query('SELECT uploader_id, name FROM uploader');
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error fetching uploaders');
    }
});

app.get('/api/tags', async (req, res) => {
    try {
        const query = 'SELECT tag_id, tag FROM tags ORDER BY tag';
        const result = await pool.query(query);
        res.json(result.rows);
    } catch (err) {
        console.error('Error fetching tags:', err);
        res.status(500).send('Error fetching tags');
    }
});

app.post('/api/upload', upload.single('file'), async (req, res) => {
    console.log('Request received at /api/upload');

    console.log('Request Body:', req.body);
    console.log('Uploaded File:', req.file);

    const { uploader, likes, sensitive, tags } = req.body;
    const file = req.file;

    if (!file) {
        console.log('No file uploaded');
        return res.status(400).send('No file uploaded');
    }

    const { size, path: filePath, originalname } = file;
    const extension = filePath.split('.').pop().toLowerCase();
    console.log('File Extension:', extension);

    const allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webm', 'mp4', 'avi', 'mkv'];
    if (!allowedExtensions.includes(extension)) {
        console.log('Invalid file extension');
        return res.status(400).send('Invalid file extension');
    }

    let width, height, length, sound;
    if (['mp4', 'avi', 'mkv', 'webm'].includes(extension)) {
        ({ width, height, length, sound } = await getVideoDetails(filePath));
    } else {
        ({ width, height } = await getImageDimensions(filePath));
        length = null;
        sound = false;
    }

    try {
        console.log('Inserting content into database');
        const contentResult = await pool.query(
            `INSERT INTO content 
             (name, path_to_file, size, width, height, type, extension, length, sound, upload_time, uploader_id)
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, NOW(), $10) RETURNING content_id`,
            [
                originalname,
                filePath,
                size,
                width,
                height,
                ['mp4', 'avi', 'mkv', 'webm'].includes(extension),
                extension,
                length,
                sound,
                uploader
            ]
        );

        const contentId = contentResult.rows[0].content_id;
        console.log('Content inserted with ID:', contentId);

        console.log('Inserting post into database');
        const postResult = await pool.query(
            `INSERT INTO post (content_id, likes, rating, sensitive) 
             VALUES ($1, $2, $3, $4) 
             RETURNING post_id`,
            [contentId, likes, false, sensitive]
        );
        const postId = postResult.rows[0].post_id;
        console.log('Post inserted with ID:', postId);

        const tagList = tags
            ? tags.split(',').map(t => t.trim()).filter(t => t !== '')
            : [];

        for (const tag of tagList) {
            const tagResult = await pool.query('SELECT tag_id FROM tags WHERE tag = $1', [tag]);
            if (tagResult.rows.length > 0) {
                const tagId = tagResult.rows[0].tag_id;
                await pool.query('INSERT INTO post_tags (post_id, tag_id) VALUES ($1, $2)', [postId, tagId]);
            }
        }

        res.status(200).send('Post uploaded successfully');
    } catch (err) {
        console.error('Error during upload process:', err);
        res.status(500).send('Error uploading post');
    }
});

app.post('/api/comments', async (req, res) => {
    const { comment, uploader_id, post_id } = req.body;
    try {
        const insertCommentQuery = 'INSERT INTO comments (comment, uploader_id) VALUES ($1, $2) RETURNING comment_id';
        const commentResult = await pool.query(insertCommentQuery, [comment, uploader_id]);
        const commentId = commentResult.rows[0].comment_id;

        // Insert the new comment into the post_comments table
        const insertPostCommentQuery = 'INSERT INTO post_comments (post_id, comment_id) VALUES ($1, $2)';
        await pool.query(insertPostCommentQuery, [post_id, commentId]);

        res.status(201).send('Comment added successfully');
    } catch (err) {
        console.error('Error adding comment:', err);
        res.status(500).send('Error adding comment');
    }
});

app.post('/api/tags', async (req, res) => {
    const { tag, description, tag_type } = req.body;
    try {
        const checkQuery = 'SELECT tag_id FROM tags WHERE tag = $1';
        const checkResult = await pool.query(checkQuery, [tag]);

        if (checkResult.rows.length > 0) {
            return res.status(400).send('Tag already exists');
        }

        const insertQuery = 'INSERT INTO tags (tag, description, tag_type) VALUES ($1, $2, $3)';
        await pool.query(insertQuery, [tag, description, tag_type]);
        res.status(201).send('Tag added successfully');
    } catch (err) {
        console.error('Error adding tag:', err);
        res.status(500).send('Error adding tag');
    }
});

app.post('/api/uploaders', async (req, res) => {
    const { name, description, reputation, status, is_admin, reg_date } = req.body;
    try {
        const query = 'INSERT INTO uploader (name, description, reputation, status, is_admin, reg_date, uploads) VALUES ($1, $2, $3, $4, $5, $6, 0)';
        await pool.query(query, [name, description, reputation, status, is_admin, reg_date]);
        res.status(201).send('Uploader added successfully');
    } catch (err) {
        console.error('Error adding uploader:', err);
        res.status(500).send('Error adding uploader');
    }
});

app.listen(PORT, () => {
    console.log(`Server is running at http://localhost:${PORT}`);
});