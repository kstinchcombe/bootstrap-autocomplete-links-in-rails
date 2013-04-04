class PeopleController < ApplicationController

  def search_by_name
    
    # how many items you want in the dropdown
    max_results = 10
    
    # clean the name. in our case, the name field is alphanumeric plus dashes
    # we downcase it because our index is downcased. much simpler than worrying about
    # capitalization. you can also do this with case-insensitive coallation but
    # that's a whole nother thing.
    #
    # whatever you prefer to do here, make sure it strips special characters since
    # we're dumping this as raw sql
    #
    q = (params[:q] || '').downcase.strip.gsub(/[^a-z\- ]/,'').gsub(/ +/,' ')

    # Don't allow search with <3 characters. This will get us nowhere.
    if q.length < 3 then
      @people = []
      
    # we have a real value to work with. go ahead and do the search
    else

      # split on words and use an OR
      #
      # you could argue for an AND in the sense that someone searching for John Smith
      # wants all John Smiths, not all Johns and Smiths. Fine. But given our indexing, 
      # this would screw up searches for Mary Jane.
      #
      query_whereclause =
        q.split(' ').collect{|s| "lower(first_name) like '#{s}%' OR lower(last_name) like '#{s}%'"}.join(" OR ")
        # we have an index on lowercase firstname and lastname so this will run fast
    
      # run our query
      @people = Person.find_by_sql("select * from people where #{query_whereclause} order by last_name, first_name limit #{max_results}")
    end
    
    respond_to do |format|
      
      # maybe you allow HTML listings of results also. If not, or if you want to use pagination
      # on your indices etc, you'll need to mess with this.
      format.html { render :index }
      
      # collect name and path
      # note, this uses .full_name on the object, if you're doing something else, use something else...
      format.json {
        @people = @people.collect{|p| {name: p.full_name, path: person_path(p) } }
        render json: @people
      }
      
    end

  end
  
end