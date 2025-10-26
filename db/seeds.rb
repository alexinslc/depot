# frozen_string_literal: true

Rails.logger.debug "🌱 Seeding database..."

# Clear existing data
Rails.logger.debug "  Clearing existing data..."
Product.destroy_all
User.destroy_all

# Create admin user
Rails.logger.debug "  Creating admin user..."
admin = User.create!(
  email_address: "admin@depot.com",
  password: "password",
  password_confirmation: "password"
)
Rails.logger.debug { "    ✓ Admin user created: #{admin.email_address}" }

# Create sample products
Rails.logger.debug "  Creating products..."

products_data = [
  {
    title: "Docker for Rails Developers",
    description: %(<p><em>Build, Ship, and Run Your Applications Everywhere</em> Docker does for DevOps what Rails did for web development.</p>),
    image_url: "ridocker.jpg",
    price: 19.95
  },
  {
    title: "Design and Build Great Web APIs",
    description: %(<p><em>Robust, Reliable, and Resilient</em> APIs are transforming the business world at an increasing pace.</p>),
    image_url: "maapis.jpg",
    price: 24.95
  },
  {
    title: "Modern CSS with Tailwind",
    description: %(<p><em>Flexible Styling Without the Fuss</em> Tailwind CSS is an exciting new CSS framework.</p>),
    image_url: "tailwind.jpg",
    price: 18.95
  },
  {
    title: "Programming Phoenix",
    description: %(<p><em>Productive, Reliable, Fast</em> Phoenix creator Chris McCord walks you through building fast applications.</p>),
    image_url: "phoenix.jpg",
    price: 35.00
  },
  {
    title: "Agile Web Development with Rails 8",
    description: %(<p><em>Learn Rails the Right Way</em> Rails 8 completely redefines what it means to produce fantastic user experiences.</p>),
    image_url: "rails8.jpg",
    price: 45.00
  }
]

products_data.each do |product_data|
  product = Product.create!(product_data)
  Rails.logger.debug { "    ✓ Created: #{product.title} ($#{product.price})" }
end

Rails.logger.debug "\n✅ Database seeded successfully!"
Rails.logger.debug { "   Products: #{Product.count}" }
Rails.logger.debug { "   Users: #{User.count}" }
Rails.logger.debug "\n📧 Admin credentials:"
Rails.logger.debug "   Email: admin@depot.com"
Rails.logger.debug "   Password: password"
