module Domain
  class Errors < ActiveModel::Errors
    def add_model_error(model, prefix: nil)
      model.errors.each do |key, val|
        key = "#{prefix}.#{key}" if prefix.present?
        add(key, val)
      end
    end
  end
end
