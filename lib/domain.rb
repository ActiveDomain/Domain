require 'domain/version'
require 'domain/class/errors'
require 'domain/module/handle_errors'
require 'domain/module/save_data'

module Domain
  class Base
    include ActiveModel::Model
    include Domain::HandleErrors
    include Domain::SaveData

    attr_accessor :params

    # 現状、new以外で代入された値については変化があったかどうかわからない。
    # Dirtyと組み合わせることで良い感じになる可能性があるのでこのコメントを残しておきます
    # include ActiveModel::Dirty
    def self.attr_accessor(*vars)
      super(*vars)
      vars.each do |var|
        define_method("has_#{var}?") { @params&.has_key?(var) }
      end
    end

    def initialize(params = {})
      super(params)
      @params = params
    end

    def create_params(*attr_names)
      {}.tap do |params|
        attr_names.each do |name|
          params[name] = send(name) if send("has_#{name}?")
        end
      end
    end

    def errors
      @errors ||= Domain::Errors.new(self)
    end
  end
end
