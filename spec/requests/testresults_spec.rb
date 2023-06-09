require 'rails_helper'

RSpec.describe "Testresults", type: :request do
  let(:teacher_user) { create(:user, :for_teachers) }
  let(:teacher_token) { create(:doorkeeper_access_token, resource_owner_id: teacher_user.id) }
  let(:student_user) { create(:user, :for_students) }
  let(:student_token) { create(:doorkeeper_access_token, resource_owner_id: student_user.id) }
  let(:course) { create(:course, teacher: teacher_user.accountable) }
  let!(:test) { create(:test, course: course) }
  let(:question) { create(:question, test: test) }
  let(:option) { create(:option, question: question) }
  let(:testresult) { create(:testresult, test: test, student_id: student_user.accountable.id) }
  describe "GET /testresults" do
    context 'When teacher tries to see all testresults' do
      it 'throws 200 status code' do
        get "/api/courses/#{course.id}/test/#{test.id}/testresult", params: { access_token: teacher_token.token }
        expect(response).to have_http_status(200)
      end
    end
    context 'When students tries to see testresults' do
      it 'throws 200 status code' do
        get "/api/courses/#{course.id}/test/#{test.id}/testresult", params: { access_token: teacher_token.token }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'DELETE destory' do
    context 'when teacher tries to delete a testresult' do
      it 'throws 200 status code' do
        delete "/api/courses/#{course.id}/test/#{test.id}/testresult/#{testresult.id}", params: { access_token: teacher_token.token }
        expect(response).to have_http_status(200)
      end
    end
    context 'when student tries to delete a testresult' do
      it 'throws 401 status code' do
        delete "/api/courses/#{course.id}/test/#{test.id}/testresult/#{testresult.id}", params: { access_token: student_token.token }
        expect(response).to have_http_status(401)
      end
    end
  end
end
