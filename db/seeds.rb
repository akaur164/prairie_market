# Clear existing data
Product.destroy_all
Category.destroy_all
Province.destroy_all

# ----------------------------
# Categories
# ----------------------------
category_names = [
  "Frozen Meals",
  "Electronics",
  "Clothing",
  "Home"
]

categories = category_names.map do |category_name|
  Category.create!(name: category_name)
end

# ----------------------------
# Products
# ----------------------------
100.times do |number|
  category = categories[number % categories.length]

  Product.create!(
    name: "#{category.name} Product #{number + 1}",
    description: "A quality #{category.name.downcase} product for Prairie Market customers.",
    price: rand(5.00..250.00).round(2),
    category: category
  )
end

# ----------------------------
# Canadian Provinces & Territories
# ----------------------------
Province.create!([
  {
    name: "Alberta",
    code: "AB",
    gst_rate: 0.05,
    pst_rate: 0.00,
    hst_rate: 0.00
  },
  {
    name: "British Columbia",
    code: "BC",
    gst_rate: 0.05,
    pst_rate: 0.07,
    hst_rate: 0.00
  },
  {
    name: "Manitoba",
    code: "MB",
    gst_rate: 0.05,
    pst_rate: 0.07,
    hst_rate: 0.00
  },
  {
    name: "New Brunswick",
    code: "NB",
    gst_rate: 0.00,
    pst_rate: 0.00,
    hst_rate: 0.15
  },
  {
    name: "Newfoundland and Labrador",
    code: "NL",
    gst_rate: 0.00,
    pst_rate: 0.00,
    hst_rate: 0.15
  },
  {
    name: "Northwest Territories",
    code: "NT",
    gst_rate: 0.05,
    pst_rate: 0.00,
    hst_rate: 0.00
  },
  {
    name: "Nova Scotia",
    code: "NS",
    gst_rate: 0.00,
    pst_rate: 0.00,
    hst_rate: 0.15
  },
  {
    name: "Nunavut",
    code: "NU",
    gst_rate: 0.05,
    pst_rate: 0.00,
    hst_rate: 0.00
  },
  {
    name: "Ontario",
    code: "ON",
    gst_rate: 0.00,
    pst_rate: 0.00,
    hst_rate: 0.13
  },
  {
    name: "Prince Edward Island",
    code: "PE",
    gst_rate: 0.00,
    pst_rate: 0.00,
    hst_rate: 0.15
  },
  {
    name: "Quebec",
    code: "QC",
    gst_rate: 0.05,
    pst_rate: 0.09975,
    hst_rate: 0.00
  },
  {
    name: "Saskatchewan",
    code: "SK",
    gst_rate: 0.05,
    pst_rate: 0.06,
    hst_rate: 0.00
  },
  {
    name: "Yukon",
    code: "YT",
    gst_rate: 0.05,
    pst_rate: 0.00,
    hst_rate: 0.00
  }
])

puts "Created #{Category.count} categories"
puts "Created #{Product.count} products"
puts "Created #{Province.count} provinces and territories"
