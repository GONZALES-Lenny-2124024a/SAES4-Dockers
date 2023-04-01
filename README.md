# SAES4-Dockers
A repository to clone other projects (WebSite - Application Server) and build containers with Dockerfile and coker-compose.yml

## Install Dockers and docker-compose

Follow this link to install Docker : https://docs.docker.com/get-docker/
Install docker-compose by running this command :
```
pip install docker-compose
```
or
```
pip3 install docker-compose
```

## Run my containers
### Step 1 : Download or Clone this repository
Clone this repository by downloading the zip or running the command :
```
git clone https://github.com/LennyGonzales/SAES4-Dockers.git
```

### Step 2 : Download other projects
Download the Server and the Website by running the following command :
```
bash script.sh
```

### Step 3 : Run the docker-compose.yml
```
docker-compose up --build -d
```
