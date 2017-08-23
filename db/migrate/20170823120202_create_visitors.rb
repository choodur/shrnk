class CreateVisitors < ActiveRecord::Migration[5.1]
  def change
    create_table :visitors do |t|
      t.string :ip
      t.string :browser
      t.string :browser_version
      t.string :os
      t.string :country
      t.string :city
      t.belongs_to :link
      t.timestamps
    end
  end
end
