import zipfile,os
from pathlib import Path
from urllib import request

BASE_DIR = Path(__file__).resolve().parent
EXE_ = "loclx.exe"



def get_files():
    request.urlretrieve(
        "https://loclx-client.s3.amazonaws.com/loclx-windows-amd64.zip",
        Path(
            BASE_DIR,
            "loclx.zip"
        )
    )
    with zipfile.ZipFile('loclx.zip', 'r') as zip_ref:
        zip_ref.extractall()

def expose():
    os.system(f"{EXE_} tunnel config -f config.yml")

if not Path(BASE_DIR, EXE_).exists():
    get_files()

expose()