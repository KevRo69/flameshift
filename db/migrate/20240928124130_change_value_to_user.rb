class ChangeValueToUser < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :COD_1, false
    change_column_default :users, :CATE, false
    change_column_default :users, :CE_INC, false
    change_column_default :users, :EQ_INC, false
    change_column_default :users, :EQ_SAP, false
    change_column_default :users, :STG, false
    change_column_default :users, :validator, false
  end
end
