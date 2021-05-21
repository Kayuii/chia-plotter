FROM kayuii/chia-plotter:hplotter-v0.11 as hpool

FROM kayuii/chia-plotter:chiapos-v1.0.2 as chiapos

FROM ubuntu:20.04

ENV PATH=$PATH:/opt
WORKDIR /opt

COPY --from=hpool /etc/localtime /etc
COPY --from=hpool /etc/timezone /etc
COPY --from=hpool /opt/ /opt/
COPY --from=chiapos /opt/ProofOfSpace /opt

CMD ["/opt/chia-plotter-linux-amd64"]
