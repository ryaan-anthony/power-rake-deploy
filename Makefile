# These variables set the current project
conf ?= config.yml
env ?= development
export PROJECT_CONFIG=$(conf)
export PROJECT_ENV=$(env)

ssh: # SSH into the instance
	bundle exec rake ssh

ssl_upload: # Upload SSL certificates to vault
	bundle exec rake ssl_upload

ssl_deploy: # Deploys SSL certificates to instance(s)
	bundle exec rake ssl_deploy
