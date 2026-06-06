# tranfers-db

## create environment and download the requeirments

```bash
python3 -m venv .venv
source .venv/bin/activate

pip install -r requirements.txt
```

## how to set up the connections:

write the following information in a .env file (with your local daabase user information)

```bash
DB_HOST= 127.0.0.1
DB_USER= root
DB_PASS= password
DB_NAME= db
```


## how to set up the database:

```python
# for starting mysql
make start_mysql

# for seting up schema and views and triggers
make schemas
```

## how to start the server:

```bash
make start
```

Then you can go to the given link in terminal to acces the application with the given data (initial4.sql)