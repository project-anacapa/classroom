class AddUserToAssignmentRepo < ActiveRecord::Migration
  def change
    add_column :assignment_repos, :user_id, :integer
    add_index  :assignment_repos, :user_id
  end
end
