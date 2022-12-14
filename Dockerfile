###########################################################################################
### NVIDIA PART ###########################################################################
FROM tensorflow/tensorflow:latest-gpu
# FROM pytorch/pytorch:latest
MAINTAINER Marat Shikhragimov
ARG USER

###########################################################################################
### BASE PART #############################################################################
RUN apt-get update && apt-get install -y apt-utils vim wget tmux curl gnupg git sudo graphviz
RUN ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

###########################################################################################
### USER PART #############################################################################
RUN adduser --disabled-password --gecos '' ${USER}
RUN adduser ${USER} sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

###########################################################################################
### JUPYTER ###############################################################################
# install jupyterlab
RUN pip install jupyterlab virtualenv

# jupyterlab extensions
RUN pip install jupyterlab-drawio
RUN pip install jupyterlab_latex

###########################################################################################
### OTHER #################################################################################
# install requirements
# we added this part here, because it's the most changable part
COPY requirements.txt home/${USER}/app/requirements.txt
RUN pip install -r home/${USER}/app/requirements.txt
USER ${USER}
WORKDIR home/${USER}/app

CMD ["bash", "-c", "jupyter lab --notebook-dir=~/app --ip 0.0.0.0 --port 8888 --no-browser --allow-root"]
