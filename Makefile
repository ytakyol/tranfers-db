.PHONY: default install main init push pull reset-database setup# Tells make these aren't actual files

default: main

install:
	pip install -r requirements.txt

main: app.py 
	python3 app.py

setup: 
	sudo systemctl start mysql
	python3 init/execute_schema.py

init:
	python3 init/init.py

push:
	git add .
	git commit -F commit.txt
	git push origin main

pull:
	git pull origin main

db:
	mysql -u $(USER) -p < $(FILE)
