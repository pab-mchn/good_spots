class CreatePlaces < ActiveRecord::Migration[6.0]
  def change
    create_table :places do |t|
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
      t.text :description
      t.string :telephone_number
      t.string :website_url
      t.string :email
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
