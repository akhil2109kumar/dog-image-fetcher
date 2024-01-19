# spec/controllers/dogs_controller_spec.rb
require 'rails_helper'

RSpec.describe DogsController, type: :controller do
  describe 'POST #create' do
    let(:valid_params) { { dog_form: { breed: 'Golden Retriever', image_url: 'https://example.com/golden.jpg' } } }
    let(:invalid_params) { { dog_form: { breed: '', image_url: 'https://example.com/golden.jpg' } } }

    context 'when dog with the given breed exists' do
      let!(:existing_dog) { create(:dog, breed: 'Golden Retriever', image_url: 'https://example.com/golden.jpg') }

      it 'finds the existing dog and renders json' do
        post :create, params: valid_params
        expect(assigns(:dog)).to eq(existing_dog)
        expect(response).to have_http_status(:success)
        expect(response.body).to include(existing_dog.breed, existing_dog.image_url)
      end
    end

    context 'when dog with the given breed does not exist' do
      it 'creates a new dog and renders json' do
        post :create, params: valid_params
        new_dog = Dog.find_by(breed: valid_params[:dog_form][:breed])
        expect(assigns(:dog)).to eq(new_dog)
        expect(response).to have_http_status(:success)
        expect(response.body).to include(new_dog.breed, new_dog.image_url)
      end

      it 'fails to save and renders error json for invalid params' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Failed to save the form')
      end
    end

    context 'when the breed is an empty string' do
      it 'fails to save and renders error json' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Failed to save the form')
        expect(Dog.find_by(breed: '')).to be_nil
      end
    end
  end
end
