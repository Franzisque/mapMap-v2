ActiveAdmin.register Image do
    config.batch_actions = true
    filter :pic_file_size
    filter :pic_content_type
    filter :pic_file_name
    filter :album

    index do
        selectable_column
        id_column
        column :pic_file_name
        column :pic_file_size
        column :pic_content_type
        column :album
        actions
    end

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
