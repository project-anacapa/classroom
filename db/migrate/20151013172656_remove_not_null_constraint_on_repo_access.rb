class RemoveNotNullConstraintOnRepoAccess < ActiveRecord::Migration
  def change
    change_column :repo_accesses, :github_team_id, :string, :null => true
  end
end
