class AddTasksIndexStartDate < ActiveRecord::Migration
  def change
    add_index :tasks, :start_date
  end
end
