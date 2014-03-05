class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :email
      t.string :company_type
      t.string :ref_id

      t.timestamps
    end
  end
end
