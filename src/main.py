
import sys
from pathlib import Path

sys.path.append(str(Path(__file__).parent / "pipeline"))

from extract import download_data, unzip_file
from transform import OrderTransformer
from load import load_to_sql
from config import DATA_DIR


def main():
    # extracting data
    download_data("ankitbansal06/retail-orders")
    unzip_file(DATA_DIR / "retail-orders.zip")

    # tranforming
    df = OrderTransformer().run()

    # loading into database
    load_to_sql(df, "df_orders")

Print("The database is loaded successfully.")

if __name__ == "__main__":
    main()