
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
from sqlalchemy import create_engine
import pymongo
import time

time.sleep(10)
s  = SentimentIntensityAnalyzer()
# Establish a connection to the MongoDB server
client = pymongo.MongoClient(host="mongodb", port=27017)
# Select the database you want to use withing the MongoDB server
db = client.twitter
pg = create_engine('postgresql://postgres:1234@postgresdb:5432/tweets', echo=True)

pg.execute('''
    CREATE TABLE IF NOT EXISTS tweets (
    text VARCHAR(500),
    sentiment NUMERIC
);
''')
docs = db.tweets.find()
for doc in docs:
    sentiment = s.polarity_scores(doc['text'])
    print(sentiment)
    score = sentiment['compound']
    print(doc)
    text = doc['text']
    query = "INSERT INTO tweets VALUES (%s, %s);"
    pg.execute(query, (text, score))
    

