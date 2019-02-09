IMAGE_NAME="fialakarel/nginx"

build:
	docker build -t $(IMAGE_NAME) .

build-nc:
	docker build --no-cache --pull -t $(IMAGE_NAME) .

push:
	docker push $(IMAGE_NAME)

testrun:
	docker run --rm -it --publish 80:80/tcp --name nginx-test $(IMAGE_NAME)
