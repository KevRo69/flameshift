class AddUserToCares < ActiveRecord::Migration[7.1]
  def change
    add_reference :cares, :user, null: true, foreign_key: { on_delete: :nullify }
  end
end
