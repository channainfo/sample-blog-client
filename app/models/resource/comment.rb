class Resource::Comment < ::ApplicationResource
  self.site = "#{ENV['API_SERVER']}/posts/:post_id/"

  before_validation :validate_attributes

  def post
    Resource::Post.find(self.prefix_options[:post_id])
  end

  def post=(post)
    self.prefix_options[:post_id] = post.id
  end

  def post_id=(post_id)
    self.prefix_options[:post_id] = post_id
  end

  def validate_attributes
    self.errors.add("name", "must be present") if self.attributes[:name].blank?
    self.errors.add("body", "must be present") if self.attributes[:body].blank?
  end
end