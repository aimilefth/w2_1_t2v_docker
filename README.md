# Wan2GP Docker Container (Wan2.1 GP by DeepBeepMeep)

This repository provides a Docker setup for running the enhanced Wan2.1 GP model ([Wan2GP](https://github.com/deepbeepmeep/Wan2GP.git)) by DeepBeepMeep. The container uses an NVIDIA CUDA base image with Python 3.10 and automatically clones the Wan2GP repository from GitHub. It installs all required dependencies, including Flash-Attn, and sets up persistent volumes for model downloads and video outputs.

## Features

- **GPU Support:** Uses an NVIDIA CUDA 12.4 base image. Ensure you have the NVIDIA Container Toolkit installed.
- **Python 3.10:** The container forces Python 3.10 for compatibility.
- **Wan2GP Repository:** The Dockerfile clones the [Wan2GP](https://github.com/deepbeepmeep/Wan2GP.git) repository and installs all required dependencies.
- **On-Demand Model Downloads:** When you run the server (with `python gradio_server.py --t2v`), the required model files are automatically downloaded (if not already present) into a persistent volume.
- **Persistent Outputs:** Generated videos are saved to a mounted volume so they persist across container runs.
- **Gradio Interface:** The server launches a Gradio web interface on port 7860 where you can configure settings and generate videos.

## Directory Structure

- **Dockerfile:**  
  - Clones the Wan2GP repository.  
  - Installs Python 3.10 and required dependencies.  
  - Installs Flash-Attn.  
  - Creates persistent folders for models (`/app/models`, symlinked to `ckpts`) and outputs (`/app/output`, symlinked to `gradio_outputs`).

- **docker_build.sh:**  
  Builds the Docker image and pushes it using the tag `aimilefth/wan2-1-t2v-docker:wan2gp`.

- **docker_run.sh:**  
  A helper script that runs the container, mounting host directories for outputs and models.

- **gradio_server.py:**  
  The main server file that downloads models (if needed) and launches the Gradio interface on port 7860.

## Building the Docker Image

Run the following command from the docker directory:

```bash
bash docker_build.sh
```
This will build the Docker image using the provided Dockerfile and tag it as `aimilefth/wan2-1-t2v-docker:wan2gp` (adjust the tag if necessary). The build process clones the Wan2GP repository, installs all dependencies, and sets up the environment.

## Running the Docker Container

Use the helper script to run the container:

```bash
./docker_run.sh [GPU_ID] [OUTPUT_DIRECTORY] [MODELS_DIRECTORY]
```

- **GPU_ID**: The index of the GPU to use (default is 0).
- **OUTPUT_DIRECTORY**: The host directory where generated videos will be stored (default: $(pwd)/outputs).
- **MODELS_DIRECTORY**: The host directory where model files will be stored (default: $(pwd)/models).

Once the container is running, you can start the Gradio server by running inside the container:

```bash
python gradio_server.py --t2v
```

This command will:

- Check if the necessary model files exist in the mounted `/app/models` (symlinked as ckpts). If they are missing, they will be automatically downloaded.
- Launch the Gradio web interface on port 7860.

Open your web browser and navigate to:

```
http://localhost:7860
```
to configure settings and generate videos.

## Additional Information

- Volumes:
    The Dockerfile creates and mounts the following directories:
        `/app/output` (symlinked as gradio_outputs) for video outputs.
        `/app/models` (symlinked as ckpts) for model downloads.
        This ensures that large model files and generated videos persist between container runs and keep the Docker image lightweight.

- Network:
    The `docker_run.sh` script uses `--network=host` so that the Gradio interface is directly accessible on `localhost:7860`.
