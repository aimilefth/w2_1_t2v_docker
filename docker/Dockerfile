# Use an NVIDIA CUDA base image for GPU support
FROM nvidia/cuda:12.4.0-devel-ubuntu22.04

# Install Python 3.10, development tools, and other dependencies
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3.10-dev \
    python3.10-venv \
    python3.10-distutils \
    git \
    curl \
    libgl1 \ 
    ffmpeg \
    libsm6 \
    libxext6 \
    && rm -rf /var/lib/apt/lists/*

# Install pip for Python 3.10
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10

# Force the default python to point to Python 3.10
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1

# Set the working directory
WORKDIR /app

# Clone the Wan2GP repository from GitHub
RUN git clone https://github.com/deepbeepmeep/Wan2GP.git

# Change working directory into the cloned repository
WORKDIR /app/Wan2GP

# Upgrade pip and install project dependencies
RUN pip install --upgrade pip
RUN pip install torch==2.6.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/test/cu124  
RUN pip install -r requirements.txt

# Set the target CUDA architectures so SageAttention can build without detecting a GPU. 8.0 is for Ampere (A30)
ENV TORCH_CUDA_ARCH_LIST="8.0"

# # Required triton for SageAttention 2
# RUN pip install triton
# # Install SageAttention 2 (for performance boost)
# RUN git clone https://github.com/thu-ml/SageAttention.git && cd SageAttention && pip install -e .
RUN pip install flash-attn==2.7.2.post1
# Create directories for persistent models and outputs,
# and create symlinks so that model downloads (ckpts) and video outputs (gradio_outputs) are stored on mounted volumes.
RUN mkdir -p /app/models /app/output \
    && ln -s /app/models ckpts \
    && ln -s /app/output gradio_outputs

# Declare volumes so that the external host folders are mounted into the container
VOLUME ["/app/output"]
VOLUME ["/app/models"]

# Expose the default Gradio port
EXPOSE 7860

CMD ["/bin/bash"]
