module ModelUtils
  class Helpers
    def strip_attributes(model_attributes = [])
      model_attributes.each do |attr|
        attr&.strip! || attr
      end
    end
  end
end