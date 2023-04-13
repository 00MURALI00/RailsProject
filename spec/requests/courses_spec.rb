require 'rails_helper'

RSpec.describe Api::CoursesController do
  # render_views
  let(:course) {create(:course)}
  describe "GET /api/courses" do
    it "works! (now write some real specs)" do
      get api_courses_path
      expect(response).to have_http_status(200)
    end
  end
  describe "GET /api/courses/:id" do
    it "works! (now write some real specs)" do
      # course = create(course)
      p course
      get api_course_path(id: course.id)
      expect(response).to have_http_status(200)
    end
  end
end
