class Task < ActiveRecord::Base
  attr_accessible :developer_id, :developer_ids, :start_date, :weekday, :end_date, :status, :score, :task_name, :dev_name, :project, :position

  belongs_to :developer

  #statuses: icebox, assigned_icebox, process, done, reject, finished
  #projects: oneclass, easyke, solvit

  validates :task_name, presence: true
  before_create do
    self.position = Task.where(start_date: self.start_date).maximum('position').to_i + 1
    self.dev_name = self.developer.try(:name)
    begin
      self.weekday = self.start_date.to_time.strftime('%a')
    rescue
    end
  end
end
