class AddIpAddressToChats < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :ip_addres, :string
  end
end
