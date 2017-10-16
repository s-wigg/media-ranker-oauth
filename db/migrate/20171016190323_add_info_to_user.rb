class AddInfoToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :email, :string
    add_column :users, :uid, :string, null: false
    add_column :users, :provider, :string, null: false
  end
end
