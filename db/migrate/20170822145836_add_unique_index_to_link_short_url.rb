class AddUniqueIndexToLinkShortUrl < ActiveRecord::Migration[5.1]
  def up
    remove_index :links, :short_url
    add_index :links, :short_url, unique: true
    change_column :links, :original_url, :text
  end

  def down
    change_column :links, :original_url, :string
    remove_index :links, :short_url
    add_index :links, :short_url
  end
end
