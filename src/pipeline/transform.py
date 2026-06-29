import pandas as pd
from config import RAW_FILE

class OrderTransformer:
    def __init__(self):
        self.df = pd.read_csv(RAW_FILE)

    def clean_nulls(self):
        self.df['ship_mode'] = self.df['ship_mode'].replace([
            'Not Available',
            'unknown'
        ], pd.NA)
        return self
    

    def rename_columns(self):
        self.df.columns = self.df.columns.str.lower().str.replace(' ', '_')
        return self
    

    def add_discount(self):
        self.df['discount'] = self.df['list_price'] * self.df['discount_percent'] * 0.01
        return self
    

    def add_sale_price(self):
        self.df['sale_price'] = self.df['list_price'] - self.df['discount']
        return self
    

    def add_profit(self):
        self.df['profit'] = self.df['sale_price'] - self.df['cost_price']
        return self
    

    def convert_dates(self):
        self.df['order_date'] = pd.to_datetime(self.df['order_date'], format = "%Y-%m-%d")
        return self
    

    def drop_columns(self):
        self.df.drop(columns=[
            'list_price',
            'cost_price',
            'discount_percent'
        ], inplace=True)
        return self
    

    def run(self):
        self.rename_columns()
        self.clean_nulls()
        self.add_discount()
        self.add_sale_price()
        self.add_profit()
        self.convert_dates()
        self.drop_columns()
        return self.df