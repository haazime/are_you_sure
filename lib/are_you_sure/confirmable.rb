module AreYouSure
  module Confirmable

    def prepare_confirmation(confirmed, cache)
      @are_you_sure_confirmed = confirmed
      @are_you_sure_cache = cache
    end

    def fill_attributes
      if @are_you_sure_cache.stored?
        self.attributes = @are_you_sure_cache.retrieve
      end
    end

    def save_if_confirmed
      do_if_can_persist { self.save }
    end

    def update_if_confirmed(attributes)
      self.attributes = attributes
      do_if_can_persist { self.update(attributes) }
    end

    def update_attributes_if_confirmed(attributes)
      self.attributes = attributes
      do_if_can_persist { self.update_attributes(attributes) }
    end

    def update_attribute_if_confirmed(name, value)
      update_attributes_if_confirmed(name => value)
    end

    def confirmed?
      @are_you_sure_confirmed == 'confirmed'
    end

    def should_confirm?
      @are_you_sure_confirmed.nil?
    end

  private

    def do_if_can_persist
      return false unless self.valid?
      memorize_attributes
      return false unless confirmed?
      yield
    end

    def memorize_attributes
      @are_you_sure_cache.store(self.attributes)
    end
  end
end
