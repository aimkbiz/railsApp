class CreateUserAccesses < ActiveRecord::Migration[5.2]
  def change
    create_table :user_accesses do |t|
      t.string :ip_address
      t.date :access_date
      t.integer :access_count
      t.timestamps
    end
  end
end
