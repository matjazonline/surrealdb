# Copyright © 2016 Abcum Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

GO ?= go
LDF :=

# The `make default` command cleans
# the go build and test files and
# then runs a build and install.

.PHONY: default
default:
	@echo "Choose a Makefile target:"
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print "  - " $$1}}' | sort

# The `make kill` command ensures that
# any hanging surreal processes are force
# killed. Useful in development.

.PHONY: kill
kill:
	pkill -9 -f surreal

# The `make convey` command downloads
# or updates 'goconvey', and runs the
# auto-updating testing server.

.PHONY: convey
convey:
	@echo "Run 'go get -u -v github.com/smartystreets/goconvey'"
	goconvey -packages 5 -port 5000 -poll 1s -excludedDirs 'build,dev,docs,gui,vendor'

# The `make glide` command ensures that
# all imported dependencies are synced
# and located within the vendor folder.

.PHONY: glide
glide:
	glide update
	
# The `make test` command runs all
# tests, found within all sub-folders
# in the project folder.

.PHONY: test
test: clean
test: glide
test:
	$(GO) test `glide novendor`

# The `make clean` command cleans
# all object, build, and test files
# and removes the executable file.

.PHONY: clean
clean:
	rm -rf vendor
	$(GO) clean -i `glide novendor`
	find . -name '*.test' -type f -exec rm -f {} \;

# The `make quick` command compiles
# the build flags, gets the project
# dependencies, and runs a build.

.PHONY: quick
quick: LDF += $(shell GOPATH=${GOPATH} build/flags.sh)
quick: 
	$(GO) build

# The `make build` command compiles
# the build flags, gets the project
# dependencies, and runs a build.

.PHONY: build
build: LDF += $(shell GOPATH=${GOPATH} build/flags.sh)
build: clean
build: glide
build:
	CGO_ENABLED=0 $(GO) build -a -v -ldflags '$(LDF)'

# The `make install` command compiles
# the build flags, gets the project
# dependencies, and runs an install.

.PHONY: install
install: LDF += $(shell GOPATH=${GOPATH} build/flags.sh)
install: clean
install: glide
install:
	CGO_ENABLED=0 $(GO) install -a -v -ldflags '$(LDF)'

# The `make ember` command compiles
# the ember project, and outputs
# the build files in the app folder.

.PHONY: ember
ember: 
	# npm install -g bower
	# npm install -g ember-cli
	cd gui && npm cache clean && bower cache clean
	# cd gui && npm install && bower install
	cd gui && ember build -prod -o ../app/