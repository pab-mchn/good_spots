class RemoveCategoryFromPlaces < ActiveRecord::Migration[6.0]
  def change
    remove_reference :places, :category, null: false, foreign_key: true
  end
end
