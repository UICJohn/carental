module OversoldMaster
  extend ActiveSupport::Concern

  def lua_script
    "
      local keys = KEYS
      for i=1, #keys, 1 do
        local cache_amount = redis.call('GET', KEYS[i])
        if cache_amount == nil
        then
          redis.call('SETNX', ARGV[1])
        elseif tonumber(cache_amount) < 1
        then
          return -1
        end
      end

      for i=1, #keys, 1 do
        redis.call('DECR', KEYS[i])
      end

      return 0
    "
  end

  def reserve!(start_date, end_date)
    result = $redis.eval(
                          lua_script,
                          (start_date.to_date...end_date.to_date).map{ |date| cache_key(date.to_s)},
                          [amount]
                        )
    # block.call(result)
  end

  def cache_key(postfix)
    "#{self.class.name}:#{self.id}:amount:#{postfix}"
  end
end