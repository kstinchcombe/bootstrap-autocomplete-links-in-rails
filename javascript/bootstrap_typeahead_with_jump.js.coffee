# requires jquery and debounce plugin
# https://code.google.com/p/jquery-debounce/source/browse/trunk/jquery.debounce.js

# typeahead with jump-to-result
# from this GENIUS blog post
# http://fusiongrokker.com/post/heavily-customizing-a-bootstrap-typeahead

# expects each .typeahead-api-jump element to have data-api-path defined.
# 
# this URL will expect to be hit with
# url?q=what+they+typed+in+the+box
#
# and is expected to return of the form
# [{ name: 'name of obj', path: '/path/to/obj' }, ...]

# warning: this assumes that neither the name nor the path will ever
# include the pipe character. if you expect those, pick a character you're comfortable
# assuming will not be present, and search for the comment "control character"
# and mess with those lines.


$(document).ready( ->
  $(".typeahead-api-jump").each((idx, elem) ->

    elem = $(elem)
    api_path = elem.attr('data-api-path')

    elem.typeahead

      # fetches the text from which to populate
      # the text box
      source: (query, process) ->
        searchFor query, process, api_path

      updater: (item) ->
        # jump to that person's account(s)
        path = item.replace(/.*\|/, '')  # control character
        if (path)
          window.location.href = path

        #return the string you want to go into the textbox (e.g. name)
        item.replace(/\|.*/, '') # control character
    
      # matcher determines what to show. because we do search server side
      # all returned items match
      matcher: (item) ->
        true
      # items are already sorted from server, no need to sort here
      sorter: (items) ->
        items
      # highlighter places item text in the box. in this case, we
      # use only the part of the name
      highlighter: (item) ->
        item.replace(/\|.*/, '')  # control character is '|'
  )
)


# requires debounce plugin. limits queries to three per second
# https://code.google.com/p/jquery-debounce/source/browse/trunk/jquery.debounce.js
searchFor = $.debounce((query, process, api_path) ->
  
  # the "process" argument is a callback, expecting an array of values (strings) to populate
  # the typeahead from your api
  
  $.get api_path,
  
    q: query , (data) ->
      vals = []
      $.each data, (idx, obj) ->
        vals.push "#{obj.name}|#{obj.path}"  # control character

      process vals

, 300)
