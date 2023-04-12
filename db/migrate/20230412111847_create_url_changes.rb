class CreateUrlChanges < ActiveRecord::Migration[7.0]
  def change
    create_table :url_changes do |t|
      t.string :url
      t.text :content

      t.timestamps
    end
  end
end
