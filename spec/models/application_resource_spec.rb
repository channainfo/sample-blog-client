require 'rails_helper'

RSpec.describe ApplicationResource do
  describe '#parse_and_set_errors' do
    it 'calls parse_and_set_error' do

      errors = [
        "'title' must be present",
        "'body' must be present",
      ]

      obj = Resource::Post.new

      expect(obj).to receive(:parse_and_set_error).with("'title' must be present")
      expect(obj).to receive(:parse_and_set_error).with("'body' must be present")
      obj.parse_and_set_errors(errors)
    end
  end

  describe '#parse_and_set_error' do
    it 'set errors is errors match the pattern' do

      error = "'title' must be present"

      object = Resource::Post.new
      object.parse_and_set_error(error)

      expect(object.errors.present?).to eq true
      expect(object.errors[:title]).to eq ['must be present']
    end
  end
end