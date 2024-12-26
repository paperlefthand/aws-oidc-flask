from flask import Flask, redirect, url_for, session
from authlib.integrations.flask_client import OAuth
import os
from dotenv import load_dotenv
from os.path import join, dirname

load_dotenv(dotenv_path=join(dirname(__file__), ".env"))

app = Flask(__name__)
app.secret_key = os.urandom(24)  # Use a secure random key in production
oauth = OAuth(app)

oauth.register(
    name="oidc",
    authority=f"https://cognito-idp.ap-northeast-1.amazonaws.com/{os.environ["USER_POOL_ID"]}",
    client_id=os.environ["USER_POOL_CLIENT_ID"],
    client_secret=os.environ["USER_POOL_CLIENT_SECRET"],
    server_metadata_url=f"https://cognito-idp.ap-northeast-1.amazonaws.com/{os.environ["USER_POOL_ID"]}/.well-known/openid-configuration",
    client_kwargs={"scope": "aws.cognito.signin.user.admin email openid phone profile"},
)


@app.route("/")
def index():
    user = session.get("user")
    if user:
        return f'Hello, {user["email"]}. <a href="/logout">Logout</a>'
    else:
        return 'Welcome! Please <a href="/login">Login</a>.'


@app.route("/login")
def login():
    redirect_uri = url_for("authorize", _external=True)
    return oauth.oidc.authorize_redirect(redirect_uri)


@app.route("/authorize")
def authorize():
    token = oauth.oidc.authorize_access_token()
    user = token["userinfo"]
    session["user"] = user
    return redirect(url_for("index"))


@app.route("/logout")
def logout():
    session.pop("user", None)
    return redirect(url_for("index"))
