FROM ubuntu:latest

RUN apt update

RUN apt install -y curl git unzip python3 python3-venv make

RUN curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz -o nvim.tar.gz \
    && tar xzvf nvim.tar.gz \
    && mv nvim-linux-x86_64 /usr/local/neovim \
    && echo 'export PATH=$PATH:/usr/local/neovim/bin' >> ~/.bashrc  \
    && rm nvim.tar.gz

RUN apt install -y nodejs npm

RUN git clone https://github.com/Kaiser-Yang/LightBoat.starter.git ~/.config/nvim

ENTRYPOINT ["/bin/bash"]
