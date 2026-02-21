FROM ubuntu:latest

RUN apt update

RUN apt install -y curl git unzip ripgrep tar gzip tree-sitter

RUN curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz -o nvim.tar.gz \
    && tar xzvf nvim.tar.gz \
    && mv nvim-linux-x86_64 /usr/local/neovim \
    && echo 'export PATH=$PATH:/usr/local/neovim/bin' >> ~/.bashrc  \
    && rm nvim.tar.gz

RUN git clone https://github.com/Kaiser-Yang/LightBoat.starter.git ~/.config/nvim

ENTRYPOINT ["/bin/bash"]
