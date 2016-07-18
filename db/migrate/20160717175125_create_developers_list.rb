class CreateDevelopersList < ActiveRecord::Migration
  def change
    ['Max', 'Minmin', 'Long', 'Noel', 'Nero', 'Rinoc'].each do |name|
      Developer.create name: name
    end
  end
end
