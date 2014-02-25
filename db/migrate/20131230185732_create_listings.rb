class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :order

      t.timestamps
    end
  end
end
