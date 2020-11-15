module Cache
  class Vehicle
    attr_reader :vehicle

    def initialize(verhicle)
      @vehicle = verhicle
    end

    def startup
      (Time.zone.now.to_date...1.years.since.to_date).each do |date|
        inject(date)
      end
    end

    def fetch(date)
      $redis.get(vehicle.key(date))
    end

    def decrease(date)
      $redis.decr(vehicle.key(date))
    end

    def increase(date)
      $redis.incr(vehicle.key(date))
    end

    private

    def inject(date)
      orders_count = vehicle.orders.not_fullfilled.where("starts_at <= :date and expires_at >= :date", { date: date }).count

      if orders_count.positive?
        $redis.setnx(vehicle.key(date), vehicle.amount - orders_count)
      end
    end
  end
end
