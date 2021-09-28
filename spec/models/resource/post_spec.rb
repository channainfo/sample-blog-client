require 'rails_helper'

RSpec.describe Resource::Post do
  describe 'validations' do
    subject { Resource::Post.new(title: 'what is new in Rails 7.', body: 'just awesome!')}

    it 'is valid' do
      expect(subject.valid?).to eq true
    end

    it 'validates title to be presents' do
      subject.title = ''
      expect(subject.valid?).to eq false
      expect(subject.errors.full_messages).to eq ["Title must be present"]
    end

    it 'validate body to be present' do
      subject.body = ''
      expect(subject.valid?).to eq false
      expect(subject.errors.full_messages).to eq ["Body must be present"]
    end
  end

  describe '#create post', :vcr do
    context 'with valid attribute' do
      it 'creates post' do
        post = build(:post)
        
        result = post.save

        expect(result).to eq true
        expect(post.persisted?).to eq true
      end
    end

    context 'with invalid attribute' do
      it 'return errors' do
        post = build(:post)
        post.title = nil
        
        # expect{ post.save }.to raise_error ActiveResource::ForbiddenAccess
        result = post.save

        expect(result).to eq false
        expect(post.persisted?).to eq false
        expect(post.errors['title']).to eq ["must be present"]
        expect(post.errors.full_messages).to eq ["Title must be present"]
      end
    end
  end

  describe '#posts', :vcr do
    it 'returns all posts' do
      post1 = create(:post)
      post2 = create(:post)
      posts = Resource::Post.all

      expect(posts[-2..-1].map(&:id).sort).to eq [post1.id, post2.id].sort
    end
  end

  describe '#comments', :vcr do
    it 'returns comments' do
      post = create(:post)

      comment1 = create(:comment, post: post)
      comment2 = create(:comment, post: post)

      expect(post.comments.map(&:id).sort).to eq [comment1.id, comment2.id].sort
    end
  end

  describe '#find', :vcr do
    context 'Post id is valid' do
      it 'return post' do
        post = create(:post)

        result = Resource::Post.find(post.id)
        expect(result).to eq post
      end
    end

    context 'post id is not found' do
      it 'raise error when id is not found' do
        not_found_id = 9999999
        
        # it should raise 404 resource not found by API does not handle this
        expect{Resource::Post.find(not_found_id)}.to raise_error ActiveResource::ServerError
      end
    end
  end
end