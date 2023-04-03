# frozen_string_literal: true

ActiveAdmin.register Testresult do
  permit_params :test_id, :student_id, :score
end
