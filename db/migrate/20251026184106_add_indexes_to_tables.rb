class AddIndexesToTables < ActiveRecord::Migration[8.1]
  def change
    # Products indexes
    add_index :products, :title unless index_exists?(:products, :title)
    add_index :products, :price unless index_exists?(:products, :price)
    add_index :products, :created_at unless index_exists?(:products, :created_at)

    # Users indexes (email already has unique index)
    add_index :users, :created_at unless index_exists?(:users, :created_at)

    # Sessions indexes
    add_index :sessions, :created_at unless index_exists?(:sessions, :created_at)
    add_index :sessions, [:user_id, :created_at] unless index_exists?(:sessions, [:user_id, :created_at])
  end
end
