class DogImageFetcher
  BASE_URL = ENV["DOG_IMAGE_FETCHER"]

  def self.fetch
    response = RestClient.get(BASE_URL)

    handle_response(response)
  rescue RestClient::ExceptionWithResponse => e
    handle_error("Dog API request failed: #{e.response.body}")
  rescue StandardError => e
    handle_error("Error while fetching dog image: #{e.message}")
  end

  private

  def self.handle_response(response)
    if response.code == 200
      JSON.parse(response.body)['message']
    end
  end

  def self.handle_error(message)
    Rails.logger.error(message)
  end
end

