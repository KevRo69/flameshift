class AddDefaultToDeactivatedInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :deactivated, from: nil, to: false
  end
end
