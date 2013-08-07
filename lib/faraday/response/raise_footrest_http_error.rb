require 'faraday'
require 'footrest/http_error'

module Faraday
  class Response::RaiseFootrestHttpError < Response::Middleware
    ERROR_MAP = {
      400 => Footrest::HttpError::BadRequest,
      401 => Footrest::HttpError::Unauthorized,
      403 => Footrest::HttpError::Forbidden,
      404 => Footrest::HttpError::NotFound,
      405 => Footrest::HttpError::MethodNotAllowed,
      500 => Footrest::HttpError::InternalServerError,
      501 => Footrest::HttpError::NotImplemented,
      502 => Footrest::HttpError::BadGateway,
      503 => Footrest::HttpError::ServiceUnavailable
    }

    def on_complete(response)
      key = response[:status].to_i
      raise ERROR_MAP[key].new(response) if ERROR_MAP.has_key? key
    end
  end
end