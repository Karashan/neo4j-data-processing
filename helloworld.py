from neo4j import GraphDatabase
from dotenv import load_dotenv

import os


class App:

    def __init__(self, uri, user, password):
        """Establish database connection and initialize driver"""
        self.driver = GraphDatabase.driver(uri, auth=(user, password))

    def close(self):
        """Close database connection"""
        self.driver.close()

    def print_movie_by_name(self, movie_name):
        """Print information of the movie specified by the movie name"""
        with self.driver.session() as session:
            movie = session.read_transaction(
                self._match_movie_by_name, movie_name)
            print(
                f"Movie {movie['title']} is released in year {movie['released']} with tagline {movie['tagline']}.")

    @staticmethod
    def _match_movie_by_name(tx, movie_name):
        """Execute Cypher to retreive the movie by its name"""
        result = tx.run("""MATCH (m: Movie)
                        WHERE m.title = $movie_name
                        RETURN m""", movie_name=movie_name)

        # return result.data()[0]['m']
        return result.single()[0]


if __name__ == "__main__":
    # load variables in the .env file to the system
    load_dotenv(verbose=True)

    # extract database credentials from the environment
    DATABASE_URI = os.getenv('DATABASE_URI')
    DATABASE_USER = os.getenv('DATABASE_USER')
    DATABASE_PASSWORD = os.getenv('DATABASE_PASSWORD')

    # Create App isntance and execute queries
    app = App(DATABASE_URI, DATABASE_USER, DATABASE_PASSWORD)
    app.print_movie_by_name("The Matrix")
    app.close()
