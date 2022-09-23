MATCH (m:Movie) RETURN COUNT(m)


MATCH p=(a:Actor)-[ACTED_IN]->(m:Movie {title: 'Toy Story'})<-[DIRECTED]-(d:Director)
RETURN p


MATCH ()-[r:RATE]->(m:Movie {title: 'Avatar'})
RETURN max(toInteger(r.rating)), min(toInteger(r.rating)), avg(toInteger(r.rating))


MATCH (a1:Actor {name: 'Christian Bale'})-[:ACTED_IN]->(m1:Movie)<-[:DIRECTED]-(d:Director)-[:DIRECTED]->(m2:Movie)<-[ACTED_IN]-(a2:Actor {name: 'Michael Caine'})
RETURN count(d)


MATCH (c:Customer {id: 'c000001'})-[:RATE]->(m:Movie)<-[:ACTED_IN]-(a:Actor)
RETURN a, count(a)
ORDER BY count(a) DESC
LIMIT 1


MATCH (c1:Customer {id: 'c000001'})-[:RATE]->(m:Movie)<-[:RATE]-(c2:Customer)
RETURN c2, COUNT(c2)
ORDER BY COUNT(c2) DESC
LIMIT 1

MATCH (c1:Customer {id: 'c000001'})-[:RATE]->(m1:Movie) WITH collect(m1) AS movies
MATCH (c2:Customer {id: 'c072315'})-[r:RATE]->(m2:Movie)
WHERE NOT(m2 IN movies)
RETURN m2, r.rating
ORDER BY r.rating DESC
LIMIT 1


MATCH (c1:Customer {id: 'c072345'})-[:RATE]->(m:Movie)
UNWIND m.genres AS genre
RETURN genre, COUNT(genre)
ORDER BY COUNT(genre) DESC
LIMIT 1

MATCH (c:Customer {id: 'c072345'})-[:RATE]->(m1:Movie) WITH collect(m1) AS movies
MATCH (m2:Movie) WHERE 'Comedy' IN m2.genres AND NOT(m2 in movies) AND EXISTS(m2.IMDb_rating)
RETURN m2, m2.IMDb_rating
ORDER BY m2.IMDb_rating DESC
LIMIT 1


MATCH (n:Movie) WHERE NOT EXISTS(n.IMDb_rating) RETURN count(n)


MATCH (c:Customer {id: 'c033301'})-[:RATE]->(m:Movie)<-[:ACTED_IN]-(a:Actor)
RETURN a, COUNT(a)
ORDER BY COUNT(a) DESC
LIMIT 1

MATCH (c:Customer {id: 'c033301'})-[:RATE]->(m1:Movie) WITH collect(m1) AS movies
MATCH (m2:Movie)<-[:ACTED_IN]-(a:Actor {name: "Grover Richardson"})
WHERE NOT(m2 IN movies)
RETURN m2, m2.IMDb_rating
ORDER BY m2.IMDb_rating DESC
LIMIT 1

MATCH p=(a:Actor)-[:ACTED_IN]->(m:Movie)<-[:DIRECTED]-(d:Director)
RETURN p
LIMIT 25