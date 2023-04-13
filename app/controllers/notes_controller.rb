class NotesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @notes = if current_user.role == 'teacher' && current_user.accountable.course_ids.include?(params[:course_id].to_i)
               @notes = Note.all.where(course_id: params[:course_id])
             elsif current_user.accountable.course_ids.include?(params[:course_id].to_i)
               @notes = Note.all.where(course_id: params[:course_id]).where.not(published_at: nil)
             else
               redirect_to courses_path, notice: 'You are not authorized to view this page'
               return
             end
  end

  def new
    if current_user.role == 'teacher'
      @note = Note.new
    else
      flash[:notice] = 'You are not authorized to view this page'
      redirect_to course_notes_path
    end
  end

  def create
    if current_user.role == 'teacher'
      @note = Note.new(note_params)
      if @note.save
        flash[:notice] = 'Successfully Added the Notes'
        redirect_to course_path(id: params[:course_id])
      else
        flash[:notice] = 'Failed to Add Notes'
        render :new, status: :unprocessable_entity
      end
    else
      flash[:notice] = 'You are not authorized to view this page'
      redirect_to course_notes_path
      return
    end
  end

  def show
    @note = Note.find_by(id: params[:id], published_at: 'not nil')
    if !current_user.accountable.course_ids.include?(params[:course_id].to_i)
      flash[:notice] = 'You are not authorized to view this page'
      redirect_to course_notes_path
    end
    if @note.nil? 
      flash[:notice] = 'Not Found'
      redirect_to course_notes_path
    end
  end

  def edit
    @note = Note.find(params[:id])
    if !current_user.accountable.course_ids.include?(params[:course_id].to_i)
      flash[:notice] = 'You are not authorized to view this page'
      redirect_to course_notes_path
    end
  end

  def update
    @note = Note.find(params[:id])
    # p @note
    if !current_user.accountable.course_ids.include?(params[:course_id].to_i)
      flash[:notice] = 'You are not authorized to view this page'
      redirect_to course_notes_path
    end
    if !current_user.accountable.course_ids.include?(params[:course_id].to_i)
      flash[:notice] = 'You are not authorized to view this page'
      redirect_to course_notes_path
    end
    if @note.update(note_params)
      @note.file.attach(params[:note][:file])
      flash[:notice] = 'Successfully Updated the Notes'
      redirect_to course_notes_path
    else
      flash[:notice] = 'Failed to update the Notes'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @note = Note.find(params[:id])
    p @note
    if @note.destroy
      flash[:notice] = 'Successfully deleted the Notes'
      redirect_to course_notes_path
    else
      flash[:notice] = 'Failed to deleted the Notes'
      redirect_to course_note_path
    end
  end

  def note_params
    params.require(:note).permit(:name, :description, :course_id, :file)
  end
end
