class AddCa1EToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :CA1E, :boolean, default: false, null: false
  end
end
