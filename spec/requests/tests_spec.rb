require 'rails_helper'

RSpec.describe 'Tests', type: :request do
  let(:teacher_user) { create(:user, :for_teachers) }
  let(:teacher_token) { create(:doorkeeper_access_token, resource_owner_id: teacher_user.id) }
  let(:student_user) { create(:user, :for_students) }
  let(:student_token) { create(:doorkeeper_access_token, resource_owner_id: student_user.id) }
  let(:course) { create(:course, teacher: teacher_user.accountable) }
  let!(:test) { create(:test, course: course) }
  let(:question) { create(:question, test: test) }
  let(:option) { create(:option, question: question) }
  describe 'GET index' do
    context 'when teacher tries to see all tests that he has access' do
      it 'throws 200 status code' do
        get "/api/courses/#{course.id}/test", params: { access_token: teacher_token.token }
        expect(response).to have_http_status(200)
      end
    end
    context 'when teacher tries to see all tests that he dont have access' do
      it 'throws 401 status code' do
        get "/api/courses/#{course.id + 100}/test", params: { access_token: teacher_token.token }
        expect(response).to have_http_status(401)
      end
    end
    context 'when student tries to see all tests that he has access' do
      it 'throws 200 status code' do
        course.students << student_user.accountable
        get "/api/courses/#{course.id}/test", params: { access_token: student_token.token }
        expect(response).to have_http_status(200)
      end
    end
    context 'when student tries to see all tests that he dont have access' do
      it 'throws 401 status code' do
        get "/api/courses/#{course.id}/test", params: { access_token: student_token.token }
        expect(response).to have_http_status(401)
      end
    end
  end
  describe 'GET show' do
    context 'when teacher tries to see a test' do
      it 'throws 200 status code' do
        get "/api/courses/#{course.id}/test/#{test.id}", params: { access_token: teacher_token.token }
        expect(response).to have_http_status(200)
      end
    end
    context 'when teacher tries to see a test that he dont have access' do
      it 'throws 401 status code' do
        get "/api/courses/#{course.id + 100}/test/#{test.id}", params: { access_token: teacher_token.token }
        expect(response).to have_http_status(401)
      end
    end
    context 'when the student to see a test that he access' do
      it 'throws 200 status code' do
        course.students << student_user.accountable
        get "/api/courses/#{course.id}/test/#{test.id}", params: { access_token: student_token.token }
        expect(response).to have_http_status(200)
      end
    end
    context 'when the student tries to see a test that he dont have access' do
      it 'throws 401 status code' do
        get "/api/courses/#{course.id}/test/#{test.id}", params: { access_token: student_token.token }
        expect(response).to have_http_status(401)
      end
    end
    context 'when the student tries to see a test that he dont have access' do
      it 'throws 401 status code' do
        get "/api/courses/#{course.id}/test/#{test.id + 100}", params: { access_token: student_token.token }
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST create' do
    context 'when teacher tries to create test' do
      it 'throws 200 status code' do
        post "/api/courses/#{course.id}/test",
             params: { access_token: teacher_token.token, test: { name: 'testing', course_id: course.id, attempts: 5 } }
        expect(response).to have_http_status(201)
      end
    end
    context 'when teacher tries to create test that he dont have access' do
      it 'throws 401 status code' do
        post "/api/courses/#{course.id + 100}/test",
             params: { access_token: teacher_token.token, test: { name: 'testing', course_id: course.id + 100 } }
        expect(response).to have_http_status(422)
      end
    end
    context 'when student tries to create test' do
      it 'throws 401 status code' do
        post "/api/courses/#{course.id}/test",
             params: { access_token: student_token.token, test: { name: 'testing', course_id: course.id } }
        expect(response).to have_http_status(401)
      end
    end
    context "with invalid params" do
      it "throws 422 status code" do
        post "/api/courses/#{course.id}/test",
             params: { access_token: teacher_token.token, test: { name: '' } }
        expect(response).to have_http_status(422)
      end
    end
  end
  describe 'DELETE destroy' do
    context 'when teacher tries to delete test' do
      it 'throws 200 status code' do
        delete "/api/courses/#{course.id}/test/#{test.id}", params: { access_token: teacher_token.token }
        expect(response).to have_http_status(200)
      end
    end
    context 'when teacher tries to delete test that he dont have access' do
      it 'throws 401 status code' do
        delete "/api/courses/#{course.id + 100}/test/#{test.id}", params: { access_token: teacher_token.token }
        expect(response).to have_http_status(401)
      end
    end
    context 'when student tries to delete test' do
      it 'throws 401 status code' do
        delete "/api/courses/#{course.id}/test/#{test.id}", params: { access_token: student_token.token }
        expect(response).to have_http_status(401)
      end
    end
    context 'with invalid id' do
      it 'throws 404 status code' do
        delete "/api/courses/#{course.id}/test/#{test.id + 100}", params: { access_token: teacher_token.token }
        expect(response).to have_http_status(404)
      end
    end
  end
end
