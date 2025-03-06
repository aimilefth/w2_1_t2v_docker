# Use an NVIDIA CUDA base image for GPU support
FROM nvidia/cuda:12.8.0-devel-ubuntu24.04

# Install system packages: Python3, pip, and git
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    git \
    python3-packaging \
    && rm -rf /var/lib/apt/lists/*

# (Optional) Create a python symlink for convenience
RUN ln -s /usr/bin/python3 /usr/bin/python

# Set working directory
WORKDIR /app

# Clone the WAN-AI repository
RUN git clone https://github.com/Wan-Video/Wan2.1.git && \
    cd Wan2.1 && \
    # Required from before
    pip3 install torch>=2.4.0 --break-system-packages && \ 
    # pip3 install --upgrade pip --break-system-packages && \
    pip3 install -r requirements.txt --break-system-packages

# Pre-download the T2V-1.3B model using Hugging Face CLI
RUN cd Wan2.1 && \
    pip3 install "huggingface_hub[cli]" --break-system-packages && \
    huggingface-cli download Wan-AI/Wan2.1-T2V-1.3B --local-dir ./Wan2.1-T2V-1.3B

# Set working directory to the WAN-AI repository
WORKDIR /app/Wan2.1

# Create a volume for output videos
VOLUME ["/app/output"]

# Default command: open a bash terminal
CMD ["/bin/bash"]
