class Connection
  attr_accessor :response

  def http_request(verb, path, params = {})
    url = api_url(path)
    @response = nil

    log_request(verb, url, params)

    if verb == :post
      @response = post(url, params)

    elsif verb == :put
      @response = put(url, params)

    elsif verb == :get
      @response = get(url, params)
    end
    @response
  end

  def json_response_body
    return {} if @response.try(:body).blank?

    json = JSON.parse(@response.body)

    if json.blank?
      { data: [], meta: { total: 0, total_pages: 0 } }
    else
      json.with_indifferent_access
    end
  end

  def response_body
    @response.body
  end

  def ok?
    @response.status.in?([200, 201, 202, 204])
  end

  def errors
    json_response_body[:error][:json]
  end

  def log_request(verb, url, params)
    Rails.logger.debug { "Service #{verb.upcase} #{url} \nParameters: #{params.inspect}"}
  end

  def post(url, params)
    connection = connection_builder(url)

    @response = connection.post do |req|
      req.url url
      req.headers['Content-Type'] = 'application/json'
      req.body = params.to_json
    end

    check_client_auth_status

    @response
  end

  def put(url, params = {})
    connection = connection_builder(url)

    @response = connection.put do |req|
      req.url url
      req.headers['Content-Type'] = 'application/json'
      req.body = params.to_json
    end

    check_client_auth_status

    @response
  end


  def get(url, params)
    connection = connection_builder(url)

    @response = connection.get do |req|
      req.url url
      req.headers['Content-Type'] = 'application/json'
      req.params = params
    end

    check_client_auth_status

    @response
  end

  def connection_builder(url)
    Faraday::Connection.new(url) do |builder|
      builder.options[:open_timeout] = 180
      builder.options[:timeout] = 180
      builder.adapter Faraday.default_adapter
    end
  end

  def check_client_auth_status
    if @response.status == 403
      raise ::ApiAuthorizationError
    end
  end

  def api_url(path)
    host = ENV['BASE_API'].end_with?('/') ? ENV['BASE_API'][0..-2] : ENV['BASE_API']
    path = path.start_with?('/') ? path[1..-1] : path
    "#{host}/#{path}"
  end
end
