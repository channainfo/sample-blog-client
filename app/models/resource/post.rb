class Resource::Post < ::ApplicationResource
  before_validation :validate_attributes


  def comments(scope = :all)
    Resource::Comment.find(scope, :params => {:post_id => self.id})
  end

  protected

  def validate_attributes
    self.errors.add("title", "must be present") if self.attributes[:title].blank?
    self.errors.add("body", "must be present") if self.attributes[:body].blank?
  end

end