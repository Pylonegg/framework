# Windows

Install git
```ps
winget install --id Git.Git -e --source winget
```
Install python
Upgrade pip
pip install --upgrade pip
pip install -r C:\Users\chiad\Projects\MDF\core\codegen\requirements.txt


Install bicep



set-executionpolicy remotesigned -Scope CurrentUser



# Linux Notes

```bash
sudo wget http://http.us.debian.org/debian/pool/main/o/openldap/libldap-2.4-2_2.4.47+dfsg-3+deb10u7_amd64.deb 

sudo apt install ./libldap-2.4-2_2.4.47+dfsg-3+deb10u7_amd64.deb
```


```bash
wget http://nz2.archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.22_amd64.deb

sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2.22_amd64.deb
```




import time

def one():
    for i in range(10):
        print(f"\rProgress: {i}/10", end="")
        time.sleep(0.5)

    print("\nDone!")


def abc():
    databricks_notebook = [
        f"""# Databricks notebook source
        dbutils.widgets.text("Database"
        dbutils.widgets.text("Table"

        # COMMAND ----------
        """
        ]
    
    print(databricks_notebook)

abc()