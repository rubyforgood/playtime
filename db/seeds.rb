# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin = User.create!(
  name: "Rebecca Staples",
  email: "rebecca@playtime.org",
  admin: true
)

user = User.create!(name: "Micah Bales", email: "micahbales@gmail.com")

wishlist = Wishlist.create!(name: "DC General")

SiteManager.create!(user: user, wishlist: wishlist)

item = Item.create!(
  amazon_url: "https://www.amazon.com/Douglas-1713-Toys-Louie-Corgi/dp/B00TFT77ZS/ref=sr_1_1?ie=UTF8&qid=1495377177&sr=8-1&keywords=corgi+toy",
  price_cents: 1320,
  asin: "B00TFT77ZS",
  image_url: "https://images-na.ssl-images-amazon.com/images/I/71u1YGcc-FL._SL1500_.jpg",
  name: "Louis the Corgi"
)

WishlistItem.create!(
  quantity: 1,
  wishlist: wishlist,
  item: item,
  staff_message: "Item for the 3-10 age group. Our shelter cannot support pets, we find these stuffed doggos to be therapeutic for the children."
)
