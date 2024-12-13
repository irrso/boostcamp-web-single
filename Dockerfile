# FROM : 베이스 이미지
# requirements.txt 복사 후
# CMD로 uvicorn 실행

FROM python:3.9.13-slim

WORKDIR /code
COPY ./requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt
COPY . /code
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]