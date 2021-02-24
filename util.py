from dotenv import load_dotenv
import os

def setup_env():
    load_dotenv(verbose=True)

    env = {}

    # extract database credentials from the environment
    env['DATABASE_URI'] = os.getenv('DATABASE_URI')
    env['DATABASE_USER'] = os.getenv('DATABASE_USER')
    env['DATABASE_PASSWORD'] = os.getenv('DATABASE_PASSWORD')

    # extract dataset paths
    env['MovieLensPath'] = os.getenv('MovieLensPath')
    env['IMDbPath'] = os.getenv('IMDbPath')

    return env