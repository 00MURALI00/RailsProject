require 'rails_helper'

RSpec.describe TestresultController, type: :controller do
  let(:teacher_user) { create(:user, :for_teachers) }
  let(:student_user) { create(:user, :for_students) }
  let(:course) { create(:course, teacher: teacher_user.accountable) }
  let!(:test) { create(:test, course: course) }
  let(:question) { create(:question, test: test) }
  let(:option) { create(:option, question: question) }
  let(:testresult) { create(:testresult, test: test, student_id: student_user.accountable.id) }
  describe "GET /testresults" do
    context 'When teacher tries to see all testresults' do
      it 'render index' do
        sign_in teacher_user
        get :index
        expect(response).to render_template :index
      end
    end
    context 'When students tries to see testresults' do
      it 'throws 200 status code' do
        sign_in student_user
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe 'DELETE destory' do
    context 'when teacher tries to delete a testresult' do
      it 'throws 200 status code' do
        sign_in teacher_user
        get :destroy, params: { testresult_id: testresult.id}
        expect(response).to redirect_to(testresult_index_path)
      end
    end
    context 'when student tries to delete a testresult' do
      it 'throws 401 status code' do
        sign_in student_user
        get :destroy, params: { testresult_id: testresult.id}
        expect(response).to redirect_to(testresult_index_path)
      end
    end
  end
end
