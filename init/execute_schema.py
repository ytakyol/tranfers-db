import mysql.connector
import os
from dotenv import load_dotenv

# .env dosyasındaki değişkenleri yükle
load_dotenv()

def initialize_database(schema_file):
    db = mysql.connector.connect(
        host=os.getenv("DB_HOST", "127.0.0.1"),
        user=os.getenv("DB_USER", "root"),
        password=os.getenv("DB_PASS", "password")
    )
    
    cursor = db.cursor()

    with open(schema_file, 'r', encoding='utf-8') as f:
        # SQL dosyasını oku ve ; işaretine göre parçala
        sql_commands = f.read().split(';')

    for command in sql_commands:
        # Boş satırları veya sadece boşluktan oluşan komutları atla
        if command.strip():
            try:
                cursor.execute(command)
            except Exception as e:
                print(f"Sorgu çalıştırılamadı: {command[:50]}...")
                print(f"Hata: {e}")

    db.commit()
    cursor.close()
    db.close()
    print("Schema başarıyla uygulandı: " + schema_file)

if __name__ == "__main__":
    # Run it
    initialize_database('database/new_schema.sql')

    initialize_database('database/player_views.sql')
    initialize_database('database/referee_views.sql')
    initialize_database('database/manager_views.sql')
    initialize_database('database/db_manager_views.sql')
    
    initialize_database('database/initial3.sql')

    # dont add triggers  add it by hand via make db