require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  let(:teacher_user) { create(:user, :for_teachers) }
  let(:student_user) { create(:user) }
  let(:course) { create(:course, teacher: teacher_user.accountable) }
  let!(:note) { create(:note, course: course) }

  describe 'GET index' do
    context 'when teacher tries to see all notes' do
      it 'render index' do
        sign_in teacher_user
        get :index, params: { course_id: course.id }
        expect(response).to render_template :index
      end
    end
    context 'when teacher tries to see all notes that are not uploaded by them' do
      it 'redirected to courses' do
        sign_in teacher_user
        get :index, params: { course_id: course.id + 1000 }
        expect(response).to redirect_to(courses_path)
      end
    end
    context 'when students tries to see notes of published notes' do
      it 'render index' do
        sign_in student_user
        course.students << student_user.accountable
        get :index, params: { course_id: course.id }
        expect(response).to render_template :index
      end
    end
    context 'when student tries to see notesa not published notes' do
      it 'redirect_to courses' do
        sign_in student_user
        note.published_at = nil
        note.save
        course.students << student_user.accountable
        get :index, params: { course_id: course.id }
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET show' do
    context 'when teacher tries to see a note' do
      it 'render show' do
        sign_in teacher_user
        get :show, params: { course_id: course.id, id: note.id }
        expect(response).to render_template :show
      end
    end
    context 'when teacher tries to see a note that is not uploaded by them' do
      it 'redirect to course notes path' do
        sign_in teacher_user
        get :show, params: { course_id: course.id + 100, id: note.id }
        expect(response).to redirect_to(course_notes_path(course_id: course.id + 100))
      end
    end
    context 'with invalid id' do
      it 'redirect to course notes path' do
        sign_in teacher_user
        get :show, params: { course_id: course.id, id: note.id + 100 }
        expect(response).to redirect_to(course_notes_path(course_id: course.id))
      end
    end
    context 'when student tries to see a note' do
      it 'throws 200 status code' do
        sign_in student_user
        course.students << student_user.accountable
        get :show, params: { course_id: course.id, id: note.id }
        expect(response).to render_template :show
      end
    end
    context 'when student tries to see a note that is not published' do
      it 'redirect to course notes path' do
        sign_in student_user
        note.published_at = nil
        note.save
        course.students << student_user.accountable
        get :show, params: { course_id: course.id + 100, id: note.id }
        expect(response).to redirect_to(course_notes_path(course_id: course.id + 100))
      end
    end
  end

  describe 'POST create' do
    context 'when teacher tries to create a note in a course he created' do
      it 'redirect to course' do
        sign_in teacher_user
        get :create,
             params: { note: { name: 'test', description: 'testing going on', published_at: '', course_id: course.id },course_id: course.id }
        expect(response).to redirect_to(course_path(id: course.id))
      end
    end
    context 'when teacher tries to create a note in a course he is not created' do
      it 'throws 401 status code' do
        sign_in teacher_user
        get :create,
             params: { note: { name: 'test', description: 'testing going on', published_at: '', course_id: course.id,
                               file: '' }, course_id: course.id + 100 }
        expect(response).to redirect_to(course_notes_path(course_id: course.id + 100))
      end
    end
    context 'when student tries to create a note' do
      it 'throws 401 status code' do
        sign_in student_user
        get :create,
             params: { note: { name: 'test', description: 'testing going on', published_at: '', course_id: course.id,
                               file: '' }, course_id: course.id + 100 }
        expect(response).to redirect_to(course_notes_path(course_id: course.id + 100))
      end
    end
  end

  describe "PATCH update" do
    context "when teacher tries to update a note that he has access" do
      it "redirect to course note path" do
        sign_in teacher_user
        get :update, params: { note: { name: 'test', description: 'testing going on', published_at: '', course_id: course.id }, course_id: course.id, id: note.id }
        expect(response).to redirect_to(course_notes_path(course_id: course.id))
      end
    end
    context 'when teacher tries to update a note that he does not have access' do
      it 'redirect to course note path' do
        sign_in teacher_user        
        get :update, params: { note: { name: 'test', description: 'testing going on', published_at: '', course_id: 1 }, course_id: 1, id: note.id }
        expect(response).to redirect_to(course_notes_path(course_id: 1))
      end
    end
    context 'when student tries to update a note' do
      it 'redirect to course note path' do
        sign_in student_user
        get :update, params: { note: { name: 'test', description: 'testing going on', published_at: '', course_id: course.id }, course_id: course.id, id: note.id }
        expect(response).to redirect_to(course_notes_path(course_id: course.id))
      end
    end
  end
  describe "DELETE destroy" do
    context "when teacher tries to delete a note that he has access" do
      it 'redirect to course note path' do
        sign_in teacher_user
        get :destroy, params: { course_id: course.id, id: note.id}
        expect(response).to redirect_to(course_notes_path(course_id: course.id))
      end
    end
    context 'when teacher tries to delete a note that he does not have access' do
      it 'redirect to course note path' do
        sign_in teacher_user
        get :destroy, params: { course_id: course.id, id: note.id}
        expect(response).to redirect_to(course_notes_path(course_id: course.id))
      end
    end
    context 'when the student tries to delete a note' do
      it 'redirect to course note path' do
        sign_in student_user
        get :destroy, params: { course_id: course.id, id: note.id}
        expect(response).to redirect_to(course_notes_path(course_id: course.id))
      end
    end
  end
  describe 'GET new' do
    context 'when teacher tries to create a note' do
      it 'render new' do
        sign_in teacher_user
        get :new, params: { course_id: course.id }
        expect(response).to render_template :new
      end
    end
  end
  describe 'GET edit' do
    context 'when teacher tries to edit a note that he has access' do
      it 'render edit' do
        sign_in teacher_user
        get :edit, params: { course_id: course.id, id: note.id }
        expect(response).to render_template :edit
      end
    end
  end
end
