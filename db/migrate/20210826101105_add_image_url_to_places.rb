class AddImageUrlToPlaces < ActiveRecord::Migration[6.0]
  def change
    add_column :places, :image_url, :string
  end
end
