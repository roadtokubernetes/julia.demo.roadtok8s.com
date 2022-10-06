FROM julia:latest

COPY ./src/ /opt/app
WORKDIR /opt/app

RUN julia install.jl

RUN chmod +x run.sh

CMD ["./run.sh"]