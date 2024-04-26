import ctypes
import os
from pathlib import Path
from time import sleep

BASE_DIR = Path(__file__).resolve().parent
NSSM = BASE_DIR / 'nssm.exe'
DEFAULT_PATH = os.environ['systemdrive']+'\\lxp\\'

def is_admin():
    return ctypes.windll.shell32.IsUserAnAdmin()

if __name__ == '__main__':
    if is_admin():
        os.system('nssm.exe stop lxp')
        os.system('nssm.exe remove lxp confirm')
        os.system('rmdir /s /q ' + DEFAULT_PATH)
    else:
        input('Run as administrator.')