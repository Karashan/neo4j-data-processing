// Step 1: Enforce constraints on data model
// Making sure that ids are unique and build index for them
CREATE CONSTRAINT UniqueMovie ON (m:Movie) ASSERT m.id IS UNIQUE;
CREATE CONSTRAINT UniqueCustomer ON (c:Customer) ASSERT c.id IS UNIQUE;
CREATE CONSTRAINT UniqueActor ON (a:Actor) ASSERT a.id IS UNIQUE;
CREATE CONSTRAINT UniqueDirector ON (d:Director) ASSERT d.id IS UNIQUE;

// Step 2: Load 'movies_info.csv' to create movies nodes
LOAD CSV WITH HEADERS FROM 'file:///movies_info.csv' AS row
MERGE (m: Movie {id: row.imdbId})
    SET m.title = row.movie_title,
        m.year = toInteger(row.movie_year),
        m.genres = split(row.movie_genres, ','), 
        m.IMDb_rating = row.averageRating
RETURN count(m);

// Step 3: Load 'workers_1label_act.csv' to create Actor nodes
LOAD CSV WITH HEADERS FROM 'file:///workers_1label_act.csv' AS row
MERGE (a: Actor {id: row.nconst})
    SET a.name = row.primaryName
RETURN count(a);

// Step 4: Load 'workers_1label_act.csv' to create ACTED_IN relationship
LOAD CSV WITH HEADERS FROM 'file:///workers_1label_act.csv' AS row
MATCH (a: Actor {id: row.nconst})
UNWIND split(row.knownForTitles, ',') AS movieId
MATCH (m:Movie {id: movieId})
MERGE (a)-[rel:ACTED_IN]->(m)
RETURN COUNT(rel);

// Step 5: Load 'workers_1label_act.csv' to create Director nodes
LOAD CSV WITH HEADERS FROM 'file:///workers_1label_direct.csv' AS row
MERGE (d: Director {id: row.nconst})
    SET d.name = row.primaryName
RETURN count(d);

// Step 6: Load 'workers_1label_act.csv' to create DIRECTED relationship
LOAD CSV WITH HEADERS FROM 'file:///workers_1label_direct.csv' AS row
MATCH (d: Director {id: row.nconst})
UNWIND split(row.knownForTitles, ',') AS movieId
MATCH (m:Movie {id: movieId})
MERGE (d)-[rel:DIRECTED]->(m)
RETURN COUNT(rel);

// Step 7: Load 'workers_2labels.csv' to create nodes with both Actor and Director label
LOAD CSV WITH HEADERS FROM 'file:///workers_2labels.csv' AS row
MERGE (n:Actor:Director {id: row.nconst})
    SET n.name = row.primaryName
RETURN count(n);

// Step 8: Load 'workers_2labels.csv' to create both ACTED_IN and DIRECTED relationship
LOAD CSV WITH HEADERS FROM 'file:///workers_2labels.csv' AS row
MATCH (n:Actor:Director {id: row.nconst})
UNWIND split(row.knownForTitles, ',') AS movieId
MATCH (m:Movie {id: movieId})
MERGE (n)-[r1:ACTED_IN]->(m)
MERGE (n)-[r2:DIRECTED]->(m)
RETURN COUNT(r1) + COUNT(r2);

// Step 9: Load 'customer_ratings.csv' to create Customer nodes
LOAD CSV WITH HEADERS FROM 'file:///customer_ratings.csv' AS row
MERGE (c: Customer {id: row.userId})
RETURN COUNT(c);

// Step 10: Load 'customer_ratings.csv' to create RATE relationship
LOAD CSV WITH HEADERS FROM 'file:///customer_ratings.csv' AS row
MATCH (c:Customer {id: row.userId})
MATCH (m:Movie {id: row.imdbId})
CREATE (c)-[r:RATE {rating: row.rating}]->(m)
RETURN COUNT(r);