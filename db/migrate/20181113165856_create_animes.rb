class CreateAnimes < ActiveRecord::Migration[5.0]
  def change
  	create_table :animes do |t|
  		t.string :title
  		t.integer :genre_id
  		t.string :age_rating
  		t.float :score
  	end
  end
end
