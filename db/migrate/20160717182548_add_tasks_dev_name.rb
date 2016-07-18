class AddTasksDevName < ActiveRecord::Migration
  def change
    add_column :tasks, :dev_name, :string
  end
end
