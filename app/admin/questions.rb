ActiveAdmin.register Question do
  permit_params :question, :test_id

  filter :id
  filter :question
end
