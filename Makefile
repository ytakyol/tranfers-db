.PHONY: default install main # Tells make these aren't actual files

default: main

install:
	pip install -r requirements.txt

main: app/app.py 
	python3 app/app.py