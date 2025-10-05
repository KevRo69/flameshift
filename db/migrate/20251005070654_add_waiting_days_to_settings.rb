class AddWaitingDaysToSettings < ActiveRecord::Migration[7.1]
  def up
    add_column :settings, :days_waiting, :integer, default: 5, null: false
    execute "UPDATE settings SET days_waiting = 5"
  end

  def down
    remove_column :settings, :days_waiting
  end
end
