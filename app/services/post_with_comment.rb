class PostWithComment
  def initialize(post_id)
    @post_id = post_id
  end

  def call
    load_post
    load_comment
  end

  def load_post
    post
  end

  def self.call(post_id)
    post_with_comment = new
    post_with_comment.call
    post_with_comment
  end
end