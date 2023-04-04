# frozen_string_literal: true

ActiveAdmin.register Teacher do
  permit_params :name, :age, :gender

  filter :id
  filter :name
  filter :age
  filter :gender
end
