require "restclient"

module Stannis
  class Client
    class MissingConfigError; end
    def initialize(config)
      unless config.is_a?(Hash)
        raise new MissingConfigError("Stannis::Client.new requires Hash with keys uri/username/password")
      end
      @uri = config["uri"] || config["url"]
      @username = config["username"]
      @password = config["password"]
      unless @uri && @username && @password
        raise new MissingConfigError("Stannis::Client requires uri/username/password configuration")
      end
    end

    def upload_deployment_data(bosh_really_uuid, deployment_name, label, upload_data)
      url = "#{@uri}/upload/#{bosh_really_uuid}/deployments/#{deployment_name}/data/#{label}"
      collector = ::RestClient::Resource.new(url, @username, @password)
      collector.post(upload_data)
    rescue RestClient::ResourceNotFound => e
      $stderr.puts "Failed to upload to #{url}: #{e.inspect}"
    end
  end
end

require "stannis/client/deployment_data"
