FactoryBot.define do
  factory :store do
    name { 'Budget' }
    city {City.find_by(name: 'Shengzhen')}

    # before(:create) do |state, evaluator|
    #   if state.country_id.blank?
    #     state.country_id = Country.first_or_create(name: 'China').id
    #   end
    # end
  end
end
