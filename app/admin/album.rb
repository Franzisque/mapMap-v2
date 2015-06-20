ActiveAdmin.register Album do
    index do
        selectable_column
        id_column
        column :resource
        column :thumb_id
        actions
    end

    show do
        panel 'Details' do
            table_for album do
                column :id
                column :resource
                column :thumb_id
            end
        end
        panel 'Images' do
            table_for album.images do |_image|
                column :id
                column :pic_file_name
                column :pic_file_size
                column :pic_content_type
            end
        end
    end

    permit_params :thumb_id, images_attributes: [:id, :pic, :_destroy]
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
