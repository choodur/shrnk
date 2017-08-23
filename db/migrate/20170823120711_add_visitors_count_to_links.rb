class AddVisitorsCountToLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :links, :visitors_count, :integer, default: 0
  end
end
