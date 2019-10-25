class ChangeUserIdAndTokenDigestColumnOnUser < ActiveRecord::Migration[5.2]
  def change
    change_column_null :users, :user_id, false
    change_column_null :users, :token_digest, false
  end
end
