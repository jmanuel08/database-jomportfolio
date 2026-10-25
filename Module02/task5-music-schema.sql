CREATE TABLE band (
    band_id INTEGER PRIMARY KEY,
    band_name TEXT NOT NULL
);

CREATE TABLE logo (
    logo_id INTEGER PRIMARY KEY,
    band_id INTEGER UNIQUE NOT NULL,
    logo_name TEXT,
    FOREIGN KEY (band_id) REFERENCES band(band_id)
);

CREATE TABLE album (
    album_id INTEGER PRIMARY KEY,
    band_id INTEGER NOT NULL,
    album_title TEXT NOT NULL,
    FOREIGN KEY (band_id) REFERENCES band(band_id)
);

CREATE TABLE song (
    song_id INTEGER PRIMARY KEY,
    song_title TEXT NOT NULL
);

CREATE TABLE concert_track (
    album_id INTEGER NOT NULL,
    song_id INTEGER NOT NULL,
    track_number INTEGER NOT NULL,
    PRIMARY KEY (album_id, song_id),
    FOREIGN KEY (album_id) REFERENCES album(album_id),
    FOREIGN KEY (song_id) REFERENCES song(song_id)
);

CREATE TABLE venue (
    venue_id INTEGER PRIMARY KEY,
    venue_name TEXT NOT NULL
);

CREATE TABLE musician (
    musician_id INTEGER PRIMARY KEY,
    musician_name TEXT NOT NULL
);

CREATE TABLE concert (
    concert_id INTEGER PRIMARY KEY,
    venue_id INTEGER NOT NULL,
    FOREIGN KEY (venue_id) REFERENCES venue(venue_id)
);

CREATE TABLE musician_concert (
    musician_id INTEGER NOT NULL,
    concert_id INTEGER NOT NULL,
    PRIMARY KEY (musician_id, concert_id),
    FOREIGN KEY (musician_id) REFERENCES musician(musician_id),
    FOREIGN KEY (concert_id) REFERENCES concert(concert_id)
);
