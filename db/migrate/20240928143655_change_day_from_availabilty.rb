class ChangeDayFromAvailabilty < ActiveRecord::Migration[7.1]
  def change
    # Assuming day, month, and year together represent a date, we'll convert them to a date type
    add_column :availabilties, :new_day, :date

    # Populate new_day by combining day, month, and year
    execute <<-SQL
      UPDATE availabilties
      SET new_day = make_date(year, month, day)
    SQL

    # Remove old columns
    remove_column :availabilties, :day, :integer
    remove_column :availabilties, :month, :integer
    remove_column :availabilties, :year, :integer

    # Rename new_day to day
    rename_column :availabilties, :new_day, :day

    # Repeat the same steps for the 'cares' table
    add_column :cares, :new_day, :date

    execute <<-SQL
      UPDATE cares
      SET new_day = make_date(year, month, day)
    SQL

    remove_column :cares, :day, :integer
    remove_column :cares, :month, :integer
    remove_column :cares, :year, :integer

    rename_column :cares, :new_day, :day
  end
end
