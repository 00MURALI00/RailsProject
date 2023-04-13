# frozen_string_literal: true

class Api::NotesController < Api::ApiController
  protect_from_forgery with: :null_session
  before_action :doorkeeper_authorize!
  def index
    # @notes = Note.all
    if current_user.role == 'teacher' && current_user.accountable.course_ids.include?(params[:course_id].to_i)
      @notes = Note.all.where(course_id: params[:course_id])
    elsif current_user.accountable.course_ids.include?(params[:course_id].to_i)
      @notes = Note.all.where(course_id: params[:course_id]).where.not(published_at: nil)
    else
      render json: { error: 'Authorization restricted' }, status: :unauthorized
      return
    end
    render json: @notes, status: :ok
  end

  def create
    if current_user.role == 'teacher'
      @note = Note.new(name: params[:note][:name], description: params[:note][:description],
                      course_id: params[:note][:course_id])
      if @note.save
        render json: @note, status: :created
      else
        render json: { error: @note.errors.full_message }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Authorization restricted' }, status: :unauthorized
    end
  end

  def show
    @note = Note.find_by(id: params[:id], published_at: 'not nil')
    if !@note.nil? && current_user.accountable.courses.include?(@note.course)
      render json: @note, status: :ok
    else
      render json: { message: 'Not Found' }, status: :not_found
    end
  end

  # def edit
  #   @note = Note.find(params[:id])
  # end

  def update
    if current_user.role == 'teacher'
      @note = Note.find_by(id: params[:id])
      if !@note.nil? && current_user.accountable.courses.include?(@note.course)
        if @note.update(note_params)
          @note.file.attach(params[:note][:file])
          render json: { message: 'Updated Successfully' }, status: :accepted
        else
          render json: { error: @note.errors.full_message }, status: :unprocessable_entity
        end
      else
        render json: { message: 'Not Found' }, status: :not_found
      end
    else
      render json: { error: 'Authorization restricted' }, status: :unauthorized
    end
  end

  def destroy
    if current_user.role == 'teacher'
      @note = Note.find_by(id: params[:id])
      if !@note.nil? && current_user.accountable.course_ids.include?(params[:course_id].to_i)
        if @note.destroy
          render json: { message: 'Destroyed Successfully' }, status: :ok
        else
          render json: { error: @note.errors.full_message }, status: :unprocessable_entity
        end
      else
        render json: { message: 'Not Found' }, status: :not_found
      end
    else
      render json: { error: 'Authorization restricted' }, status: :unauthorized
    end
  end

  def note_params
    params.require(:note).permit(:name, :description, :course_id, :file)
  end
end
