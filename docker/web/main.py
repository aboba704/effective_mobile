from fastapi import FastAPI
import mariadb

app = FastAPI()

def get_db():
    return mariadb.connect(
        host="db",
        user="root",
        password="root",
        database="ServiceDB",
    )

@app.get("/")
def root():
    return {"message": "Web service is running"}

@app.get("/data")
def get_data():
    conn = get_db()
    cur = conn.cursor()
    cur.execute("SELECT * FROM data")
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return rows