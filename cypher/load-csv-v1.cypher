// Step 0: Copy required csv files into neo4j import folder
// Following step 1 & 2 in this tutorial: https://neo4j.com/developer/desktop-csv-import/#loading-data


// Step 1: Enforce constraints on data models
// Making sure that ids are unique and build index for them
CREATE CONSTRAINT UniqueMovieId ON (m:Movie) ASSERT m.id IS UNIQUE;
// CREATE CONSTRAINT UniqueImdbId ON (m:Movie) ASSERT m.imdbId IS UNIQUE;
// CREATE CONSTRAINT UniqueTmdbId ON (m:Movie) ASSERT m.tmdbId IS UNIQUE;
CREATE CONSTRAINT UniqueCustomerId ON (c:Customer) ASSERT c.id IS UNIQUE;
CREATE CONSTRAINT UniqueActorId ON (a:Actor) ASSERT a.id IS UNIQUE;
CREATE CONSTRAINT UniqueDirectorId ON (d:Director) ASSERT d.id IS UNIQUE;

// Step 2: Load links.csv, creating movies nodes with ids
LOAD CSV WITH HEADERS FROM 'file:///links.csv' AS row
WITH row WHERE row.tmdbId IS NOT NULL
WITH toInteger(row.movieId) AS movieId, 
     toInteger(row.imdbId) AS imdbId, 
     toInteger(row.tmdbId) AS tmdbId
MERGE (m: Movie {id: movieId})
  SET m.imdbId = imdbId, m.tmdbId = tmdbId
RETURN count(m);

// Step 3: Load movies.csv, setting movie titles and genre
LOAD CSV WITH HEADERS FROM 'file:///movies.csv' AS row
WITH row WHERE size(row.title) > 7
WITH size(row.title) AS length, row
WITH toInteger(substring(row.title, length - 5, length - 2)) AS year,
     substring(row.title, 0, length - 7) AS title,
     split(row.generes, '|') AS generes,
     row.movieId AS id
MERGE (m: Movie {id: id})
  SET m.title = title, m.year = year, m.generes = generes
RETURN count(m);