require 'rails_helper'

RSpec.describe QuestionController, type: :controller do
  let(:teacher_user) { create(:user, :for_teachers) }
  let(:student_user) { create(:user, :for_students) }
  let(:course) { create(:course, teacher: teacher_user.accountable) }
  let!(:test) { create(:test, course: course) }
  let(:question) { create(:question, test: test) }
  let(:option) { create(:option, question: question) }
  let(:answer) { create(:answer, question: question) }
  describe 'GET index' do
    context 'when teacher tries to see all questions' do
      it 'render index' do
        sign_in teacher_user
        get :index, params: { course_id: course.id, test_id: test.id }
        expect(response).to render_template :index
      end
    end
    context 'when students tries to see all questions' do
      it 'throws 200 status code' do
        sign_in student_user
        course.students << student_user.accountable
        get :index, params: { course_id: course.id, test_id: test.id }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET show' do
    context 'when teacher tries to see a testresult' do
      it 'throws 200 status code' do
        sign_in teacher_user
        get :show, params: { course_id: course.id, test_id: test.id, id: question.id }
        expect(response).to have_http_status(200)
      end
    end
    context 'when student tries to see a testresult' do
      it 'throws 200 status code' do
        sign_in student_user
        course.students << student_user.accountable
        get :show, params: { course_id: course.id, test_id: test.id, id: question.id }
        expect(response).to have_http_status(200)
      end
    end
  end
  describe 'POST create' do
    context 'when teacher tries to create question he has access to course' do
      it 'throws 201 status code' do
        sign_in teacher_user
        get :create,
            params: { question: { question: 'testing testing testing', test_id: test.id,
                                  option: { opt1: 'test', opt2: 'test', opt3: 'test', opt4: 'test' }, answer: { answer: 'passed' } }, course_id: course.id, test_id: test.id }
        expect(response).to redirect_to(course_test_question_index_path)
      end
    end
    context 'when teacher tries to create question he has not access to course' do
      it 'thows 401 status code' do
        sign_in teacher_user
        get :create,
            params: { question: { question: 'testing testing testing', test_id: test.id,
                                  option: { opt1: 'test', opt2: 'test', opt3: 'test', opt4: 'test' }, answer: { answer: 'passed' } }, course_id: course.id + 100, test_id: test.id  }
        expect(response).to redirect_to(root_path)
      end
    end
    context 'when student tries to create question' do
      it 'thows 401 status code' do
        sign_in student_user
        get :create,
             params: { question: { question: 'testing testing testing', test_id: test.id,
                                   option: { opt1: 'test', opt2: 'test', opt3: 'test', opt4: 'test' }, answer: { answer: 'passed' } }, course_id: course.id, test_id: test.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end
  describe 'DELETE destroy' do
    context 'when teacher tries to delete a question that he has access to course' do
      it 'throws 200 status code' do
        sign_in teacher_user
        get :destroy, params: { course_id: course.id, test_id: test.id, id: question.id }
        expect(response).to redirect_to(course_test_question_index_path)
      end
    end
    context 'when student tries to delete a question' do
      it 'throws 401 status code' do
        sign_in student_user
        get :destroy, params: { course_id: course.id, test_id: test.id, id: question.id }
        expect(flash[:notice]).to eq('Failed to delete question')
      end
    end
  end
  describe 'GET new' do
    context 'when teacher create a new questions' do
      it 'render new' do
        sign_in teacher_user
        get :new, params: { course_id: course.id, test_id: test.id }
        expect(response).to render_template :new
      end
    end
  end
  describe 'GET edit' do
    context 'when teacher tries to edit a question that he has access' do
      it 'render edit' do
        sign_in teacher_user
        get :edit, params: { course_id: course.id, test_id: test.id, id: question.id }
        expect(response).to render_template :edit
      end
    end
  end
end
