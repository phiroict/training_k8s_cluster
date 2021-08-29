from flask import Flask
import os
import requests

app = Flask(__name__)

@app.route("/")
def hello_world():

    return "I am backend changed as well - 4"


app.run(host='0.0.0.0', port=4000)
