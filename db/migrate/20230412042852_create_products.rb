class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :title
      t.string :description
      t.string :image
      t.string :category
      t.float :price

      t.timestamps
    end
  end
end
