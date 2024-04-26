import argparse
import ctypes
import os
import zipfile
from pathlib import Path
from urllib import request

BASE_DIR = Path(__file__).resolve().parent
DOWNLOAD_URL = "https://loclx-client.s3.amazonaws.com/loclx-windows-amd64.zip"
DEFAULT_PATH = Path.home().parent.parent / 'lxp'
CONFIG_FILE = 'config.yml'


def is_admin():
    return ctypes.windll.shell32.IsUserAnAdmin()


def prepare_dir():
    Path(DEFAULT_PATH).mkdir(parents=True, exist_ok=True)


def download_exe():
    request.urlretrieve(DOWNLOAD_URL, DEFAULT_PATH / 'localexpose.zip')


def prepare_exe(force: bool | None = False):
    if os.path.exists(DEFAULT_PATH / 'loclx.exe'):
        if not force:
            return
        else:
            download_exe()
    else:
        download_exe()
    with zipfile.ZipFile(DEFAULT_PATH / 'localexpose.zip', 'r') as zip:
        zip.extractall(DEFAULT_PATH)


def edit_config(name: str, token: str):
    with open(CONFIG_FILE, 'r') as f:
        config = f.read()
        config = config.replace('token_', token)
        config = config.replace('name_', name)
    with open(DEFAULT_PATH / 'config.yml', 'w') as f:
        f.write(config)


def install_service():
    os.system('nssm.exe install lxp ' + str(Path(DEFAULT_PATH.resolve() / 'loclx.exe')))
    os.system('nssm.exe set lxp AppParameters tunnel config -f ' +
              str(Path(DEFAULT_PATH.resolve() / 'config.yml')))
    os.system('nssm.exe set lxp DisplayName Localxpose tunnel service')
    os.system('nssm.exe set lxp Description  Localxpose tunnel service')
    os.system('nssm.exe set lxp Start SERVICE_AUTO_START')
    os.system('nssm.exe set lxp AppStdout C:\lxp\lxp.log')
    os.system('nssm.exe start lxp')


def main():
    if is_admin():
        parser = argparse.ArgumentParser(description="Process name and token")
        parser.add_argument('name', type=str,  help='Specify the tunnel name')
        parser.add_argument('token', type=str,
                            help='Specify the localxpose token')
        parser.add_argument('--force', '-f', type=bool,
                            required=False, help='Force re-download the executable')

        args = parser.parse_args()
        name = args.name
        token = args.token
        force = args.force

        prepare_dir()
        prepare_exe(force)
        edit_config(name, token)
        install_service()
    else:
        input('Run as administrator.')


if __name__ == '__main__':
    main()
    ...
