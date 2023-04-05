# frozen_string_literal: true

ActiveAdmin.register Test do
  permit_params :name, :course_id, :published

  index do
    selectable_column
    column :id
    column :name
    column 'Course' do |test|
      course = Course.find_by(id: test.course_id)
      link_to course.name, admin_course_path(course)
    end
    column 'Published', :published?
    # column '' do |test|
    #   link_to 'view', admin_test_path(id: test.id)
    # end
    # column '' do |test|
    #   link_to 'edit', edit_admin_test_path(id: test.id)
    # end
    # column '' do |test|
    #   link_to 'delete', admin_test_path(id: test.id), method: :delete
    # end
    actions
  end

  scope :all
  scope :published
  scope :unpublished

  member_action :published, method: :put do
    resource.update(published_at: Time.zone.now)
    p 'Publish'
    redirect_to resource_path, notice: 'Done!!!'
  end
  member_action :unpublished, method: :put do
    resource.update(published_at: nil)
    p 'Unpublish'
    redirect_to resource_path, notice: 'Done!!!'
  end

  action_item :published, only: :show, if: proc { !resource.published? } do
    link_to 'Publish', [:published, :admin, resource], method: :put
  end
  action_item :unpublished, only: :show, if: proc { resource.published? } do
    link_to 'Unpublish', [:unpublished, :admin, resource], method: :put
  end
end
