ActiveAdmin.register Answer do
  permit_params :answer, :question_id

  filter :id
  filter :answer
end
