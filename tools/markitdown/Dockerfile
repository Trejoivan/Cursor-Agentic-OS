FROM python:3.13-slim-bullseye

ENV DEBIAN_FRONTEND=noninteractive

# MarkItDown uses external tools for some metadata/transcription paths
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    exiftool \
  && rm -rf /var/lib/apt/lists/*

RUN pip --no-cache-dir install "markitdown[all]"

WORKDIR /work

ENTRYPOINT [ "markitdown" ]

