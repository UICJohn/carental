FactoryBot.define do
  factory :state do
    name { 'Guangdong' }

    before(:create) do |state, evaluator|
      if state.country_id.blank?
        state.country_id = Country.first_or_create(name: 'China').id
      end
    end
  end
end
