FactoryBot.define do
  factory :city do
    name { 'Shengzhen' }

    before(:create) do |city, _evaluator|
      if city.sate_id.blank?
        country = Country.first_or_create(name: 'China')
        city.state_id = State.first_or_create(country: country, name: 'Guangdong').id
      end
    end
  end
end
