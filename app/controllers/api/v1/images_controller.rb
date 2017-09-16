class Api::V1::ImagesController < ApplicationController

  before_action :verify_authenticity

  # Compresses the image in the URL
  def compress_url
    response = ImageCompressor.compress_from_url params[:url], params.to_unsafe_h.symbolize_keys
    json_response(response)
  end

  private

  def verify_authenticity
    unless params[:auth_token].present? && params[:auth_token] == "9a0206b315a25b62e9706b0b3217636a"
      json_response({ status: "failure", message: "Unauthorized Access" }, :unauthorized)
    end
  end
end
