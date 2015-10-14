stack = Faraday::RackBuilder.new do |builder|
  builder.use Faraday::HttpCache, store: Rails.cache, logger: Rails.logger, shared_cache: false, serializer: Marshal
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end
Octokit.middleware = stack

Octokit.configure do |c|
  c.api_endpoint = "https://github.ucsb.edu/api/v3/"
end
