# AWS TASK 1

## Take AWS credentials for Terraform
It may be easy if you have been installed Python. 

Make and activate virtual environment. Install requirements:
```bash
virtualenv venv
. venv/bin/activate
pip install -r requirements.txt
```
In `.env` file you must put your: 
- AWS_ACCESS_KEY_ID,
- AWS_SECRET_ACCESS_KEY,
- MFA_DEVICE_ARN

Just rename template `.env.example`.

Run script and provide MFA token:
```bash
./get_accsess.py
```
This will create file `export.sh`. Export received credential to environment:
```bash
./export.sh
```

Now you can init Terraform:
```bash
terraform init
```
## Create Infrastructure
Rename `settings.tfvars.example` to `settings.tfvars`

And fill data in it.

Start deployment:
```bash
terraform apply -var-file=settings.tfvars
```
### Magic!!!

Take `lb_public_dns` from output and open it in browser.

That's all folks.

##!!! Don't forget to switch off all lights when you left work.
```bash
terraform apply -var-file=settings.tfvars
```
