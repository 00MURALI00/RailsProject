# frozen_string_literal: true

class Api::NotesController < ApplicationController
  protect_from_forgery with: :null_session
  def index
    @notes = Note.all
    # @notes = if current_user.role == 'teacher'
    #            Note.all.where(course_id: params[:course_id])
    #          else
    #            Note.all.where(course_id: params[:course_id]).where.not(published_at: nil)
    #          end
    render json: @notes
  end

  def create
    @note = Note.new(name: params[:note][:name], description: params[:note][:description],
                     course_id: params[:note][:course_id])
    if @note.save
      render json: @note
    else
      render json: @note.errors
    end
  end

  def show
    @note = Note.find_by(id: params[:id])
    if !@note.nil?
      render json: @note
    else
      render json: 'Record Not Found'
    end
  end

  # def edit
  #   @note = Note.find(params[:id])
  # end

  def update
    @note = Note.find_by(id: params[:id])
    if !@note.nil?
      if @note.update(note_params)
        @note.file.attach(params[:note][:file])
        render json: @note
      else
        render json: 'Something went wrong'
      end
    else
      render json: 'Something went wrong'
    end
  end

  def destroy
    @note = Note.find_by(id: params[:id])
    if !note.nil?
      if @note.destroy
        render json: @note
      else
        render json: 'Something went wrong'
      end
    else
      render json: 'Something went wrong'
    end
  end

  def note_params
    params.require(:note).permit(:name, :description, :course_id, :file)
  end
end
