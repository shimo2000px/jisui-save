class AddShareUidToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :share_uid, :string
    add_index :users, :share_uid
  end
end
