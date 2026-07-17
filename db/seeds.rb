Product.destroy_all
Category.destroy_all

category_names = [
  "Frozen Meals",
  "Electronics",
  "Clothing",
  "Home"
]

categories = category_names.map do |category_name|
  Category.create!(name: category_name)
end

100.times do |number|
  category = categories[number % categories.length]

  Product.create!(
    name: "#{category.name} Product #{number + 1}",
    description: "A quality #{category.name.downcase} product for Prairie Market customers.",
    price: rand(5.00..250.00).round(2),
    category: category
  )
end

puts "Created #{Category.count} categories"
puts "Created #{Product.count} products"