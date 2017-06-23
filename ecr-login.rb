#!/usr/bin/env ruby
# frozen_string_literal: true

require 'aws-sdk'
require 'logger'

# Class for logging into ECR
class ECR
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::DEBUG
  end

  def login
    @logger.info "Logging in to Docker registry #{@registry}"
    ecr = Aws::ECR::Client.new(region: 'us-east-1')
    authorization_data = ecr.get_authorization_token.to_h[:authorization_data].first
    user, pass = Base64.decode64(authorization_data[:authorization_token]).split(':')
    registry = File.basename(authorization_data[:proxy_endpoint])
    @logger.info `docker login -u #{user} -p #{pass} #{registry}`
  end
end

if __FILE__ == $PROGRAM_NAME
  ecr = ECR.new
  ecr.login
end
