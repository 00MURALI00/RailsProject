require 'rails_helper'

RSpec.describe Api::NotesController do
  let(:teacher_user) { create(:user, :for_teachers) }
  let(:teacher_token) { create(:doorkeeper_access_token, resource_owner_id: teacher_user.id) }
  let(:student_user) { create(:user, :for_students) }
  let(:student_token) { create(:doorkeeper_access_token, resource_owner_id: student_user.id) }
  let(:course) { create(:course, teacher: teacher_user.accountable) }
  let!(:note) { create(:note, course: course) }

  describe 'GET index' do
    context 'when teacher tries to see all notes' do
      it 'throws 200 status code' do
        get "/api/courses/#{course.id}/notes", params: { access_token: teacher_token.token, course_id: course.id }
        expect(response).to have_http_status(200)
      end
    end
    context 'when teacher tries to see all notes that are not uploaded by them' do
      it 'throws 401 status code' do
        get "/api/courses/#{course.id + 1000}/notes",
            params: { access_token: teacher_token.token, course_id: course.id + 1000 }
        expect(response).to have_http_status(401)
      end
    end
    context 'when students tries to see notes of published notes' do
      it 'throws 200 status code' do
        # p note.published_at
        course.students << student_user.accountable

        get "/api/courses/#{course.id}/notes", params: { access_token: student_token.token, course_id: course.id }
        expect(response).to have_http_status(200)
      end
    end
    context 'when student tries to see notesa not published notes' do
      it 'throws 401 status code' do
        note.published_at = nil
        note.save
        course.students << student_user.accountable
        get "/api/courses/#{course.id}/notes", params: { access_token: student_token.token, course_id: course.id }
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET show' do
    context 'when teacher tries to see a note' do
      it 'throws 200 status code' do
        get "/api/courses/#{course.id}/notes/#{note.id}", params: { access_token: teacher_token.token }
        expect(response).to have_http_status(200)
      end
    end
    context 'when teacher tries to see a note that is not uploaded by them' do
      it 'throws 401 status code' do
        get "/api/courses/#{course.id}/notes/#{note.id + 1000}", params: { access_token: teacher_token.token }
        expect(response).to have_http_status(401)
      end
    end
    context 'with invalid id' do
      it 'throws 404 status code' do
        get "/api/courses/#{course.id}/notes/1000", params: { access_token: teacher_token.token }
        expect(response).to have_http_status(401)
      end
    end
    context 'when student tries to see a note' do
      it 'throws 200 status code' do
        course.students << student_user.accountable
        get "/api/courses/#{course.id}/notes/#{note.id}", params: { access_token: student_token.token }
        expect(response).to have_http_status(200)
      end
    end
    context 'when student tries to see a note that is not published' do
      it 'throws 404 status code' do
        note.published_at = nil
        note.save
        course.students << student_user.accountable
        get "/api/courses/#{course.id}/notes/#{note.id}", params: { access_token: student_token.token }
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST create' do
    context 'when teacher tries to create a note in a course he created' do
      it 'throws 200 status code' do
        post "/api/courses/#{course.id}/notes",
             params: { access_token: teacher_token.token,
                       note: { name: 'test', description: 'testing going on', published_at: '', course_id: course.id,
                               file: '' } }
        expect(response).to have_http_status(201)
      end
    end
    context 'when teacher tries to create a note in a course he is not created' do
      it 'throws 401 status code' do
        post "/api/courses/#{course.id + 100}/notes",
             params: { access_token: teacher_token.token,
                       note: { name: 'test', description: 'testing going on', published_at: '', course_id: course.id,
                               file: '' } }
        expect(response).to have_http_status(401)
      end
    end
    context 'when student tries to create a note' do
      it 'throws 401 status code' do
        post "/api/courses/#{course.id}/notes",
             params: { access_token: student_token.token,
                       note: { name: 'test', description: 'testing going on', published_at: '', course_id: course.id,
                               file: '' } }
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "PATCH update" do
    context "when teacher tries to update a note that he has access" do
      it "throws 201 status code" do
        patch "/api/courses/#{course.id}/notes/#{note.id}", params: { access_token: teacher_token.token, note: { name: 'test', description: 'testing going on', published_at: '', course_id: course.id, file: :nil } }
        expect(response).to have_http_status(202)
      end
    end
    context 'when teacher tries to update a note that he does not have access' do
      it 'throws 401 status code' do
        patch "/api/courses/#{course.id + 100}/notes/#{note.id}", params: { access_token: teacher_token.token, note: { name: 'test', description: 'testing going on', published_at: '', course_id: course.id + 100, file: :nil } }
        expect(response).to have_http_status(404)
      end
    end
    context 'when student tries to update a note' do
      it 'throws 401 status code' do
        patch "/api/courses/#{course.id}/notes/#{note.id}", params: { access_token: student_token.token, note: { name: 'test', description: 'testing going on', published_at: '', course_id: course.id, file: :nil } }
        expect(response).to have_http_status(401)
      end
    end
  end
  describe "DELETE destroy" do
    context "when teacher tries to delete a note that he has access" do
      it 'throws 200 status code' do
        delete "/api/courses/#{course.id}/notes/#{note.id}", params: { access_token: teacher_token.token }
        expect(response).to have_http_status(200)
      end
    end
    context 'when teacher tries to delete a note that he does not have access' do
      it 'throws 401 status code' do
        delete "/api/courses/#{course.id + 100}/notes/#{note.id}", params: { access_token: teacher_token.token }
        expect(response).to have_http_status(404)
      end
    end
    context 'when the student tries to delete a note' do
      it 'throws 401 status code' do
        delete "/api/courses/#{course.id}/notes/#{note.id}", params: { access_token: student_token.token }
        expect(response).to have_http_status(401)
      end
    end
  end
end
