# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
country = Country.create(name: 'China')

zhejiang = State.create(name: 'Zhejiang', country: country)
guangdong = State.create(name: 'Guangdong', country: country)

shengzhen = City.create(name: 'Shengzhen', state: guangdong)
hangzhou = City.create(name: 'Hangzhou', state: zhejiang)

volvo  =  Brand.create(name: 'volvo')
bmw    =  Brand.create(name: 'bmw')
benz   =  Brand.create(name: 'benz')
toyota =  Brand.create(name: 'toyota')
honda  =  Brand.create(name: 'honda')

xc90 = Model.create(name: 'xc90', brand: volvo)
s60  = Model.create(name: 's60', brand: volvo)
bmw740 = Model.create(name: '740L', brand: bmw)
bmw320 = Model.create(name: '320L', brand: bmw)
benzs500 = Model.create(name: 's500', brand: benz)
camary = Model.create(name: 'camary', brand: toyota)
accord = Model.create(name: 'accord', brand: honda)

store1 = Store.create(address: '南山科技园', city: shengzhen)
store2 = Store.create(address: '中山大道', city: hangzhou)

vehicle1 = Vehicle.create(model: xc90,   store: store1, color: 'red',    amount: 3, price: 1200)
vehicle1 = Vehicle.create(model: s60,    store: store1, color: 'yellow', amount: 3, price: 1000)
vehicle1 = Vehicle.create(model: bmw740, store: store2, color: 'green',  amount: 1, price: 1200)
vehicle1 = Vehicle.create(model: xc90,   store: store2, color: 'red',    amount: 3, price: 1100)
vehicle1 = Vehicle.create(model: bmw320, store: store2, color: 'white',  amount: 3, price: 1200)
vehicle1 = Vehicle.create(model: xc90,   store: store1, color: 'black',  amount: 3, price: 1200)
vehicle1 = Vehicle.create(model: s60,    store: store1, color: 'white',  amount: 0, price: 1200)