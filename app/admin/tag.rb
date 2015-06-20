ActiveAdmin.register Tag do
    index do
        selectable_column
        id_column
        column :name
        actions
    end

    permit_params :name
end
