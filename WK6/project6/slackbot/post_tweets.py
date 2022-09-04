
from sqlalchemy import create_engine
import psycopg2
import requests
import time
time.sleep(10)
import logging
import os

pg = create_engine('postgresql://postgres:password@postgresdb:5432/tweets', echo=True)
webhook_url = os.getenv('WEBHOOK_URL')


tweets_req = pg.execute('''
    SELECT *
    FROM tweets
    LIMIT 1
;
''')

for k in tweets_req:
    k._asdict()
    data = {'text': k['text'] + "\nThe sentiment score of the tweet is:" + " " + str(k['sentiment'])}
    logging.critical(data)
    requests.post(url=webhook_url, json = data)


