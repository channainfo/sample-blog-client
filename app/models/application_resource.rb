class ApplicationResource <  ActiveResource::Base
  self.site = ENV['API_SERVER']
  self.include_format_in_path = false

  def save(options={})
    begin
      super
    rescue ActiveResource::ForbiddenAccess => ex
      errors = JSON.parse(ex.response.body)['errors']
      parse_and_set_errors(errors)
      false
    end
  end

  def parse_and_set_errors(errors)
    errors.each do |error|
      parse_and_set_error(error)
    end
  end

  # "'title' must be present"
  def parse_and_set_error(field)
    matchers = field.match(/\'([A-Za-z]+)\'\s(.*)/)
    return if matchers.nil?
    field_name = matchers[1]
    error_message = matchers[2]
    self.errors.add(field_name, error_message)

  end
end