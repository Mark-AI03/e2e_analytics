import sqlalchemy as sal
from config import DB_CONNECTION_STRING

def load_to_sql(df, table_name: str) -> None:
    engine = sal.create_engine(DB_CONNECTION_STRING)
    conn = engine.connect()
    df.to_sql(table_name, con= conn, index = False, if_exists = 'append')
    conn.close()

