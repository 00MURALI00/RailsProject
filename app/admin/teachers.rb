# frozen_string_literal: true

ActiveAdmin.register Teacher do
  permit_params :name, :age, :gender, user_attributes: %i[email password password_confirmation role]

  filter :id
  filter :name
  filter :age
  filter :gender

  form do |f|
    f.semantic_errors
    f.inputs
    f.inputs do
      f.has_many :user, heading: 'Account Details', allow_destroy: true do |a|
        a.input :email
        a.input :password
        a.input :password_confirmation
        a.input :role, as: :select, collection: %w[student teacher]
      end
    end
    f.actions
  end
end
