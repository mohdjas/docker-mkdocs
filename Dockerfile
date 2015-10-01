FROM ubuntu:15.04

RUN apt-get update
RUN apt-get install -y python-pip python-dev build-essential libyaml-dev git

RUN python -V
RUN pip install mkdocs

ADD run.sh /run.sh
RUN chmod +x /run.sh
CMD ["/bootstrap.sh"]
