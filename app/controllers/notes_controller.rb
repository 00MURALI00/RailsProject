class NotesController < ApplicationController
  def index
    @notes = Note.all.where(course_id: params[:course_id])
  end

  def new 
    @note = Note.new
  end

  def create
    @note = Note.new(note_params)
    if @note.save
      flash[:notice] = 'Successfully Added the Notes'
      redirect_to course_path(id: params[:course_id])
    else
      flash[:notice] = 'Failed to Add Notes'
      redirect_to new_course_note_path
    end
  end

  def show
    @note = Note.find(params[:id])
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.find(params[:id])
    # p @note
    if @note.update(note_params)
      @note.file.attach(params[:note][:file]) 
      flash[:notice] = 'Successfully Updated the Notes'
      redirect_to course_notes_path
    else
      flash[:notice] = 'Failed to update the Notes'
      redirect_to edit_course_note_path
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
