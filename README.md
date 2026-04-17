# tranfers-db

## create environment and download the requeirments

```bash
python3 -m venv .venv
source .venv/bin/activate

pip install -r requirements.txt
```

## how to set up the connections:

write the following information in a .env file

```bash
DB_HOST= 127.0.0.1
DB_USER= root
DB_PASS= password
DB_NAME= db
```


## how to set up the database:

```python
# for seting up schema and views
make setup

# for adding triggers
make db FILE = database/triggers.sql 
# write the root password
```

## how to start the server:

```bash
make
```