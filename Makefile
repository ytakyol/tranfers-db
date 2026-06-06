.PHONY: default install main init push pull reset-database setup# Tells make these aren't actual files

# 1. .env dosyasının varlığını kontrol et ve içeri aktar
ifneq ($(wildcard .env),)
    include .env
    export
endif

# 2. .env boşsa veya yoksa hata vermemesi için varsayılan değerler (opsiyonel)
DB_USER ?= $(DB_USER)
DB_PASS ?= $(DB_PASS)

default: start

install:
	pip install -r requirements.txt

start: app.py 
	python3 app.py

start_mysql: 
	sudo systemctl start mysql

setup:
	python3 init/execute_schema.py
	$(MAKE) db FILE=database/triggers.sql

push:
	git add .
	git commit -F commit.txt
	git push origin main

pull:
	git pull origin main


db:
	mysql -u $(DB_USER) -p$(DB_PASS) < $(FILE)

schemas:
	$(MAKE) db FILE=database/new_schema.sql
	$(MAKE) db FILE=database/player_views.sql
	$(MAKE) db FILE=database/referee_views.sql
	$(MAKE) db FILE=database/manager_views.sql
	$(MAKE) db FILE=database/db_manager_views.sql
	$(MAKE) db FILE=database/initial4.sql
	$(MAKE) db FILE=database/triggers.sql
	echo "Succesfuly finished execution."

