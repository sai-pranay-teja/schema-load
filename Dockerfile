FROM dokken/centos-8
RUN yum update -y
COPY run.sh /
ENTRYPOINT    [ "bash", "/run.sh" ]