class TasksController < ApplicationController

  def index
    @tasks = Task.order(:id)
  end

  def show
    @task = Task.find( params[:id].to_i)
  end

  def edit
    @task = Task.find_by(id: params[:id].to_i)

    unless @task
      redirect_to root_path
    end
  end

  def update
    task = Task.find_by(id: params[:id].to_i)
    redirect_to root_path unless task

    if task.update_attributes task_params
      redirect_to root_path
    else
      render :edit
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(name: params[:task][:name], description: params[:task][:description])
    if @task.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    Task.find_by(id: params[:id]).destroy
    redirect_to root_path
  end

  def mark_complete
    @task = Task.find_by(id: params[:id].to_i)

    if @task.completion_date == nil
      @task.completion_date = DateTime.now
      @task.save
      redirect_to root_path
    else
      @task.completion_date = nil
      @task.save
      redirect_to root_path
    end
  end

  private

  def task_params
    return params.require(:task).permit(:name, :description, :completion_date)
  end
end
