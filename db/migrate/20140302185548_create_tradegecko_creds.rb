class CreateTradegeckoCreds < ActiveRecord::Migration
  def change
    create_table :tradegecko_creds do |t|
      t.string :access_token
      t.string :refresh_token
      t.string :expires_at
      t.references :user, index: true

      t.timestamps
    end
  end
end
