class CreateCares < ActiveRecord::Migration[7.1]
  def change
    create_table :cares do |t|
      t.integer :day
      t.integer :month
      t.integer :year

      t.timestamps
    end
  end
end
