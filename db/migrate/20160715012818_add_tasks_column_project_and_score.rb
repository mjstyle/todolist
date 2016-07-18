class AddTasksColumnProjectAndScore < ActiveRecord::Migration
  def change
    #icebox, assigned_icebox, process, done, reject, finished
    add_column :tasks, :status, :string, default: 'icebox'
    # oneclass, easyke, solvit
    add_column :tasks, :project, :string, default: 'oneclass'

    add_column :tasks, :score, :string

    add_index :tasks, :status
    add_index :tasks, :project
    add_index :tasks, :developer_id unless index_exists? :tasks, :developer_id

  end
end
