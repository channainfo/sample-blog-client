
class Post < Base

  attr_accessor :id, :title, :body

  validates :title, :body, presence: true

  def build
    current_http.http_request(:get, "/api/v2/operator/agencies/new")
    response_data = current_http.json_response_body

    self.assign_options!(response_data[:data])
    self
  end

  def create(options)
    self.assign_attrs!(options)

    if(self.valid?)
      current_http.http_request(:post, "/posts", options)
      self.errors = current_http.errors if !current_http.ok?
    end

    self
  end

  def update(id, options)
    self.assign_attrs!(options)
    self.id = id

    if(self.valid?)
      current_http.http_request(:put, "/posts/#{id}", options)
      self.errors = current_http.errors if !current_http.ok?
    end
    self
  end

  def fetch(id)
    current_http.http_request(:get, "/api/v2/operator/agencies/#{id}/edit")
    response_data = current_http.json_response_body
    self.assign_options!(response_data[:data])
    self
  end

  def delete(id)
    current_http.http_request(:delete, "/api/v2/operator/agencies/#{id}")
    response_data = current_http.json_response_body

    if current_http.ok?
      self.assign_options!(response_data[:data])
      self
    else
      nil
    end
  end

end
