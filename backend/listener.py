from flask import Flask
import os
import requests

app = Flask(__name__)

@app.route("/")
def hello_world():

    return "I am backend too"


app.run(host='0.0.0.0', port=4000)
