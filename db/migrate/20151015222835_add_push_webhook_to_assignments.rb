class AddPushWebhookToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments,       :push_webhook, :string
    add_column :group_assignments, :push_webhook, :string
  end
end
