import kaggle
from config import DATA_DIR

def download_data(dataset: str) -> None:
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    kaggle.api.dataset_download_files(dataset, path= DATA_DIR, unzip=False)


def unzip_file(zip_path) -> None:
    import zipfile
    with zipfile.ZipFile(zip_path, 'r') as zf:
        zf.extractall(DATA_DIR)