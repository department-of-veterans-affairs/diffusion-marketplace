class Params
  def initialize(params)
    @params = params
  end

  class ParamsData < Params
    def get_id_counts_from_params(hash_attr)
      @params.values.collect { |param| param[hash_attr] }.group_by(&:itself).transform_values(&:count)
    end

    def has_two_existing_records_with_identical_param_values?(hash_attr, current_item_hash_attr)
      @params.select { |hash_key, hash_value| hash_value[hash_attr] === current_item_hash_attr && hash_value[:id].present? }.keys.length > 1
    end
  end

  class ModifyParams < Params
    def delete_param(param_key)
      @params.delete(param_key)
    end

    def delete_duplicate_params(duplicate_params)
      duplicate_params.each do |param_key|
        delete_param(param_key)
      end
    end

    def delete_deep_duplicate_params(duplicate_params)
      duplicate_params.keys.each do |param_key|
        delete_param(param_key)
      end
    end

    def reset_param_id_counts(id_counts, id)
      id_counts[id] = 1
    end
  end
end