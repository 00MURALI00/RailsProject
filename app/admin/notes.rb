ActiveAdmin.register Note do
  permit_params :name, :description, :course_id
end
