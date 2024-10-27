app_name = net-worth

build-image:
	docker build -t $(app_name):latest .

up:
	docker compose up
