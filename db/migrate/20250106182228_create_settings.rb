class CreateSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :settings do |t|
      t.integer :last_day
      t.text :rules
      t.text :warning

      t.timestamps
    end
  end
end
