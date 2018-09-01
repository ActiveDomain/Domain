module Domain
  def self.included(base)
    base.extend(ClassMethods)
  end

  def execute
    raise NotImplementedError, "You must implement #{self.class}#execute"
  end

  module ClassMethods
    def execute(*params)
      domain = self.new(*params)
      return false if domain.invalid?

      ActiveRecord::Base.transaction do
        domain.execute
      end
      domain
    end
  end
end
