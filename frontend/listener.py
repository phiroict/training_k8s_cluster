from flask import Flask
import os
import requests

app = Flask(__name__)
backend_service = os.getenv('BACKEND_SERVICE', 'localhost')
backend_port = os.getenv('BACKEND_PORT', '4000')

@app.route("/")
def hello_world():
    response = requests.get("http://{}:{}".format(backend_service, backend_port))
    return response.text


app.run(host='0.0.0.0', port=5000)
