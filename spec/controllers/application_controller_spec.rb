require 'rails_helper'

RSpec.describe ApplicationController  do
  describe 'handle exception' do
    controller do
      def index
        raise ActiveResource::ServerError.new('anything')
      end
    end

    it 'redirects to root_path' do
      get :index
      expect(response.status).to eq 302
      expect(flash[:error]).to be_present
    end
  end
end