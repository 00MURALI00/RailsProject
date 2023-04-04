# frozen_string_literal: true

ActiveAdmin.register Student do
  permit_params :name, :age, :gender

  filter :id
  filter :name
  filter :age
  filter :gender

  scope :test_taken
  scope :test_not_taken
end
