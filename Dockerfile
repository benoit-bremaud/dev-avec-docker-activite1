FROM python:3.12-alpine AS builder

WORKDIR /build

RUN apk add --no-cache binutils=2.45.1-r1

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt pyinstaller

COPY app ./app

RUN pyinstaller --onefile --name app app/app.py


FROM alpine:3.20

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /build/dist/app /usr/local/bin/app

USER appuser

EXPOSE 5000

CMD ["/usr/local/bin/app"]
