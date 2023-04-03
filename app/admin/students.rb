# frozen_string_literal: true

ActiveAdmin.register Student do
  permit_params :name, :age, :gender
end
