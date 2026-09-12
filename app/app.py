from flask import Flask
import os
import psycopg2

app= Flask(__name__)

@app.route("/")
def home():
    try:
        conn = psycopg2.connect(
            host="db",
            database="appdb",
            user="appuser",
            password="apppassword"
        )
        conn.close()
        db_status = "Database connection successful"
    except Exception as e:
        db_status = "Database connection failed"

    return f"""
    <h1>Hello from Flask!</h1>
    <p>Backend is working.</p>
    <p>{db_status}</p>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
