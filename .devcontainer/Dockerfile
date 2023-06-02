FROM mcr.microsoft.com/devcontainers/base:bullseye

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    #
    # Verify git, process tools, lsb-release (common in install instructions for CLIs) installed
    && apt-get -y install git openssh-client less iproute2 procps apt-transport-https gnupg2 curl lsb-release wget

RUN mkdir /temp
RUN wget https://github.com/gohugoio/hugo/releases/download/v0.112.7/hugo_extended_0.112.7_linux-amd64.deb -O /temp/hugo_extended.deb

RUN apt install /temp/hugo_extended.deb

# # # Clean up
# # && apt-get autoremove -y \
# # && apt-get clean -y \
# # && rm -rf /var/lib/apt/lists/*