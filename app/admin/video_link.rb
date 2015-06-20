ActiveAdmin.register VideoLink do
    config.batch_actions = true
    filter :provider
    filter :vid
    filter :link
    filter :created_at

    index do
        selectable_column
        id_column
        column :link
        column :provider
        column :vid
        column :resource
        actions
    end

    permit_params :link, :provider, :vid

    # See permitted parameters documentation:
    # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
    #
    # permit_params :list, :of, :attributes, :on, :model
    #
    # or
    #
    # permit_params do
    #   permitted = [:permitted, :attributes]
    #   permitted << :other if resource.something?
    #   permitted
    # end
end
