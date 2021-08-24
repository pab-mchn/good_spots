class AddRecommendedToPlaces < ActiveRecord::Migration[6.0]
  def change
    add_column :places, :recommended, :boolean
  end
end
