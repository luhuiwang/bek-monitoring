.PHONY: init pull build build-nc run run-beat clean cleanall

init: 
	@which docker >/dev/null || ( echo "Error: Docker is not installed"; exit 1 )
	@which docker-compose >/dev/null || ( echo "Error: docker-compose is not installed"; exit 1 )

pull: init
	@docker-compose pull

build: init
	@docker-compose build

run: init pull build
	@docker-compose up -d
	@sleep 60
	@echo "Monitoring stack (including ElasticSearch and Kibana) is started!"
	@echo "ElasticSearch Url: http://${ELASTICSEARCH_HOST}:9200/"
	@echo "Kibana Url: http://${KIBANA_HOST}:5601/"

pull-beat: init
	@docker-compose -f docker-compose.beat.yml pull

build-beat: init
	@docker-compose -f docker-compose.beat.yml build

run-beat: init pull-beat build-beat
	@docker-compose -f docker-compose.beat.yml up -d
	@sleep 60
	@echo "Monitoring stack (including beats) is started!"

clean: 
	@-docker-compose down --remove-orphans -v
	@-docker-compose -f docker-compose.beat.yml down --remove-orphans -v
 
cleanall: 
	@-docker-compose down --remove-orphans --rmi all -v
	@-docker-compose -f docker-compose.beat.yml down --remove-orphans --rmi all -v
