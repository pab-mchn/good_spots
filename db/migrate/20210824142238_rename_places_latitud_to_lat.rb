class RenamePlacesLatitudToLat < ActiveRecord::Migration[6.0]
  def change
    rename_column :places, :latitude, :lat
  end
end
