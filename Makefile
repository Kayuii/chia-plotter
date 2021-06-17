# TAG?=latest
IMAGE_PREFIX:=kayuii
IMAGE_TAG:=chia-plotter

TARGET_IMAGE_PRD=$(IMAGE_PREFIX)/$(IMAGE_TAG)

TAG := $(shell git describe --tags --abbrev=0 --match 'chiapos-v*')
VERSION := $(shell echo $(TAG) | sed 's/^chiapos-v//')
COMMIT := $(shell git rev-parse HEAD)
SHORTCOMMIT := $(shell echo $(COMMIT) | cut -c1-7)
RELEASE := $(shell git describe --tags --match 'chiapos-v*' \
             | sed 's/^chiapos-v//' \
             | sed 's/^[^-]*-//' \
             | sed 's/-/./')
BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
ifeq ("$(BRANCH)", "master")
	TARGET_IMAGE = $(shell echo "${TARGET_IMAGE_PRD}:latest")
else
	TARGET_IMAGE = $(shell echo "${TARGET_IMAGE_PRD}:${TAG}")
endif

all: chiapos chia

echo:
	@echo ""
	@echo "Make echo"
	@echo TAG $(TAG)
	@echo COMMIT $(COMMIT)
	@echo VERSION $(VERSION)
	@echo SHORTCOMMIT $(SHORTCOMMIT)
	@echo RELEASE $(RELEASE)

tag:
	$(eval BRANCH := $(shell git rev-parse --abbrev-ref HEAD))
	$(eval LASTNUM := $(shell echo $(TAG) \
	                    | sed -E "s/.*[^0-9]([0-9]+)$$/\1/"))
	$(eval NEXTNUM=$(shell echo $$(($(LASTNUM)+1))))
	$(eval NEXTTAG=$(shell echo $(TAG) | sed "s/$(LASTNUM)$$/$(NEXTNUM)/"))
	if [ "$(TAG)" = "$(git describe --tags --match 'v*')" ]; then \
	    echo "$(SHORTCOMMIT) on $(BRANCH) is already tagged as $(TAG)"; \
	    exit 1; \
	fi
	if [ "$(BRANCH)" != "master" ] && \
	   ! [ "$(BRANCH)" =~ ^chiapos- ]; then \
		echo Cannot tag $(BRANCH); \
		exit 1; \
	fi
	@echo Tagging Git branch $(BRANCH)
	git tag $(NEXTTAG)
	@echo run \'git push origin $(NEXTTAG)\' to push to GitHub.

master: echo
	cd "chia/chiapos/"; \
	docker build --build-arg CHIAPOS=main --build-arg BUILD_PROOF_OF_SPACE_STATICALLY=ON -f Dockerfile -t ${TARGET_IMAGE} . ;

chiapos: echo
	cd "chia/chiapos/"; \
	docker build --build-arg CHIAPOS=$(VERSION) -f Dockerfile -t ${TARGET_IMAGE} . ;

fastpos: echo
	cd "chia/fastpos/"; \
	docker build --build-arg -f Dockerfile -t ${TARGET_IMAGE} . ;

chia: echo
	cd "chia/chia/"; \
	docker build --build-arg CHIA_VER=$(VERSION) -f Dockerfile -t ${TARGET_IMAGE} . ;

test:
	docker run -it --rm ${TARGET_IMAGE} bash -c "./ProofOfSpace -k 21 -f \"plot.dat\" -i \"7e1392f6b7a2d113f8fb685a7409c81211748c335e87decf348a4345e07dcb2b\" create && echo \"4c881491d57d0b8817302cb6ce23ff52 plot.dat\" | md5sum -c - ";

push:
	docker push ${TARGET_IMAGE} ;


.PHONY: chiapos chia tag master
