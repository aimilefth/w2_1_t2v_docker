# WAN-AI Docker Container

This repository provides a Docker setup for the WAN-AI Text-to-Video model (T2V-1.3B). The container includes a pre-downloaded 1.3B model and all required dependencies so you can quickly generate videos using the WAN-AI model.

## Contents

- **Dockerfile**: Builds the Docker image with all necessary dependencies and pre-downloads the T2V-1.3B model.
- **docker_run.sh**: A helper script to run the Docker container using a specified GPU and to mount a host directory for output videos.
- **README.md**: This file, which explains how to build and use the Docker container and model.

## 1) How the Docker is Created

To build the Docker image, run the following command from the directory containing the Dockerfile:

```bash
bash docker_build.sh
```

This command performs the following steps:

- **Base Image:** Uses an NVIDIA CUDA base image for GPU support.
- **System Setup**: Installs Python3, pip, and Git.
- **Repository Clone & Dependencies**: Clones the WAN-AI repository and installs the Python dependencies from requirements.txt.
- **Default Command**: Sets the container to open a Bash terminal when started.


## 2) docker_run.sh Explanation

The `docker_run.sh` script is a convenience tool for running the container with your desired settings.
Usage

```bash
./docker_run.sh [GPU_ID] [OUTPUT_DIRECTORY] [MODELS_DIRECTORY]
```
    
- GPU_ID: The index of the GPU you want to use (e.g., 0, 1, 2). Defaults to 0 if not specified.
- OUTPUT_DIRECTORY: The host directory where generated videos will be stored. Defaults to ./output in the current directory.
- MODELS_DIRECTORY: The host directory where models will be stored. Defaults to ./models in the current directory.

The script mounts the specified output directory to `/app/output` inside the container so that any video files saved there are immediately available on your host system.


## 3) How to Use the WAN-AI Model

Once inside the container (after running `docker_run.sh`), you can generate videos with the WAN-AI model by running the `generate.py` script.
### Example Command

Run the generation command. For example, to generate a video with the T2V-1.3B model at 480P resolution, you might use:

```bash
python generate.py --task t2v-1.3B --size 832*480 --ckpt_dir /app/models/Wan2.1-T2V-1.3B --sample_shift 8 --offload_model True --t5_cpu --sample_guide_scale 6 --prompt "Two anthropomorphic cats in boxing gear fight on a spotlighted stage."
```

### Saving Output Videos

To keep your generated videos organized:

1. **Output Directory**: The container mounts `/app/output` to the host, so you can save the video files there.

2. **Naming Convention**: After generating a video, rename or move the file to include the prompt (or a summary of it) in the filename. For example:

    ```bash
    mv generated_video.mp4 /app/output/"Two_anthropomorphic_cats_in_boxing_gear.mp4"
    ```

    This way, the file name reflects the video’s content. You can modify the `generate.py` script or use a wrapper to automate this renaming if needed.

## Downloading Models

You need huggingface-cli to download the models
Install it like this

```bash
pip3 install "huggingface_hub[cli]"
```

To download 14B model do:
```bash
huggingface-cli download Wan-AI/Wan2.1-T2V-14B --local-dir ./models/Wan2.1-T2V-14B
```

To download 1.3B model do:
```bash
huggingface-cli download Wan-AI/Wan2.1-T2V-1.3B --local-dir ./models/Wan2.1-T2V-1.3B
```

## Final Notes

- **GPU Support**: Ensure your Docker installation supports NVIDIA GPUs (using the NVIDIA Container Toolkit).
- **Customization**: Adjust model parameters and resolution settings as needed based on your hardware and desired output quality.
- **Troubleshooting**: If you run into issues like GPU memory errors, consider using options such as --offload_model True and --t5_cpu.