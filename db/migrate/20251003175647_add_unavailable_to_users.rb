class AddUnavailableToUsers < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :unavailable, :boolean, default: false, null: false
    execute "UPDATE users SET unavailable = false"
  end

  def down
    remove_column :users, :unavailable
  end
end
