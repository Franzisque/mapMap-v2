ActiveAdmin.register Authorization do
    config.batch_actions = true
    filter :provider
    filter :created_at

    index do
        selectable_column
        id_column
        column :provider
        column :uid
        column :user
        column :created_at
        actions
    end

    permit_params :provider, :uid
end
