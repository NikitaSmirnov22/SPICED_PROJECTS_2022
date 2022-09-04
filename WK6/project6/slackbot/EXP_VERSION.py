
from sqlalchemy import create_engine
import psycopg2
import requests
import time
time.sleep(10)
import logging
pg = create_engine('postgresql://postgres:1234@postgresdb:5432/tweets', echo=True)
webhook_url = "https://hooks.slack.com/services/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"

data1 = {
    "blocks": [
		{
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": "*Good old Bill 🇺🇸*\nHi! I`m Bill. If you want, you can follow my twitter account! Otherwise, I`m going *_to spam_* here all the time🙂.\nMy fund: https://www.gatesfoundation.org/\nYou can reach me by using this <mailto:bill.gates@gatesfoundation.org|link>."
			},
			"accessory": {
				"type": "image",
				"image_url": "https://image.evoke.org/-/media/Images/Evoke/Contributors/BillGates/BillGates_Headshot.ashx?rev=e0ff333fd52a433a9f33fbd03797ad04&hash=E08025CD7B6E07214B21ED04F7251BD0",
				"alt_text": "#@ck climate change!"
			}
		}
	]
}

tweets_req = pg.execute('''
    SELECT *
    FROM tweets
    LIMIT 1
;
''')

for k in tweets_req:
    k._asdict()
    data = {'blocks': [{
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": "*Good old Bill 🇺🇸*"
            },
            "accessory": {
                "type": "image",
                "image_url": "https://image.evoke.org/-/media/Images/Evoke/Contributors/BillGates/BillGates_Headshot.ashx?rev=e0ff333fd52a433a9f33fbd03797ad04&hash=E08025CD7B6E07214B21ED04F7251BD0",
                "alt_text": "dsd"}
        }],
        'blocks': [{
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": k['text'] + "\nThe sentiment score of the tweet is:" + " " + str(k['sentiment'])
            }
        }]
}
    logging.critical(data)
    requests.post(url=webhook_url, json = data)



