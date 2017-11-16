FROM amazonlinux:latest

RUN yum -y install epel-release
RUN yum -y update
RUN yum -y install unzip
RUN yum -y install aws-cli
RUN yum -y install java-1.8.0*
RUN yum -y install zip
RUN yum -y install sudo
RUN yum -y install gcc
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
RUN python get-pip.py
RUN pip install plumbum
RUN pip install numpy
RUN yum -y install python27-devel
RUN yum -y install tcl
RUN yum -y install tcl-devel
RUN yum -y install tkinter27
RUN pip install seaborn
RUN pip install matplotlib
RUN yum -y install which
RUN mkdir /data
ADD EstCC/EstCC.jar /data
ADD fetch_and_run.sh /data
RUN chmod 777 /data/fetch_and_run.sh
ADD CORM_columns.txt /data
ADD modified_params.txt /data
WORKDIR /data
USER root

ENTRYPOINT ["/data/fetch_and_run.sh"]