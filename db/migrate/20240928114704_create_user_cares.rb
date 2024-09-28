class CreateUserCares < ActiveRecord::Migration[7.1]
  def change
    create_table :user_cares do |t|
      t.references :user, null: false, foreign_key: true
      t.references :care, null: false, foreign_key: true

      t.timestamps
    end
  end
end
