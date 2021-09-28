class Base
  include ActiveModel::Model
  include ActiveModel::Serialization

  # object attributes
  attr_accessor :id

  def initialize(options = {})
    assign_attrs!(options)
    @connection = Connection.new
  end

  def connection
    # raise "You must set the access token to make http request" if @api_access_token.nil?
    @connection
  end

  # /api/v2
  def prefix
    ''
  end

  def class_underscore
    self.class.to_s.underscore.split('/').last.pluralize
  end

  def model_path
    "#{prefix}/#{class_underscore}"
  end

  def create_url
    model_path
  end

  def index_url
    model_path
  end

  def edit_url
    "#{model_path}/:id/edit"
  end

  def show_url
    "#{model_path}/:id"
  end

  def update_url
    "#{model_path}/:id"
  end

  def delete_url
    "#{model_path}/:id"
  end

  def new_record?
    id.blank?
  end

  def build(options = {})
    assign_attrs!(options)
    self
  end

  def create(options)
    assign_attrs!(options)
    end_point = create_url

    if valid?
      connection.http_request(:post, end_point, options)
      response_data = connection.json_response_body
      assign_options!(response_data[:data]) if response_data[:data].present?
      self.errors = connection.errors unless connection.ok?
    end
    self
  end

  def fetch(id)
    edit(id)
  end

  def edit(id)
    end_point = edit_url.gsub(':id', id)

    connection.http_request(:get, end_point)
    response_data = connection.json_response_body

    assign_options!(response_data[:data])
    self
  end

  def show(id)
    end_point = show_url.gsub(':id', id)

    connection.http_request(:get, end_point)
    response_data = connection.json_response_body

    assign_options!(response_data[:data])
    self
  end

  def update(id, options = {})
    end_point = update_url.gsub(':id', id)

    assign_attrs!(options)
    self.id = id

    if valid?
      connection.http_request(:put, end_point, options)
      response_data = connection.json_response_body
      if connection.ok?
        assign_options!(response_data[:data])
      else
        self.errors = connection.errors
      end
    end
    self
  end

  def http_ok?
    connection.ok?
  end

  def assign_options!(options)
    return if options.nil?

    attrs = options[:attributes].merge(id: options[:id], type: options[:type])
    assign_attrs!(attrs)
  end

  def assign_attrs!(attrs)
    @attrs ||= []
    @attrs = (@attrs + attrs.keys).uniq

    attrs.each do |name, value|
      # self.instance_variable_set("@#{name}", value)
      self.class.send(:define_method, "#{name}=".to_sym) do |value|
        instance_variable_set("@#{name}", value)
      end unless self.respond_to?("#{name}=".to_sym)

      self.class.send(:define_method, name.to_sym) do
        instance_variable_get("@" + name.to_s)
      end

      self.send("#{name}=".to_sym, value)
    end
    self
  end

  # https://api.rubyonrails.org/classes/ActiveModel/Serialization.html
  # attrs list to be serialized
  def attributes
    serializable = {}

    @attrs.each do |key|
      serializable[key.to_s] = nil
    end

    serializable
  end

  def as_json(options = {})
    serializable_hash
  end

  # rails 5 AMS
  def api_http?
    false
  end

  def errors=(options)
    options.each do |key, value|
      self.errors.add(key, value)
    end
  end

  def error?
    self.errors.full_messages.present?
  end
end
