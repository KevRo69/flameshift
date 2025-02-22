class AddInfosToSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :settings, :infos, :text
  end
end
