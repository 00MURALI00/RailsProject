ActiveAdmin.register User do
  permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at,
                :role, :accountable_type, :accountable_id

  filter :id
  filter :accountable_type
  filter :email

  # form do |f|
  #   f.input :email, :encrypted_password
  #   actions
  # end
  
end
