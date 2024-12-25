document.addEventListener('DOMContentLoaded', async () => {
    const postContainer = document.getElementById('post-container');
    const infoModal = document.getElementById('tag-info-modal'); // Модальне вікно для опису тегу або користувача
    const infoText = document.getElementById('tag-info-text'); // Текстовий елемент для опису
    const closeInfo = document.getElementById('close-tag-info'); // Кнопка закриття модального вікна


    // Перевірка існування кнопки закриття для модального вікна
    if (closeInfo) {
        closeInfo.addEventListener('click', () => {
            infoModal.style.display = 'none';
        });
    }

    try {
        // Виконуємо запит до API
        const response = await fetch('/api/posts');
        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const posts = await response.json();

        if (posts.length === 0) {
            postContainer.innerHTML = '<p>No posts found.</p>';
            return;
        }

        // Підраховуємо кількість постів для кожного тегу
        const tagCount = {
            artist: {},
            copyrights: {},
            character: {},
            general: {}
        };

        posts.forEach(post => {
            post.artist_tags?.forEach(tag => tagCount.artist[tag] = (tagCount.artist[tag] || 0) + 1);
            post.copyrights_tags?.forEach(tag => tagCount.copyrights[tag] = (tagCount.copyrights[tag] || 0) + 1);
            post.character_tags?.forEach(tag => tagCount.character[tag] = (tagCount.character[tag] || 0) + 1);
            post.general_tags?.forEach(tag => tagCount.general[tag] = (tagCount.general[tag] || 0) + 1);
        });

        // Додаємо пости
        posts.forEach(post => {
            const postElement = document.createElement('div');
            postElement.classList.add('post');

            // Шлях до зображення
            const imgPath = post.path_to_file.replace(/^.*[\\\/]/, 'posts/'); // Замінюємо шлях

            // Функція для обробки тегів без останньої коми та null значень
            const formatTags = (tags, tagClass) => {
                tags = tags.filter(tag => tag != null);
                if (tags.length === 0) return '';

                return tags
                    .slice(0, -1)
                    .map(tag => `<span class="${tagClass}" data-tag="${tag}">${tag} (${tagCount[tagClass][tag] || 0})</span>`)
                    .join(', ') + (tags.length > 1 ? ', ' : '') + `<span class="${tagClass}" data-tag="${tags[tags.length - 1]}">${tags[tags.length - 1]} (${tagCount[tagClass][tags[tags.length - 1]] || 0})</span>`;
            };

            postElement.innerHTML = `
                <div class="image-container">
                    <img src="${imgPath}" alt="${post.name}">
                </div>
                <div class="post-details">
                    <h3>${post.name}</h3>
                    <p>${post.description}</p>
                    <p><strong>Likes:</strong> ${post.likes}</p>
                    <p><strong>Uploader:</strong> <span class="user-name" data-username="${post.uploader_name}">${post.uploader_name}</span></p>
                    <p><strong>Size:</strong> ${post.size} kB</p>
                    <p><strong>Dimensions:</strong> ${post.width} x ${post.height}</p>
                    <p><strong>Upload Time:</strong> ${new Date(post.upload_time).toLocaleString()}</p>
                    <p><strong>Rating:</strong> ${post.rating}</p>

                    <!-- Теги: 4 колонки -->
                    <div class="tags">
                        <div class="tags-column">
                            <h4>Artist</h4>
                            <p>${formatTags(post.artist_tags, 'artist')}</p>
                        </div>
                        <div class="tags-column">
                            <h4>Copyrights</h4>
                            <p>${formatTags(post.copyrights_tags, 'copyrights')}</p>
                        </div>
                        <div class="tags-column">
                            <h4>Character</h4>
                            <p>${formatTags(post.character_tags, 'character')}</p>
                        </div>
                        <div class="tags-column">
                            <h4>General</h4>
                            <p>${formatTags(post.general_tags, 'general')}</p>
                        </div>
                    </div>

                    <div class="comments">
                        <strong>Comments:</strong>
                        <ul>
                            ${post.comments.map(comment => `<li class="user-name" data-username="${comment.author}">${comment.author}: ${comment.text}</li>`).join('')}
                        </ul>
                    </div>
                </div>
            `;
            postContainer.appendChild(postElement);

            // Обробка кліку на ім'я користувача в пості
            const userNameElement = postElement.querySelector('.user-name');
            if (userNameElement) {
                userNameElement.addEventListener('click', () => {
                    const username = userNameElement.getAttribute('data-username');
                    // Відображаємо модальне вікно з інформацією про користувача
                    const user = posts.find(p => p.uploader_name === username); // Знаходимо користувача

                    if (user) {
                        infoText.innerHTML = `
                            <h2>User Information</h2>
                            <p><strong>Username:</strong> ${username}</p>
                            <p><strong>Additional Info:</strong> ${user.user_description}</p>
                            <p><strong>Status:</strong> ${user.status}</p>
                            <p><strong>Role:</strong> ${user.role}</p>
                            <p><strong>Uploads:</strong> ${user.uploads}</p>
                            <p><strong>Reputation:</strong> ${user.reputation}</p>
                        `;

                        // Позиціонуємо модальне вікно справа від курсора
                        const rect = userNameElement.getBoundingClientRect();
                        infoModal.style.left = `${rect.left + window.scrollX + userNameElement.offsetWidth + 5}px`;
                        infoModal.style.top = `${rect.top + window.scrollY}px`;

                        infoModal.style.display = 'block';
                    }
                });
            }

            // Обробка кліку на ім'я користувача в коментарях
            const commentUserElements = postElement.querySelectorAll('.comments .user-name');
            commentUserElements.forEach(commentUserElement => {
                commentUserElement.addEventListener('click', () => {
                    const username = commentUserElement.getAttribute('data-username');
                    // Відображаємо модальне вікно з інформацією про користувача
                    const user = posts.find(p => p.uploader_name === username); // Знаходимо користувача

                    if (user) {
                        infoText.innerHTML = `
                            <h2>User Information</h2>
                            <p><strong>Username:</strong> ${username}</p>
                            <p><strong>Additional Info:</strong> ${user.user_description}</p>
                            <p><strong>Status:</strong> ${user.status}</p>
                            <p><strong>Role:</strong> ${user.role}</p>
                            <p><strong>Uploads:</strong> ${user.uploads}</p>
                            <p><strong>Reputation:</strong> ${user.reputation}</p>
                        `;

                        // Позиціонуємо модальне вікно справа від курсора
                        const rect = commentUserElement.getBoundingClientRect();
                        infoModal.style.left = `${rect.left + window.scrollX + commentUserElement.offsetWidth + 5}px`;
                        infoModal.style.top = `${rect.top + window.scrollY}px`;

                        infoModal.style.display = 'block';
                    }
                });
            });

            // Обробка наведення на тег
            const tags = postElement.querySelectorAll('.tags span');
            tags.forEach(tagElement => {
                tagElement.addEventListener('click', () => {
                    const tagName = tagElement.getAttribute('data-tag');
                    const tagInfo = post.tag_descriptions.find(tag => tag.tag === tagName);
                    if (tagInfo) {
                        infoText.innerHTML = `<strong>${tagName}</strong><br>${tagInfo.description}`;

                        // Позиціонуємо модальне вікно справа від курсора
                        const rect = tagElement.getBoundingClientRect();
                        infoModal.style.left = `${rect.left + window.scrollX + tagElement.offsetWidth + 5}px`;
                        infoModal.style.top = `${rect.top + window.scrollY}px`;

                        infoModal.style.display = 'block';
                    }
                });
            });
        });
    } catch (err) {
        console.error('Failed to fetch posts:', err);
        postContainer.innerHTML = '<p>Error loading posts. Please try again later.</p>';
    }
});

document.addEventListener('DOMContentLoaded', async () => {
    const openPopupButton = document.getElementById('open-popup');
    const closePopupButton = document.getElementById('close-popup');
    const popup = document.getElementById('upload-post-popup');
    const form = document.getElementById('upload-post-form');
    const fileInput = document.getElementById('file');
    const uploaderSelect = document.getElementById('uploader');
    const tagSelect = document.getElementById('tag-select');
    const selectedTagsContainer = document.getElementById('selected-tags');
    const sensitiveCheckbox = document.getElementById('sensitive');

    // Show popup
    openPopupButton.addEventListener('click', () => {
        popup.style.display = 'block';
    });

    // Hide popup
    closePopupButton.addEventListener('click', () => {
        popup.style.display = 'none';
    });

    // Fetch and populate uploader options
    try {
        const response = await fetch('/api/uploaders');
        if (!response.ok) {
            throw new Error(`Error fetching uploaders: ${response.status}`);
        }
        const uploaders = await response.json();
        uploaders.forEach(uploader => {
            const option = document.createElement('option');
            option.value = uploader.uploader_id;
            option.textContent = uploader.name;
            uploaderSelect.appendChild(option);
        });
    } catch (err) {
        console.error('Failed to fetch uploaders:', err);
    }

    // Fetch and populate tag options
    try {
        const tagResponse = await fetch('/api/tags');
        if (!tagResponse.ok) {
            throw new Error(`Error fetching tags: ${tagResponse.status}`);
        }
        const tags = await tagResponse.json();
        tags.forEach(tag => {
            const option = document.createElement('option');
            option.value = tag.tag_id;
            option.textContent = tag.tag;
            tagSelect.appendChild(option);
        });
    } catch (err) {
        console.error('Failed to fetch tags:', err);
    }

    // Handle tag selection
    tagSelect.addEventListener('change', () => {
        const selectedTag = tagSelect.options[tagSelect.selectedIndex];
        if (selectedTag.value) {
            addTag(selectedTag.textContent, selectedTag.value);
            tagSelect.value = '';
        }
    });

    function addTag(tagName, tagId) {
        const tagElement = document.createElement('div');
        tagElement.className = 'selected-tag';
        tagElement.innerHTML = `<span>${tagName}</span><button type="button" data-tag-id="${tagId}">x</button>`;
        selectedTagsContainer.appendChild(tagElement);

        // Handle tag removal
        const removeBtn = tagElement.querySelector('button');
        removeBtn.addEventListener('click', () => {
            selectedTagsContainer.removeChild(tagElement);
        });
    }

    form.addEventListener('submit', async (event) => {
        event.preventDefault();

        // Debug log: ensures this event is firing
        console.log('Form submission initiated...');

        const formData = new FormData();
        const selectedTags = Array.from(
            selectedTagsContainer.querySelectorAll('.selected-tag button')
        ).map(button => {
            // We’ll append the button's text, not just the ID
            // because our server expects the actual tag text for insertion.
            return button.parentNode.querySelector('span').textContent;
        });

        // Full console output for debugging
        console.log('Selected tags:', selectedTags);

        formData.append('file', fileInput.files[0]);
        formData.append('uploader', uploaderSelect.value);
        formData.append('likes', document.getElementById('likes').value);
        formData.append('sensitive', sensitiveCheckbox.checked);
        // Join tags with commas to match server code
        formData.append('tags', selectedTags.join(','));

        try {
            const response = await fetch('/api/upload', {
                method: 'POST',
                body: formData
            });
            console.log('Upload request sent, awaiting response...');

            if (response.ok) {
                alert('Post uploaded successfully!');
                console.log('Post upload success');
                popup.style.display = 'none';
                // Optionally refresh or fetch the new posts list here
            } else {
                alert('Failed to upload post.');
                console.log('Upload failed with status:', response.status);
            }
        } catch (err) {
            console.error('Error during fetch /api/upload:', err);
        }
    });
});

document.addEventListener('DOMContentLoaded', async () => {
    const openAddTagPopupButton = document.getElementById('open-add-tag-popup');
    const closeAddTagPopupButton = document.getElementById('close-add-tag-popup');
    const addTagPopup = document.getElementById('add-tag-popup');
    const addTagForm = document.getElementById('add-tag-form');

    // Show Add Tag popup
    openAddTagPopupButton.addEventListener('click', () => {
        addTagPopup.style.display = 'block';
    });

    // Hide Add Tag popup
    closeAddTagPopupButton.addEventListener('click', () => {
        addTagPopup.style.display = 'none';
    });

    addTagForm.addEventListener('submit', async (event) => {
        event.preventDefault();

        const tagName = document.getElementById('tag-name').value;
        const tagDescription = document.getElementById('tag-description').value;
        const tagType = document.getElementById('tag-type').value;

        const response = await fetch('/api/tags', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                tag: tagName,
                description: tagDescription,
                tag_type: tagType
            })
        });

        if (response.ok) {
            alert('Tag added successfully!');
            addTagPopup.style.display = 'none';
        } else {
            alert('Failed to add tag.');
        }
    });
});

document.addEventListener('DOMContentLoaded', async () => {
    const openAddCommentPopupButton = document.getElementById('open-add-comment-popup');
    const closeAddCommentPopupButton = document.getElementById('close-add-comment-popup');
    const addCommentPopup = document.getElementById('add-comment-popup');
    const addCommentForm = document.getElementById('add-comment-form');
    const commentAuthorSelect = document.getElementById('comment-author');
    const commentPostSelect = document.getElementById('comment-post');

    // Show Add Comment popup
    openAddCommentPopupButton.addEventListener('click', () => {
        addCommentPopup.style.display = 'block';
    });

    // Hide Add Comment popup
    closeAddCommentPopupButton.addEventListener('click', () => {
        addCommentPopup.style.display = 'none';
    });

    // Fetch and populate author options
    const authorResponse = await fetch('/api/uploaders');
    const authors = await authorResponse.json();
    authors.forEach(author => {
        const option = document.createElement('option');
        option.value = author.uploader_id;
        option.textContent = author.name;
        commentAuthorSelect.appendChild(option);
    });

    // Fetch and populate post options
    const postResponse = await fetch('/api/posts');
    const posts = await postResponse.json();
    posts.forEach(post => {
        const option = document.createElement('option');
        option.value = post.post_id;
        option.textContent = post.name;
        commentPostSelect.appendChild(option);
    });

    addCommentForm.addEventListener('submit', async (event) => {
        event.preventDefault();

        const commentText = document.getElementById('comment-text').value;
        const commentAuthor = commentAuthorSelect.value;
        const commentPost = commentPostSelect.value;

        const response = await fetch('/api/comments', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                comment: commentText,
                uploader_id: commentAuthor,
                post_id: commentPost
            })
        });

        if (response.ok) {
            alert('Comment added successfully!');
            addCommentPopup.style.display = 'none';
        } else {
            alert('Failed to add comment.');
        }
    });
});

document.addEventListener('DOMContentLoaded', async () => {
    const openAddUploaderPopupButton = document.getElementById('open-add-uploader-popup');
    const closeAddUploaderPopupButton = document.getElementById('close-add-uploader-popup');
    const addUploaderPopup = document.getElementById('add-uploader-popup');
    const addUploaderForm = document.getElementById('add-uploader-form');

    // Show Add Uploader popup
    openAddUploaderPopupButton.addEventListener('click', () => {
        addUploaderPopup.style.display = 'block';
    });

    // Hide Add Uploader popup
    closeAddUploaderPopupButton.addEventListener('click', () => {
        addUploaderPopup.style.display = 'none';
    });

    addUploaderForm.addEventListener('submit', async (event) => {
        event.preventDefault();

        const uploaderName = document.getElementById('uploader-name').value;
        const uploaderDescription = document.getElementById('uploader-description').value;
        const uploaderReputation = document.getElementById('uploader-reputation').value;
        const uploaderStatus = document.getElementById('uploader-status').checked;
        const uploaderAdmin = document.getElementById('uploader-admin').checked;
        const regDate = new Date().toISOString();

        const response = await fetch('/api/uploaders', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                name: uploaderName,
                description: uploaderDescription,
                reputation: uploaderReputation,
                status: uploaderStatus,
                is_admin: uploaderAdmin,
                reg_date: regDate
            })
        });

        if (response.ok) {
            alert('Uploader added successfully!');
            addUploaderPopup.style.display = 'none';
        } else {
            alert('Failed to add uploader.');
        }
    });
});