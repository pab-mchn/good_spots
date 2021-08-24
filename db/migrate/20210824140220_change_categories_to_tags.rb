class ChangeCategoriesToTags < ActiveRecord::Migration[6.0]
  def change
    rename_table :categories, :tags
  end
end
