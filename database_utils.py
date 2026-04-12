import os
from dotenv import load_dotenv
import mysql.connector
from flask import g

# .env dosyasındaki değişkenleri yükle
load_dotenv()

def get_db():
    if 'db' not in g:
        g.db = mysql.connector.connect(
            host=os.getenv("DB_HOST"), # .env'den çekiyoruz
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASS"),
            database=os.getenv("DB_NAME")
        )
    return g.db

def execute_query(query, params=(), fetch=False):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    # Using parameterized queries to prevent SQL Injection 
    cursor.execute(query, params)
    
    if fetch:
        result = cursor.fetchall()
        cursor.close()
        return result
    
    db.commit()
    cursor.close()
    return None