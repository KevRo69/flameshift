class CreateAvailabilties < ActiveRecord::Migration[7.1]
  def change
    create_table :availabilties do |t|
      t.integer :day
      t.integer :month
      t.integer :year
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
