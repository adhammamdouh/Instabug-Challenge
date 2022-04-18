class CreateApps < ActiveRecord::Migration[5.1]
  def change
    create_table :apps do |t|
      t.string :token
      t.string :name
      t.integer :chatCount

      t.timestamps
    end
    add_index :apps, :token, unique: true
  end
end
