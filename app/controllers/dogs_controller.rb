class DogsController < ApplicationController

  def create
    @dog = Dog.find_by(breed: dog_params[:breed])
    if @dog.nil?
      @dog = Dog.new(dog_params)
      @dog.image_url = DogImageFetcher.fetch()
    end

    if @dog.save
      render json: { breed: @dog.breed, image_url: @dog.image_url }
    else
      render json: { error: 'Failed to save the form' }, status: :unprocessable_entity
    end
  end

  private

  def dog_params
    params.require(:dog_form).permit(:breed, :image_url)
  end
end
