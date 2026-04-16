# tranfers-db

## how to set up the connections:

write the following information in a .env file

```bash
DB_HOST=127.0.0.1
DB_USER=root
DB_PASS=password
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