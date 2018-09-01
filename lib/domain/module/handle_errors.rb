module Domain
  module HandleErrors
    attr_accessor :error_status, :error_type, :error_code, :is_error

    def set_errors(status: nil, type: nil, code: nil, params: nil)
      @error_status = status if status.present?
      @error_type = type if type.present?
      @error_code = code if code.present?
      errors.add(:is_error, 'error')
      params.each { |key, value| errors.add(key, value) } if params.present?
      false
    end

    def not_found(code)
      set_errors(
        status: :not_found,
        type: 'invalid_request_error',
        code: code
      )
    end

    def unauthorized(code: nil, params: nil)
      set_errors(
        status: :unauthorized,
        type: 'authentication_error',
        code: code,
        params: params
      )
    end

    def unprocessable_entity(code: nil, params: nil)
      set_errors(
        status: :unprocessable_entity,
        type: 'invalid_request_error',
        code: code,
        params: params
      )
    end

    def internal_server_error(code)
      set_errors(
        status: :internal_server_error,
        type: 'unexpected_error',
        code: code,
        params: params
      )
    end
  end
end
