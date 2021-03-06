class TasksController < ApplicationController
  def create
    tasks_pars  = params[:task]
    task        = Task.new tasks_pars
    success     = if task.save
                    true
                  else
                    false
                    @errors = task.errors
                  end
    redirect_to '/'
  end

  def update
  end

  def get_tasks
    dev_id      = params[:developer_id]
    project     = params[:project]
    start_date  = params[:start_date]
    end_date    = params[:end_date]
    not_finished= params[:not_finished]
    conditions  = ""
    if dev_id.present?
      conditions += "developer_id = '#{dev_id}' "
    end
    if project.present?
      and_w       = conditions.present? ? ' AND ' : ''
      conditions += "#{and_w}project = '#{project}' "
    end

    if start_date.present?
      and_w       = conditions.present? ? ' AND ' : ''
      conditions += "#{and_w}start_date = '#{start_date} 00:00:00' "
    end

    if end_date.present?
      and_w       = conditions.present? ? ' AND ' : ''
      conditions += "#{and_w}start_date = '#{end_date} 00:00:00' "
    end

    if not_finished.present?
      and_w       = conditions.present? ? ' AND ' : ''
      conditions += "#{and_w}status != 'finished' "
    end

    tomorrow          = "#{Time.now.tomorrow.search_date} 00:00:00"
    today             = "#{Time.now.search_date} 00:00:00"

    @this_week        = Time.now.beginning_of_week
    @begin_task       = @this_week - 3.days
    @end_task         = @this_week + 3.days
    blank_conditions, blank_todays, blank_tomorrows  = unless start_date.present? && end_date.present?
                          [
                              "start_date >= '#{@begin_task.search_date} 00:00:00' AND start_date <= '#{@end_task.search_date} 00:00:00' AND start_date != '#{today}' AND start_date != '#{tomorrow}'",
                              "start_date = '#{today}'",
                              "start_date = '#{tomorrow}'",
                          ]
                        else
                          ''
                        end
    @todays_tasks     = Task.where("developer_id != '0'").where(conditions).where(blank_todays).select('id,dev_name,developer_id, start_date, end_date, status, score, task_name, position,project').order('start_date,position ASC')
    @tomorrows_tasks  = Task.where("developer_id != '0'").where(conditions).where(blank_tomorrows).select('id,dev_name,developer_id, start_date, end_date, status, score, task_name, position,project').order('start_date,position ASC')
    @tasks            = Task.where("developer_id != '0'").where(conditions).where(blank_conditions).select('id,dev_name,developer_id, start_date, end_date, status, score, task_name, position,project').order('start_date,position ASC')
    @generals         = Task.where(developer_id: 0)
    render json: { tasks: @tasks, todays: @todays_tasks, tomorrows: @tomorrows_tasks, generals: @generals }
  end

  def update_task_text
    id        = params[:id].to_i
    task_name = params[:task_name]
    task      = Task.where(id: id).first
    if task
      task.update_column :task_name, task_name
    end

    render json: { new_text: task_name }
  end

  def remove_task
    id        = params[:id].to_i
    task      = Task.where(id: id).first
    if task
      task.destroy
    end
    render json: { success: true}
  end

  def update_task
    sd        = params[:start_date]
    today_ids = params[:today_ids]
    today_ids = today_ids.collect{|t| t.to_i}
    id        = params[:id].to_i


    @task   = Task.where(id: id).first
    if @task
      Task.find_all_by_id(today_ids).sort_by {|t| today_ids.index(t.id) }.each_with_index{|t,i| t.update_column :position, i}
      @task.update_attributes start_date: sd
    end

    render json: { success: true }
  end

  def update_task_done
    status  = params[:checked] == 'true' ? 'finished' : 'icebox'
    id      = params[:id].to_i
    @task   = Task.where(id: id).first
    @task.update_column :status, status
    render json: { success: true }
  end

  def delete
  end

end