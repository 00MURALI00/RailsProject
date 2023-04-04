ActiveAdmin.register Course do
  permit_params :name, :description

  filter :id
  filter :name
  filter :description 
end
