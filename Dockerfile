FROM dyallup/conturjupyterdemo:1.0

ARG NB_USER=demo
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --uid ${NB_UID} ${NB_USER}
WORKDIR ${HOME}

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

RUN ls
RUN source get_sources.sh; cd Exercises

ENTRYPOINT []