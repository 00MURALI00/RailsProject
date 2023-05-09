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
      # debugger
      @notes.each do |note|
        @notes.delete(note) if note.published_at.nil?
      end
    else
      render json: { error: 'Authorization restricted' }, status: 403
      return
    end
    # debugger
    if @notes.length != 0
      render json: @notes, status: :ok
    else
      render json: { message: 'No Notes Found' }, status: 403
    end
  end

  def create
    if current_user.role == 'teacher' && current_user.accountable.course_ids.include?(params[:course_id].to_i)
      @note = Note.new(note_params)
      # debugger
      if @note.save
        @note.file.attach = params[:note][:file]
        render json: @note, status: :created
      else
        render json: { error: @note.errors }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Authorization restricted' }, status: 403
    end
  end

  def show
    if current_user.role == 'teacher'
      if current_user.accountable.course_ids.include?(params[:course_id].to_i)
        @note = Note.find_by(id: params[:id])
        if !@note.nil?
          render json: @note, status: :ok
          return
        else
          render json: { message: 'Not Found' }, status: 403
          return
        end
      else
        render json: { error: 'Authorization restricted' }, status: 403
        return
      end
    end
    # debugger
    @note = Note.find_by(id: params[:id])
    if !@note.nil? && !@note.published_at.nil? && current_user.accountable.courses.include?(@note.course)
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
      # debugger
      if !@note.nil? && current_user.accountable.course_ids.include?(params[:course_id].to_i)
        # debugger
        if @note.update(note_params)
          unless params[:note][:file].nil?
            @note.file.attach = params[:note][:file]
          end
          render json: { message: 'Updated Successfully' }, status: :accepted
        else
          render json: { error: @note.errors.full_message }, status: :unprocessable_entity
        end
      else
        render json: { message: 'Not Found' }, status: :not_found
      end
    else
      render json: { error: 'Authorization restricted' }, status: 403
    end
  end

  def destroy
    if current_user.role == 'teacher'
      @note = Note.find_by(id: params[:id])
      if !@note.nil? && current_user.accountable.course_ids.include?(params[:course_id].to_i)
        if @note.destroy
          render json: { message: 'Destroyed Successfully' }, status: :ok
        else
          render json: { error: @note.errors }, status: :unprocessable_entity
        end
      else
        render json: { message: 'Not Found' }, status: :not_found
      end
    else
      render json: { error: 'Authorization restricted' }, status: 403
    end
  end

  def note_params
    params.require(:note).permit(:name, :description, :course_id)
  end
end
