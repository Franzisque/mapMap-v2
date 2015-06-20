ActiveAdmin.register VideoUpload do
    config.batch_actions = true
    filter :upload_file_size
    filter :upload_content_type
    filter :upload_file_name
    filter :upload_updated_at

    index do
        selectable_column
        id_column
        column :upload_file_name
        column :upload_file_size
        column :upload_content_type
        column :upload_updated_at
        column :resource
        actions
    end

    permit_params :upload

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
