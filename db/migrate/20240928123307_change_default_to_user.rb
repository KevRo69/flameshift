class ChangeDefaultToUser < ActiveRecord::Migration[7.1]
  def change
    change_column_null :users, :COD_1, false
    change_column_null :users, :CATE, false
    change_column_null :users, :CE_INC, false
    change_column_null :users, :EQ_INC, false
    change_column_null :users, :EQ_SAP, false
    change_column_null :users, :STG, false
    change_column_null :users, :validator, false
  end
end
