require 'rails_helper'

RSpec.describe 'Questions', type: :request do
  let(:teacher_user) { create(:user, :for_teachers) }
  let(:teacher_token) { create(:doorkeeper_access_token, resource_owner_id: teacher_user.id) }
  let(:student_user) { create(:user, :for_students) }
  let(:student_token) { create(:doorkeeper_access_token, resource_owner_id: student_user.id) }
  let(:course) { create(:course, teacher: teacher_user.accountable) }
  let!(:test) { create(:test, course: course) }
  let(:question) { create(:question, test: test) }
  let(:option) { create(:option, question: question) }
  let(:answer) { create(:answer, question: question) }
  describe 'GET index' do
    context 'when teacher tries to see all questions' do
      it 'throws 200 status code' do
        get "/api/courses/#{course.id}/test/#{test.id}/question", params: { access_token: teacher_token.token }
        expect(response).to have_http_status(200)
      end
    end
    context 'when students tries to see all questions' do
      it 'throws 200 status code' do
        course.students << student_user.accountable
        get "/api/courses/#{course.id}/test/#{test.id}/question", params: { access_token: student_token.token }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET show' do
    context 'when teacher tries to see a testresult' do
      it 'throws 200 status code' do
        get "/api/courses/#{course.id}/test/#{test.id}/question/#{question.id}",
            params: { access_token: teacher_token.token }
        expect(response).to have_http_status(200)
      end
    end
    context 'when student tries to see a testresult' do
      it 'throws 200 status code' do
        course.students << student_user.accountable
        get "/api/courses/#{course.id}/test/#{test.id}/question/#{question.id}",
            params: { access_token: student_token.token }
        expect(response).to have_http_status(200)
      end
    end
  end
  describe 'POST create' do
    context 'when teacher tries to create question he has access to course' do
      it 'throws 201 status code' do
        post "/api/courses/#{course.id}/test/#{test.id}/question",
             params: { access_token: teacher_token.token,
                       question: { question: 'testing testing testing', test_id: test.id,
                                   option: { opt1: 'test', opt2: 'test', opt3: 'test', opt4: 'test' }, answer: { answer: 'passed' } } }
        expect(response).to have_http_status(201)
      end
    end
    context 'when teacher tries to create question he has not access to course' do
      it 'thows 401 status code' do
        post "/api/courses/#{course.id + 100}/test/#{test.id}/question",
             params: { access_token: teacher_token.token,
                       question: { question: 'testing testing testing', test_id: test.id,
                                   option: { opt1: 'test', opt2: 'test', opt3: 'test', opt4: 'test' }, answer: { answer: 'passed' } } }
        expect(response).to have_http_status(401)
      end
    end
    context 'when student tries to create question' do
      it 'thows 401 status code' do
        post "/api/courses/#{course.id + 100}/test/#{test.id}/question",
             params: { access_token: student_token.token,
                       question: { question: 'testing testing testing', test_id: test.id,
                                   option: { opt1: 'test', opt2: 'test', opt3: 'test', opt4: 'test' }, answer: { answer: 'passed' } } }
        expect(response).to have_http_status(401)
      end
    end
  end
  describe 'DELETE destroy' do
    context 'when teacher tries to delete a question that he has access to course' do
      it 'throws 200 status code' do
        delete "/api/courses/#{course.id}/test/#{test.id}/question/#{question.id}",
               params: { access_token: teacher_token.token }
        expect(response).to have_http_status(200)
      end
    end
    context 'when teacher tries to delete a question that he dont have access' do
      it 'throws 401 status code' do
        delete "/api/courses/#{course.id + 100}/test/#{test.id}/question/#{question.id}",
               params: { access_token: teacher_token.token }
        expect(response).to have_http_status(401)
      end
    end
    context 'when student tries to delete a question' do
      it 'throws 401 status code' do
        delete "/api/courses/#{course.id + 100}/test/#{test.id}/question/#{question.id}",
               params: { access_token: student_token.token }
        expect(response).to have_http_status(401)
      end
    end
  end
end
