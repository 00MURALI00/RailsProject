# frozen_string_literal: true

ActiveAdmin.register Note do
  permit_params :name, :description, :published_at, :course_id

  filter :id
  filter :name
  filter :description

  scope :all
  scope :published
  scope :unpublished

  index do
    selectable_column
    column :id
    column :name
    column :description
    column 'Published', :published_at?
    # column '' do |note|
    #   link_to 'view', admin_note_path(id: note.id)
    # end
    # column '' do |note|
    #   link_to 'edit', edit_admin_note_path(id: note.id)
    # end
    # column '' do |note|
    #   link_to 'delete', admin_note_path(id: note.id), method: :delete
    # end
    actions
  end

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
