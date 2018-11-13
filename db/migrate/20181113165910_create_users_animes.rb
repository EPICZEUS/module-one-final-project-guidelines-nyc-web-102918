class CreateUsersAnimes < ActiveRecord::Migration[5.0]
  def change
  	create_table :users_animes do |t|
  		t.integer :user_id
  		t.integer :anime_id
  		t.float :user_rating
  	end
  end
end
