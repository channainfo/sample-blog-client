require 'rails_helper'

RSpec.describe PostsController do
  describe '#GET index', :vcr do
    it 'renders template' do
      get :index
      expect(response).to render_template("index")
    end

    it 'assigns @posts' do
      post1 = create(:post)

      get :index

      posts = assigns(:posts)[-1]
      expect(posts).to eq(post1)
    end
  end

  describe '#GET show', :vcr do
    it 'renders template' do
      post = create(:post)
      get :show, params: { id: post}
      expect(response).to render_template("show")
    end

    it 'assigns @post and @comments' do
      post = create(:post)
      comment = create(:comment, post: post)

      get :show, params: { id: post.id}

      expect(assigns(:post)).to eq post
      expect(assigns(:comments)).to eq [comment]
    end
  end

  describe '#GET new', :vcr do
    it 'renders template' do
      get :new
      expect(response).to render_template("new")
    end

    it 'assigns @post' do
      get :new

      post = assigns(:post)
      expect(post.title).to eq ''
      expect(post.body).to eq ''
    end
  end

  describe '#POST create', :vcr do
    context 'with valid attribute' do
      it 'create record and redirect' do
        blog = build(:post)
        post :create, params: { resource_post: {title: blog.title, body: blog.body }}

        expect(assigns(:post).persisted?).to eq true
        expect(response.status).to eq 302
      end
    end

    context 'with invalid attributes' do
      it 'render template new with @post variable' do
        post :create, params: { resource_post: {title: '', body: '' }}

        expect(assigns(:post).persisted?).to eq false
        expect(response).to render_template("new")
      end
    end
  end

  
end