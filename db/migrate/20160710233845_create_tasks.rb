class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :developer_id
      t.string :developer_ids
      t.datetime :start_date
      t.string :weekday

      t.timestamps
    end
  end
end
