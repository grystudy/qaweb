class ModForeignKey < ActiveRecord::Migration[5.0]
  def change
    # remove the old foreign_key
    remove_foreign_key :wz_items, :wz_cases
    remove_foreign_key :wz_queries, :wz_cases

    # add the new foreign_key
    add_foreign_key :wz_items, :wz_cases, on_delete: :cascade
    add_foreign_key :wz_queries, :wz_cases, on_delete: :cascade
  end
end