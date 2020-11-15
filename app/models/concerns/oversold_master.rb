module OversoldMaster
  extend ActiveSupport::Concern

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

      return 0
    "
  end

  def reserve!(dates)
    result = $redis.eval(
                                  lua_script,
                                  dates.map{ |date| cache_key(date.to_s)},
                                  [dates.count]
                                )
    p result
    # block.call(result)
  end

  def cache_key(postfix)
    "#{self.class.name}:#{self.id}:amount:#{postfix}"
  end
end