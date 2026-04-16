import mysql.connector

def initialize_database(schema_file):
    db = mysql.connector.connect(
        host="127.0.0.1",
        user="root",
        password="password",
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
    print("Schema başarıyla uygulandı!")

# Run it
initialize_database('database/schema.sql')