class DogsController < ApplicationController

  def create
    dog = find_or_initialize_dog

    if dog.save
      render json: { breed: dog.breed, image_url: dog.image_url }
    else
      render json: { error: 'Failed to save the form' }, status: :unprocessable_entity
    end
  end

  private

  def dog_params
    params.require(:dog_form).permit(:breed, :image_url)
  end

  def find_or_initialize_dog
    Dog.find_or_initialize_by(breed: dog_params[:breed]) do |dog|
      dog.assign_attributes(dog_params)
      dog.image_url = DogImageFetcher.fetch
    end
  end
end
