// Easy questions
// a. What is the min and max of the ratings of Avatar?
MATCH (m:Movie)
WHERE m.title = 'Avatar'
RETURN max(m.rating)

MATCH (m:Movie)
WHERE m.title = 'Avatar'
RETURN min(m.rating)

MATCH (m:Movie)
WHERE m.title = 'Avatar'
RETURN avg(m.rating)

// b. How many null values are there in the rating features of movies?
MATCH (m:Movie)
WHERE m.rating = null
RETURN count(*)

// c. How many movies are there in the database?
MATCH (m:Movie)
RETURN count(*)

// d. How many movies actor A and B both acted in?
MATCH (a:Actor {name: 'Christian Bale'})-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(b:Actor {name: 'Michael Caine'})
RETURN count(m)

// Moderate questions
// a. What is the average rating of Avatar from MovieLens, Internet Movie Database and The Movie Database?
MATCH (m:Movie)
WHERE m.title = 'Avatar'
RETURN avg(m.ML_rating + m.IMDB_rating + m.MD_rating)

// b. What is the relationship between the rating of an actor’s movie with that actor’s year of experience?
MATCH (a:Actor)-[:ACTED_IN]->(m:Movie)
RETURN m.year, m.rating
// Data points queried from Cypher will be further plotted into a graph using Python

// c. After producing a movie with a director, what percentages of actors would work with that director again within 5 years?
(MATCH (a:Actor)-[:ACTED_IN]->(m1:Movie)<-[:DIRECTED]-(d:Director),
(a:Actor)-[:ACTED_IN]->(m2:Movie)<-[:DIRECTED]-(d:Director)
WHERE abs(m1.released_year - m2.released_year) < 5
RETURN count(*))
/
(MATCH (a:Actor)-[:ACTED_IN]->(m:Movie)<-[:DIRECTED]-(d:Director)
RETURN count(*))

MATCH (a:Actor)-[:ACTED_IN]->(m1:Movie)<-[:DIRECTED]-(d:Director),
(a:Actor)-[:ACTED_IN]->(m2:Movie)<-[:DIRECTED]-(d:Director)
WHERE abs(m1.released_year - m2.released_year) < 5
RETURN count(*)

MATCH (w1:Worker-[:ACTED_IN]->(m1:Movie)<-[:DIRECTED]-(w2:Worker),

CREATE (p:Actor:Director)-[:ACTED_IN]->(m:Movie),
       (p)-[:DIRECTED]->

CREATE 


