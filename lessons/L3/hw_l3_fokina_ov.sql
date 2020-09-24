
ALTER TABLE vk.likes ADD CONSTRAINT fk_likes_users FOREIGN KEY (user_id) REFERENCES vk.users(id);
ALTER TABLE vk.likes ADD CONSTRAINT fk_likes_medis FOREIGN KEY (media_id) REFERENCES vk.media(id);

DROP TABLE IF EXISTS music_genres;
CREATE TABLE vk.music_genres (
	id SERIAL PRIMARY KEY,
	name varchar(100) NOT NULL UNIQUE
);

DROP TABLE IF EXISTS song_autor;
CREATE TABLE vk.song_autor (
	id SERIAL PRIMARY KEY,
	name varchar(100) NOT NULL UNIQUE,
	INDEX song_autor_name_idx(name)
);

DROP TABLE IF EXISTS song;
CREATE TABLE vk.song(
	id SERIAL PRIMARY KEY,
	name varchar(100) NOT NULL UNIQUE,
	text_song TEXT,
	year SMALLINT,
	id_autor BIGINT UNSIGNED,
	id_music_genres BIGINT UNSIGNED,
	id_media BIGINT UNSIGNED,
	FOREIGN KEY (id_autor) REFERENCES song_autor(id),
	FOREIGN KEY (id_music_genres) REFERENCES music_genres(id),
	FOREIGN KEY (id_media) REFERENCES media(id),
	INDEX song_name_idx(name),
	INDEX song_id_autor_idx(id_autor),
	INDEX song_id_music_genres_idx(id_music_genres)
);

DROP TABLE IF EXISTS playlist;
CREATE TABLE vk.playlist(
	id SERIAL PRIMARY KEY,
	name varchar(100) NOT NULL UNIQUE,
	id_song BIGINT UNSIGNED,
	id_user BIGINT UNSIGNED,
	FOREIGN KEY (id_song) REFERENCES song(id),
	FOREIGN KEY (id_user) REFERENCES users(id),
	INDEX playlist_name_idx(name),
	INDEX playlist_id_song_idx(id_song)
);

