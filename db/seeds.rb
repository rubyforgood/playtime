# Read the seed data into memory. Do this before deleting data to be sure there isn't a problem
seed_data = Dir.glob(Rails.root.join('db', 'seed', '**', '*.yml')).reduce({}) { |collection, file|
  collection[File.basename(file, '.yml')] = YAML::load_file(Rails.root.join('db', 'seed', file))
  collection
}

# Remove all seeded data.
Pledge.delete_all
WishlistItem.delete_all
SiteManager.delete_all
Wishlist.delete_all
User.delete_all
Item.delete_all

# First create the admin
User.create(
  name: 'Sally Ride',
  email: 'ride@example.com',
  admin: true
)

wishlists = Wishlist.create!(seed_data['wishlists'])
users = User.create(seed_data['users'])
items = Item.create(seed_data['items'])

# Associate users with wishlists in order
site_managers = (0..5).collect { |index|
  SiteManager.create!(user: users[index], wishlist: wishlists[index])
}

# Randomly assign several items to a wishlist
wishlist_items = items.map { |item|
  wishlist_sample = wishlists.shuffle.take(Random.rand(3))
  wishlist_sample.map { |wishlist|
    WishlistItem.create!(
      quantity: 1,
      wishlist: wishlist,
      item: item
    )
  }
}.flatten

# Owned pledges
Pledge.create!(user: users.first, wishlist_item: wishlist_items.first)
Pledge.create!(user: users.second, wishlist_item: wishlist_items.second)
Pledge.create!(user: users.last, wishlist_item: wishlist_items.last)

# Anonymous pledges
Pledge.create!(wishlist_item: wishlist_items[10])
Pledge.create!(wishlist_item: wishlist_items[11])
Pledge.create!(wishlist_item: wishlist_items[12])
