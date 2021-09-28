require 'rails_helper'

RSpec.describe Resource::Comment do
  describe 'validations' do
    subject { Resource::Comment.new(name: 'Channa L.', body: 'just awesome!')}

    it 'is valid' do
      expect(subject.valid?).to eq true
    end

    it 'validates name to be presents' do
      subject.name = ''
      expect(subject.valid?).to eq false
      expect(subject.errors.full_messages).to eq ["Name must be present"]
    end

    it 'validate body to be present' do
      subject.body = ''
      expect(subject.valid?).to eq false
      expect(subject.errors.full_messages).to eq ["Body must be present"]
    end
  end

  describe '#create', :vcr do
    context 'with valid attribute' do
      it 'creates comment' do
        post = create(:post)
        comment = build(:comment, post: post)
        result = comment.save

        expect(result).to eq true
        expect(comment.persisted?).to eq true
      end
    end

    context 'with invalid attribute' do
      it 'return errors' do
        comment = build(:comment)
        comment.name = nil
        
        result = comment.save

        expect(result).to eq false
        expect(comment.persisted?).to eq false
        expect(comment.errors['name']).to eq ["must be present"]
        expect(comment.errors.full_messages).to eq ["Name must be present"]
      end
    end
  end
end