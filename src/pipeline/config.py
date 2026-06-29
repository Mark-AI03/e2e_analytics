from pathlib import Path

BASE_DIR = Path(__file__).parent.parent.parent
DATA_DIR = BASE_DIR / "DATA"
RAW_FILE = DATA_DIR / "orders.csv"

DB_CONNECTION_STRING = 'mssql://DESKTOP-P3QDEI4/testdb?driver=ODBC+DRIVER+17+FOR+SQL+SERVER'