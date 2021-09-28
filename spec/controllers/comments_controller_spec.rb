require 'rails_helper'

RSpec.describe CommentsController do
  describe '#GET new', :vcr do
    it 'renders template' do
      blog = create(:post)
      get :new, params: { post_id: blog.id}
      expect(response).to render_template("new")
    end

    it 'assigns @post and @comment' do
      blog = create(:post)
      get :new,  params: { post_id: blog.id}

      expect(assigns(:post)).to eq blog
      expect(assigns(:comment).name).to eq ''
      expect(assigns(:comment).body).to eq ''
    end
  end

  describe '#POST create', :vcr do
    context 'with valid attribute' do
      it 'create record and redirect' do
        blog = create(:post)
        post :create, params: { post_id: blog.id, resource_comment: {name: blog.title, body: blog.body }}

        expect(assigns(:comment).persisted?).to eq true
        expect(response.status).to eq 302
      end
    end

    context 'with invalid attributes' do
      it 'render template new with @post variable' do
        blog = create(:post)
        post :create, params: { post_id: blog.id, resource_comment: {title: '', body: '' }}

        expect(assigns(:comment).persisted?).to eq false
        expect(response).to render_template("new")
      end
    end
  end

  
end