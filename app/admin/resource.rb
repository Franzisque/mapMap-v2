ActiveAdmin.register Resource do
    config.batch_actions = true
    filter :title
    filter :medium_type
    filter :medium_id
    filter :user
    filter :tags
    filter :created_at

    index do
        selectable_column
        id_column
        column :title
        column :description
        column :medium
        column :medium_type
        column :medium_id
        column :user
        actions
    end

    permit_params :title, :description, :user, medium_attributes: [:link, :upload, images_attributes: [:id, :_destroy, :pic]]
end
