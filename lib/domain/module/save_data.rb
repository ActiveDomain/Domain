module Domain
  module SaveData
    attr_accessor :data

    def save_data!(data, prefix: nil)
      @data = data
      @data.save!
      @data = @data.data if @data.is_a?(DataModel::Base)
      true
    rescue ActiveRecord::RecordInvalid, ActiveRecord::Rollback
      errors.add_model_error(@data, prefix: prefix)
      raise ActiveRecord::Rollback # 外部のTransactionを正常に終了させたいので、Rollbackを投げる
    end

    def update_data!(data, options, prefix: nil)
      @data = data
      @data.update!(options)
      true
    rescue ActiveRecord::RecordInvalid, ActiveRecord::Rollback
      errors.add_model_error(@data, prefix: prefix)
      raise ActiveRecord::Rollback # 外部のTransactionを正常に終了させたいので、Rollbackを投げる
    end

    def update_data(data, options, prefix: nil)
      @data = data
      if @data.update(options)
        true
      else
        errors.add_model_error(@data, prefix: prefix)
        false
      end
    end

    def save_data(data, prefix: nil)
      @data = data
      if @data.save
        @data = @data.data if @data.is_a?(DataModel::Base)
        true
      else
        errors.add_model_error(@data, prefix: prefix)
        false
      end
    end
  end
end
