class AddUnavailableToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :unavailable, :boolean, default: false, null: false
    execute "UPDATE users SET unavailable = false"
  end
end
