FROM bentoml/bento-server:1.0.0a5-python3.8-debian-runtime

ARG UID=1034
ARG GID=1034
RUN groupadd -g $GID -o bentoml && useradd -m -u $UID -g $GID -o -r bentoml

ARG BENTO_PATH=/home/bentoml/bento
ENV BENTO_PATH=$BENTO_PATH

RUN mkdir $BENTO_PATH && chown bentoml:bentoml $BENTO_PATH -R
WORKDIR $BENTO_PATH

# copy over env directory
COPY --chown=bentoml:bentoml ./env ./env
RUN chmod +x ./env/docker/init.sh
RUN ./env/docker/init.sh ensure_python
RUN ./env/docker/init.sh restore_conda_env
RUN ./env/docker/init.sh install_pip_packages
RUN ./env/docker/init.sh install_wheels
RUN ./env/docker/init.sh user_setup_script

# copy over all remaining bento files
COPY --chown=bentoml:bentoml . ./

# Default port for BentoML Service
EXPOSE 5000

# Setup AWS Lambda
RUN pip install awslambdaric==2.0.0 mangum==0.12.3
# create BENTOML_HOME in /tmp since that is the only path available for write
ENV BENTOML_HOME=/tmp

ENTRYPOINT [ "/opt/conda/bin/python", "-m", "awslambdaric" ]
