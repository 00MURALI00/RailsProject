ActiveAdmin.register Option do
  permit_params :opt1, :opt2, :opt3, :opt4, :question_id

  filter :id
  filter :opt1
  filter :opt2
  filter :opt3
  filter :opt4
end
