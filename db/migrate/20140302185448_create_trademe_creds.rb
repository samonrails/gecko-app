class CreateTrademeCreds < ActiveRecord::Migration
  def change
    create_table :trademe_creds do |t|
      t.string :token
      t.string :token_secret
      t.references :user, index: true

      t.timestamps
    end
  end
end
