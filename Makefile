.PHONY: default install main init push pull reset-database setup# Tells make these aren't actual files

default: main

install:
	pip install -r requirements.txt

main: app.py 
	python3 app.py

setup: 
	sudo systemctl start mysql
	$(MAKE) schemas 

push:
	git add .
	git commit -F commit.txt
	git push origin main

pull:
	git pull origin main

db:
	mysql -u $(USER) -p$(PASSWORD) < $(FILE)

schemas:
	$(MAKE) db USER=root PASSWORD=password FILE=database/new_schema.sql
	$(MAKE) db USER=root PASSWORD=password FILE=database/player_views.sql
	$(MAKE) db USER=root PASSWORD=password FILE=database/referee_views.sql
	$(MAKE) db USER=root PASSWORD=password FILE=database/manager_views.sql
	$(MAKE) db USER=root PASSWORD=password FILE=database/db_manager_views.sql
	$(MAKE) db USER=root PASSWORD=password FILE=database/initial.sql
	$(MAKE) db USER=root PASSWORD=password FILE=database/triggers.sql

