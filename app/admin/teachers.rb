# frozen_string_literal: true

ActiveAdmin.register Teacher do
  permit_params :name, :age, :gender
end
