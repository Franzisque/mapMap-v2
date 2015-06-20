ActiveAdmin.register User do
    # menu :priority => 5

    config.batch_actions = true
    filter :username
    filter :email
    filter :created_at

    index do
        selectable_column
        id_column
        column :username
        column :email
        column :firstname
        column :lastname
        column :country
        column :created_at
        column :confirmed_at
        column :authorization
        actions
    end

    # See permitted parameters documentation:
    # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
    #
    permit_params :email, :username, :firstname, :lastname, :country_id, :birth_day, :birth_month, :birth_year
    #
    # or
    #
    # permit_params do
    #   permitted = [:permitted, :attributes]
    #   permitted << :other if resource.something?
    #   permitted
    # end
end
