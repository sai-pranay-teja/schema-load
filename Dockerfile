FROM          dokken/centos-8
COPY run.sh /
ENTRYPOINT [ "bash", "/run.sh" ]


