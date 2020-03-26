FROM hepstore/rivet-herwig:3.1.0-7.2.0
MAINTAINER David Yallup <dyallup@cern.ch>

CMD /bin/bash

RUN dnf install -y git sqlite-devel texlive
RUN git clone https://gitlab.com/hepcedar/contur.git /contur; \
cd /contur && git pull && git checkout contur-1.1.0 && pip install update && pip install --ignore-installed -r requirements.txt && chmod +x setupContur.sh && . /contur/setupContur.sh && make;echo -e ". /contur/setupContur.sh\n$(cat /etc/bashrc)" > /etc/bashrc; \
ln -s /contur/AnalysisTools/contur/bin/*  /usr/local/bin/; \
ln -s /contur/AnalysisTools/contur/contur  /usr/local/lib64/python2.7/site-packages
RUN pip install jupyter --ignore-installed



ENV CONTURMODULEDIR=/contur

#ENV DISPLAY :0

WORKDIR /contur

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]