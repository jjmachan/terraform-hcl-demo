FROM bentoml/bento-server:1.0.0a6-python3.8-debian-runtime

ARG BENTO_PATH=/home/bento
ENV BENTO_PATH=$BENTO_PATH
ENV BENTOML_HOME=/home/

RUN mkdir $BENTO_PATH
WORKDIR $BENTO_PATH


# copy over env directory
COPY ./env ./env
RUN chmod +x ./env/docker/init.sh
RUN ./env/docker/init.sh ensure_python
RUN ./env/docker/init.sh restore_conda_env
RUN ./env/docker/init.sh install_pip_packages
RUN ./env/docker/init.sh install_wheels
RUN ./env/docker/init.sh user_setup_script

# copy over all remaining bento files
COPY . ./

# Default port for BentoServer
EXPOSE 5000
ENV PATH="$BENTO_PATH:$PATH"
