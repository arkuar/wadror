class AddGithubUidToUser < ActiveRecord::Migration
  def change
    add_column :users, :github_uid, :integer
  end
end
