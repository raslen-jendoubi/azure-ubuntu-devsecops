from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "<h1>Hello from Ubuntu VM!</h1><p>This was built and pushed from a Linux environment.</p>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
