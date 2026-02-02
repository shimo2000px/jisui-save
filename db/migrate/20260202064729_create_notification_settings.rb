class CreateNotificationSettings < ActiveRecord::Migration[7.2]
  def change
    create_table :notification_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :enabled, default: false, null: false
      t.time :send_time
      t.boolean :mon, default: false, null: false
      t.boolean :tue, default: false, null: false
      t.boolean :wed, default: false, null: false
      t.boolean :thu, default: false, null: false
      t.boolean :fri, default: false, null: false
      t.boolean :sat, default: false, null: false
      t.boolean :sun, default: false, null: false

      t.timestamps
    end
  end
end
