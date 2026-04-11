.PHONY: default install main # Tells make these aren't actual files

default: main

install:
	pip install -r requirements.txt

main: backend/main.py 
	python3 backend/main.py