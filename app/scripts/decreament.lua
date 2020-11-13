redis.call('SETNX', KEYS[1], ARGV[1])

local r = redis.call('GET', KEYS[1])

if tonumber(r) >= 1 then
  return redis.call('DECR', KEYS[1])
else
  return -1
end
