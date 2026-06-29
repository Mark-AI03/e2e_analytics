# E2E Analytics — Retail Orders ETL Pipeline

An end-to-end data pipeline that extracts retail order data from Kaggle, applies business transformations, and loads the results into a Microsoft SQL Server database.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                        E2E Analytics Pipeline                       │
└─────────────────────────────────────────────────────────────────────┘

  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
  │   SOURCE     │     │   EXTRACT    │     │  TRANSFORM   │     │    LOAD      │
  │              │     │              │     │              │     │              │
  │  Kaggle API  │────▶│ download_    │────▶│ OrderTrans-  │────▶│ load_to_sql  │
  │              │     │ data()       │     │ former.run() │     │              │
  │  retail-     │     │              │     │              │     │  SQL Server  │
  │  orders.zip  │     │ unzip_file() │     │ - rename     │     │  (testdb)    │
  │  (~10K rows) │     │              │     │ - clean nulls│     │              │
  └──────────────┘     │  DATA/       │     │ - discount   │     │  df_orders   │
                       │  orders.csv  │     │ - sale_price │     │  table       │
                       └──────────────┘     │ - profit     │     └──────────────┘
                                            │ - dates      │
                                            └──────────────┘

  ┌─────────────────────────────────────────────────────────────────────┐
  │                         Project Structure                           │
  │                                                                     │
  │   src/                                                              │
  │   ├── main.py              ◀── Orchestrates the full pipeline       │
  │   └── pipeline/                                                     │
  │       ├── config.py        ◀── Paths & DB connection string         │
  │       ├── extract.py       ◀── Kaggle download + unzip              │
  │       ├── transform.py     ◀── Pandas cleaning & enrichment         │
  │       └── load.py          ◀── SQLAlchemy → SQL Server              │
  │                                                                     │
  │   DATA/                                                             │
  │   └── orders.csv           ◀── Raw data (auto-downloaded)           │
  │                                                                     │
  │   sql/                                                              │
  │   └── analysis.sql         ◀── Post-load business queries           │
  └─────────────────────────────────────────────────────────────────────┘
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Python 3.13 |
| Data Processing | pandas 3.0+ |
| Database | Microsoft SQL Server (local) |
| DB Connector | SQLAlchemy + pyodbc (ODBC Driver 17) |
| Data Source | Kaggle API |
| Package Manager | uv |

---

## Prerequisites

- Python 3.13
- [uv](https://docs.astral.sh/uv/) package manager
- Microsoft SQL Server (local instance)
- ODBC Driver 17 for SQL Server
- Kaggle account with API credentials

---

## Reproducible Setup Steps

### 1. Clone the repository

```bash
git clone https://github.com/Mark-AI03/e2e_analytics.git
cd e2e_analytics
```

### 2. Set up Kaggle API credentials

1. Go to [kaggle.com](https://www.kaggle.com) → Account → **Create New Token**
2. Download `kaggle.json`
3. Place it at:
   - Windows: `C:\Users\<YourUser>\.kaggle\kaggle.json`
   - Mac/Linux: `~/.kaggle/kaggle.json`

### 3. Install dependencies

```bash
uv sync
```

### 4. Configure the database connection

Open `src/pipeline/config.py` and update the connection string to match your SQL Server instance:

```python
DB_URL = "mssql://<SERVER_NAME>/testdb?driver=ODBC+DRIVER+17+FOR+SQL+SERVER"
```

Make sure the `testdb` database exists on your SQL Server instance.

### 5. Run the pipeline

```bash
uv run python src/main.py
```

This will:
1. Download `retail-orders.zip` from Kaggle into `DATA/`
2. Extract `orders.csv`
3. Apply all transformations (clean nulls, compute discount, sale price, profit)
4. Load the result into the `df_orders` table in SQL Server

---

## Transformations Applied

| Step | Description |
|---|---|
| Rename columns | Spaces → underscores, all lowercase |
| Clean nulls | `"Not Available"` and `"unknown"` → `NaN` in `ship_mode` |
| Discount | `list_price × discount_percent / 100` |
| Sale price | `list_price - discount` |
| Profit | `sale_price - cost_price` |
| Date parsing | `order_date` converted to `datetime` |
| Drop columns | Remove `list_price`, `cost_price`, `discount_percent` |

---

## Output Schema (`df_orders` table)

| Column | Description |
|---|---|
| order_id | Unique order identifier |
| order_date | Date of the order |
| ship_mode | Shipping method |
| segment | Customer segment |
| country / city / state / postal_code / region | Location info |
| category / sub_category / product_id | Product info |
| quantity | Units ordered |
| discount | Computed discount amount |
| sale_price | Final selling price |
| profit | Profit per order row |

---

## Data Source

- **Dataset:** [Retail Orders — ankitbansal06](https://www.kaggle.com/datasets/ankitbansal06/retail-orders)
- **Size:** ~9,994 order records (2022–2023)
- **License:** CC0 1.0 (Public Domain)
