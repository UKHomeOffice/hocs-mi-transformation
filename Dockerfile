FROM amd64/alpine:3.16

RUN mkdir transformations

COPY transformations transformations/
COPY requirements.txt .
COPY extract_data.sh .
COPY run_etl.sh .
COPY output_test.sh .

ENV PYTHONPATH ./

RUN apk update && \
    apk upgrade && \
    apk add --no-cache python3 && \
    apk add --no-cache py-pip && \ 
    apk add --no-cache bash && \
    apk add --no-cache libpq-dev && \
    apk add --no-cache postgresql-client
RUN ln -sf python3 /usr/bin/python

RUN python -m venv .venv
RUN /.venv/bin/python -m pip install --upgrade pip
RUN /.venv/bin/pip install -r requirements.txt

RUN /.venv/bin/dbt --version

RUN adduser -D -u 1001 transformation

USER root
#RUN chown 1001 .
RUN mkdir dbt-logs
RUN chown -R 1001 dbt-logs

USER 1001

CMD [ "./run_etl.sh", "sleep", "infinity" ]
