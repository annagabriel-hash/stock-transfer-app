class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :name
      t.index :name, unique: true
      t.timestamps null: false
    end
  end
end
