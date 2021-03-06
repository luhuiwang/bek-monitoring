SHELL:=/bin/bash
include .env 

.PHONY: init pull build build-nc run run-beat clean cleanall

init: 
	@which docker >/dev/null || ( echo "Error: Docker is not installed"; exit 1 )
	@which docker-compose >/dev/null || ( echo "Error: docker-compose is not installed"; exit 1 )

pull: init
	@docker-compose pull

build: init
	@docker-compose build

run: 
	@docker-compose up -d
	@sleep 60
	@echo "Monitoring stack (including ElasticSearch and Kibana) is started!"
	@echo "ElasticSearch Url: http://${ELASTICSEARCH_HOST}:9200/"
	@echo "Kibana Url: http://${KIBANA_HOST}:5601/"

start:
	@docker-compose start

stop:
	@docker-compose stop

pull-beat: init
	@docker-compose -f docker-compose.beat.yml pull

build-beat: init
	@docker-compose -f docker-compose.beat.yml build

run-beat: 
	@docker-compose -f docker-compose.beat.yml up -d
	@sleep 60
	@echo "Monitoring stack (including beats) is started!"
	@echo "ElasticSearch Url: http://${ELASTICSEARCH_HOST}:9200/"
	@echo "Kibana Url: http://${KIBANA_HOST}:5601/"

start-beat:
	@docker-compose -f docker-compose.beat.yml start

stop-beat:
	@docker-compose -f docker-compose.beat.yml stop

clean: 
	@-docker-compose down -v

clean-beat:
	@-docker-compose -f docker-compose.beat.yml down -v
 
cleanall: 
	@-docker-compose down --remove-orphans --rmi all -v

cleanall-beat:
	@-docker-compose -f docker-compose.beat.yml down --remove-orphans --rmi all -v
