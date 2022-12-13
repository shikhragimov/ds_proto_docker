# Data Science Docker container
Create your working environment like venv, but deeper - in docker container. 

**Not for production usage!**

In such case you can install different versions f.e. of CUDA. And also it's a very simple approach, just configure files and run containers.
Here it is assumed you are using nvidia card which supported latest CUDA.

Consider other options NGC containers f.e. for [pytorch](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch) and for [tensorflow](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/tensorflow). 
These containers are significantly larger (compressed sizes 7 GB and 8 GB as for Dec 13 2022).

## Prerequisites
From [tensorflow official documentation](https://www.tensorflow.org/install/docker), however the same are for pytoch.

* Install the [Nvidia Container Toolkit](https://github.com/NVIDIA/nvidia-docker/blob/master/README.md?utm_source=www.tensorflow.org&utm_medium=referral#quickstart) to add NVIDIA® GPU support to Docker. nvidia-container-runtime is only available for Linux. See the `nvidia-container-runtime` platform [support FAQ](https://github.com/NVIDIA/nvidia-docker/wiki/Frequently-Asked-Questions?utm_source=www.tensorflow.org&utm_medium=referral#platform-support) for details.
* Check if a GPU is available:
    ```bash 
    lspci | grep -i nvidia
    ```
* Verify your nvidia-docker installation:
    ```bash 
    docker run --gpus all --rm nvidia/cuda nvidia-smi
    ```
## Running
### Case 1 - using only Docker
You will get most basic docker image and container. 
It is sufficient for work with notebooks and also with tensorboard 
(you will need start in manually, port for it `6006`).
Also, you could add extra port if you know that you need extra port for service (additional `-p xxxx:xxxx`).
* Replace `ds_project` with your project_name. Postfix image refers to docker image and postfix container refers to container
* You could swith between tensorflow and pytorch by commenting and uncommenting lines 3 and 4 in [Dockerfile](Dockerfile)
To keep container clear and free of data and datasets, mount data as external volume. Same as code.
```bash  
cd /path/to/project
docker build -t ds_project_image --build-arg user=$(whoami) . 
docker run -it --gpus all -p 8888:8888 -p 6006:6006 ds_project_image --name ds_project_container -v /path/to/code:/app -v /path/to/data:/app/data 
```
some notes:
* ports
  * 8888 - default port for jupyterlab
  * 6006 - default port for tensorboard
  * other port (not included in command) - consider some port as a port of service if you will do it inside this container

### Case 2 - using docker-compose
Here there is much more option. You could add several containers to the same network (here `ds_project_network`). Please look at `docker-compose.yml`, there are some comments for better understanding.

Build image
```bash
docker compose build --build-arg USER=$(whoami)
```
Run container
```bash
docker compose up
```

## Usage (Post installation)
1. Enter the shell of created container
    ```bash
    docker exec -it ds_project_container bash
    ```
2. enter container as root user. You can log into the Docker container using the root user (ID = 0) when you use the -u option
    ```bash
    docker exec -u 0 -it ds_project_container bash
    ```
   however you could just do sudo from jupyterlab terminal
3. look at the template of the [methodology](methodology.md) of DS project


## TODO
* add docker-compose
* add rapids.ai