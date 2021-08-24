class RenamePlacesLongitudToLng < ActiveRecord::Migration[6.0]
  def change
    rename_column :places, :longitude, :lng
  end
end
