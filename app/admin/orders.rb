ActiveAdmin.register Order do
  permit_params :status

  includes :customer, order_items: :product

  filter :id
  filter :customer
  filter :status, as: :select, collection: Order::STATUSES
  filter :created_at

  index do
    selectable_column
    id_column

    column :customer
    column :subtotal
    column :tax_total
    column :total

    column :status do |order|
      status_tag order.status
    end

    column :created_at

    actions
  end

  show do
    attributes_table do
      row :id
      row :customer
      row :subtotal
      row :gst
      row :pst
      row :hst
      row :tax_total
      row :total

      row :status do |order|
        status_tag order.status
      end

      row :stripe_session_id
      row :stripe_payment_intent_id

      row :created_at
      row :updated_at
    end

    panel "Order Items" do
      table_for order.order_items do
        column :product
        column :quantity
        column :unit_price
        column :subtotal
      end
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs "Order Status" do
      f.input :status,
              as: :select,
              collection: Order::STATUSES,
              include_blank: false
    end

    f.actions
  end

  member_action :mark_as_shipped, method: :put do
    resource.mark_as_shipped!

    redirect_to resource_path,
                notice: "Order ##{resource.id} was marked as shipped."
  end

  action_item :mark_as_shipped,
              only: :show,
              if: proc { resource.status == "paid" } do
    link_to "Mark as Shipped",
            mark_as_shipped_admin_order_path(resource),
            method: :put,
            data: {
              confirm: "Are you sure this order has been shipped?"
            }
  end
end