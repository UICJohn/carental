module OversoldMaster
  extend ActiveSupport::Concern

  module ClassMethods
    def lua_script
      "
        for i=1, ARGV[1], 1 do
          local cache_amount = redis.call('GET', KEYS[i])
          if tonumber(cache_amount) < 1 then
            return -1
          end
        end

        for i=1, ARGV[1], 1 do
          redis.call('DECR', KEYS[1])
        end
      "
    end
  end

  module InstanceMethods

    def reserve!(dates, block)
      reserve_result = $redis.eval(
                                    self.class.lua_script,
                                    dates.map{ |date| cache_key(date.to_s)},
                                    [dates.count]
                                  )
      
      block.call(reserve_result)
    end

    private

    def cache_key(postfix)
      "#{self.class.name}:#{self.id}:amount:#{postfix}"
    end
  end
end