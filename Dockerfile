FROM amd64/alpine:3.16

RUN mkdir transformations
RUN mkdir root/.dbt

COPY transformations transformations/
COPY transformations/profiles /root/.dbt/
COPY extract_data.py .
COPY requirements.txt .

ENV PYTHONPATH ./

RUN apk update && \
    apk upgrade && \
    apk add --no-cache python3 && \
    apk add --no-cache py-pip && \
    apk add --no-cache bash && \
    apk add --no-cache libpq-dev
RUN ln -sf python3 /usr/bin/python

RUN python -m venv .venv
RUN /.venv/bin/python -m pip install --upgrade pip
RUN /.venv/bin/pip install -r requirements.txt

RUN /.venv/bin/dbt --version

RUN adduser -D -u 1001 dbt

USER 1001

ENTRYPOINT [ "/.venv/bin/python" ]
CMD [ "./extract_data.py" ]
