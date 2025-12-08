class CreateMissions < ActiveRecord::Migration[7.2]
  def change
    create_table :missions do |t|
      t.string :title, null: false
      t.text :description
      t.boolean :completed, default: false, null: false
      t.datetime :due_date
      t.integer :priority, default: 0, null: false
      t.string :category
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :missions, :completed
    add_index :missions, :priority
    add_index :missions, :due_date
    add_index :missions, :category
  end
end
