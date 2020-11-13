require 'redis'
$redis = if Rails.env.production? || Rails.env.staging?
           Redis.new(host: '127.0.0.1', port: '6379', db: 0, password: '34688f5da12d845c99d2fc760fdfbd78a75a808b12ec0a9812cfeac2846cce3ed101d6cbdf05ea0dd47870c95a139e47bbcaefd24761088a08d5053db72bb6ba')
         else
           Redis.new(host: '192.168.31.24', port: '6379', db: 0)
         end