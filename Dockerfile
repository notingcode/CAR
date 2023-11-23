# Use an official Ubuntu 18.04 as the base image
FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

# Do not check for keyboard type
ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

COPY . /home/CAR

# Install basic dependencies
RUN apt-get update \
    && apt-get install -y \
    && apt-get install -y \
    git g++ wget bzip2 mesa-utils \
    libgl1 libgl1-mesa-glx libglib2.0-0

# Set environment variables for CUDA
ENV PATH="/usr/local/cuda-11.8/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda-11.8/lib64:${LD_LIBRARY_PATH}"
ENV CUDA_PATH="/usr/local/cuda-11.8"
ENV CUDA_HOME="/usr/local/cuda-11.8"

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -b -p /opt/miniconda \
    && rm /tmp/miniconda.sh

ENV PATH="/opt/miniconda/bin:${PATH}"

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && rm ./cuda-keyring_1.0-1_all.deb

RUN conda init

# Create a Conda environment with your desired packages
RUN conda env create --file /home/CAR/environment.yml