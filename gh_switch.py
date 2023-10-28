import os
import getpass
import sys
import argparse
import subprocess
from cryptography.fernet import Fernet
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import hashes
import base64

# ################

# Global Vaiables

#################

generated_salt = ''.encode('UTF-8')
unlock_password = ''
file_path = '/home/bishalkarmakar/test/file.txt'
tmp_path = '/home/bishalkarmakar/test/.tmpfile.txt'

add_flag = any
switch_flag = any
status_flag = any

# ################

# Functions

#################
# Function to display the usage message


def show_usage():
    print("Usage: script.py [--add <key>] | [--switch]")
    exit(1)


def gh_cli_login(token):
    command = f"echo '{token}' | gh auth login --with-token "

    try:
        result = subprocess.run(command, shell=True, check=True,
                                stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)

        # The command's output (stdout) is stored in result.stdout.
        # print("Command Output:")
        print(result.stdout)

        # If there was an error, it will be in result.stderr.
        if result.returncode != 0:
            print("Error Output:")
            print(result.stderr)

    except subprocess.CalledProcessError as e:
        print(f"Error: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")

def show_gh_status():
    command = f"gh auth status "
    try:
        result = subprocess.run(command, shell=True, check=True,
                                stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)

        # The command's output (stdout) is stored in result.stdout.
        # print("Command Output:")
        print(result.stdout)

        # If there was an error, it will be in result.stderr.
        if result.returncode != 0:
            print("Error Output:")
            print(result.stderr)

    except subprocess.CalledProcessError as e:
        print(f"Error: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")


def generate_key_from_password(password, salt):
    # Derive a key from the password and salt
    kdf = PBKDF2HMAC(
        algorithm=hashes.SHA256(),
        iterations=100000,  # You can adjust the number of iterations as needed
        salt=salt,
        length=32  # Length of the key
    )
    key = base64.urlsafe_b64encode(kdf.derive(password.encode()))
    return key


def generate_salt():
    while True:
        salt = os.urandom(16)  # You can adjust the salt length as needed
        # Check if the salt contains any space characters
        if b' ' not in salt:
            return salt


def encrypt_string(plain_text, password, salt):
    key = generate_key_from_password(password, salt)
    cipher_suite = Fernet(key)
    encrypted_text = cipher_suite.encrypt(plain_text.encode('utf-8'))
    return encrypted_text


def decrypt_string(encrypted_text, password, salt):
    key = generate_key_from_password(password, salt)
    cipher_suite = Fernet(key)
    decrypted_text = cipher_suite.decrypt(encrypted_text).decode()
    return decrypted_text


def append_string_to_file(input_name, input_key, salt):

    exists = False
    with open(file_path, 'r') as file, open(tmp_path, 'w') as tmp_file:
        for line in file:
            if line.startswith(input_name + ' '):
                exists = True
                tmp_file.write(f"{input_name} {input_key} {salt}\n")
            else:
                tmp_file.write(line)

    if not exists:
        with open(file_path, 'a') as file:
            file.write(f"{input_name} {input_key} {salt}\n")
    else:
        choice = input(
            f"Name '{input_name}' already exists. Do you want to overwrite it? (y/n): ")
        if choice.lower() == 'y':
            os.rename(tmp_path, file_path)
        else:
            os.remove(tmp_path)


# append_string_to_file(input_name="temp1", input_key=enc.decode(), salt=salt.hex())

# Function to switch with a specific name


def switch_with_name(input_name, unlock_password):
    chk=False
    with open(file_path, 'r') as file:
        for line in file:
            if line.startswith(input_name + ' '):
                chk=True
                name, encrypted_key, salt = line.strip().split(' ')
                encrypted_key = encrypted_key.encode('UTF-8')
                salt = bytes.fromhex(salt)
                decrypted_key = decrypt_string(encrypted_key, unlock_password, salt)
                print(f"Decrypted key: {decrypted_key}")
                gh_cli_login(decrypted_key)
    if not chk :
        print(f"'{input_name}' is not stored")

def switch_without_name(unlock_password):
    name_arr = []
    encrypted_key_arr = []
    with open(file_path, 'r') as file:
        for line in file:
            name, encrypted_key, salt = line.strip().split(' ')
            name_arr.append(name)
            encrypted_key_arr.append(encrypted_key)
    
    for i, name in enumerate(name_arr):
        print(f"[{i}] {name}")

    choice = input("Choose a name (enter the index): ")

    if choice.isdigit() and 0 <= int(choice) < len(name_arr):
        chosen_name = name_arr[int(choice)]
        switch_with_name(input_name=chosen_name, unlock_password=unlock_password)


# ################

# Logic

#################
# Get the directory path from the file path
directory_path = os.path.dirname(file_path)

# Check if the directory exists, and if not, create it
if not os.path.exists(directory_path):
    os.makedirs(directory_path)

# Check if the file exists, and if not, create it
if not os.path.exists(file_path):
    with open(file_path, 'w'):
        pass


# CMD line argument parsing

parser = argparse.ArgumentParser(description="Command Line Argument Parser")
parser.add_argument('--add', nargs='*', default=[],
                    help='List of strings to add')
parser.add_argument('--switch', nargs='?', const=any,
                    help='Optional string for switch')
parser.add_argument('--status', action='store_true', help='Flag to set status')

args = parser.parse_args()

add_flag = args.add
switch_flag = args.switch
status_flag = args.status

# print(f'--add: {add_flag}')
# print(f'--switch: {switch_flag}')
# print(f'--status: {status_flag}')

generated_salt = generate_salt()
unlock_password = getpass.getpass("Enter Encryption Password: ")

if len(add_flag) != 0:
    for item in add_flag:
        input_name = input(f"Enter a Name for Github Account : '{item}' ")
        encrypted_key = encrypt_string(
            plain_text=item, salt=generated_salt, password=unlock_password)
        print(encrypted_key)
        append_string_to_file(
            input_name=input_name, input_key=encrypted_key.decode(), salt=generated_salt.hex())

if switch_flag is not None:
    # select name manually
    if switch_flag == any:  # Check if switch_flag is a non-empty string
        print(f'--switch: {switch_flag}')
    # select name from switch_flag
    else:
        switch_with_name(input_name=switch_flag,
                         unlock_password=unlock_password)
        # print('--switch is provided without a non-empty string argument.')

if status_flag :
    show_gh_status()
