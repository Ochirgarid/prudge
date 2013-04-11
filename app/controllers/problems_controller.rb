# -*- coding: utf-8 -*-
class ProblemsController < ApplicationController
  menu :problem

  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html do
        order = params[:order] || 'DESC'
        column = params[:column] || 'created_at'
        @reverse = (order == 'ASC') ? 'DESC' : 'ASC'

        @problems = @problems.
          paginate(:page => params[:page], :per_page => 20, :include => :user, 
                   :order => "#{column} #{order}")
      end
      format.rss do
        @problems = @problems.all(:order => 'created_at DESC',
                                  :include => :user, :limit => 10)
        render :layout => false
      end
    end
  end

  def proposals
  end

  def show
  end

  def new
    @problem = Problem.new
  end

  def create
    @problem = current_user.problems.build(sanitized_params)
    if @problem.save
      flash[:notice] = 'Бодлогыг хадгалав. Тэстүүдийг нь оруулна уу?'
      redirect_to @problem
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    params[:problem].delete('contest_id') unless judge?
    if @problem.update_attributes(sanitized_params)
      flash[:notice] = 'Бодлогыг шинэчиллээ.'
      redirect_to @problem
    else
      render :action => 'edit'
    end
  end

  def destroy
    raise if @problem.solutions.count > 0
    @problem.destroy
    redirect_to :action => :index
  end

  def check
    @problem.check!
    flash[:notice] = "Бүх бодолтуудыг шалгалаа"
    redirect_to @problem
  end

  private
  def sanitized_params
    params[:problem].tap do |sanitized|
      sanitized.delete('contest_id') unless judge?
    end
  end

end
