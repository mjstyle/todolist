class AddTasksTaskName < ActiveRecord::Migration
  def change
    add_column :tasks, :task_name, :text
  end
end
