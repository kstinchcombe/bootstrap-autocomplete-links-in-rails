class AddSomeIndices < ActiveRecord::Migration
  
  def up
    
    execute "CREATE INDEX people_first_name_lowercase_idx ON people (lower(first_name));"
    execute "CREATE INDEX people_last_name_lowercase_idx ON people (lower(last_name));"
    
  end
  
  def down
    
    execute "DROP INDEX people_last_name_lowercase_idx;"
    execute "DROP INDEX people_first_name_lowercase_idx;"
    
  end

end
