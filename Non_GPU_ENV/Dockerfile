# FROM ubuntu:xenial
FROM python

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install OpenSSH, vim, zsh and tmux
RUN apt-get update && apt-get install -y \
    openssh-client \
    openssh-server \
    vim \
    tmux \
    && \
    mkdir -p /var/run/sshd

# Allow OpenSSH to talk to containers without asking for confirmation
RUN cat /etc/ssh/ssh_config \
    | grep -v StrictHostKeyChecking \
    > /etc/ssh/ssh_config.new && \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new && \
    mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config

RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN cat /etc/ssh/sshd_config \
    | grep -v '#Port' \
    > /etc/ssh/sshd_config.new && \
    echo "Port 1919" >> /etc/ssh/sshd_config.new && \
    mv /etc/ssh/sshd_config.new /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Add public key
ARG SSH_KEY
RUN mkdir /root/.ssh \
    && echo "$SSH_KEY" > /root/.ssh/authorized_keys

COPY requirements.txt ./requirements.txt
# Install python packages
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

ENTRYPOINT service ssh restart && bash