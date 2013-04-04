Uses a bootstrap autocomplete field to offer a search on a rails model, and selecting jumps
to the object. The rails assumption is pretty light. You could write the search API in whatever.


=== GOAL ===

This assumes you have a rails project with bootstrap, jquery, and postgres. Who doesn't these days.

You have a set of objects that you want to enable someone to jump to. The objects have
names and urls. You want your user to be able to search for them. But instead of completing
the search box and then they press return and search, you want that click or return keypress
to take them to the object itself.

The result is that you can define an element like this (haml):

%input.typeahead-api-jump{:placeholder => "Find a user", 'data-api-path' => '/people/search_by_name.json'}

and it will hit that path, search for matching elements, and you can click on items in the list
to jump to that object.

This is heavily based on the genius blog bootstrap-typeahead-hacking post here:
http://fusiongrokker.com/post/heavily-customizing-a-bootstrap-typeahead



=== MOVING PARTS ===

(a) You'll want to add indices to make your objects nicely searchable.
(b) You'll want to write the API path to search your objects.
(c) You'll need to include the javascript to power it all, plus a dependency from
    https://code.google.com/p/jquery-debounce/source/browse/trunk/jquery.debounce.js
(d) Then you need to create the search element in your html.


=== THE JAVASCRIPT ===

Pretty self-explanatory and reusable. Put it wherever your javascript lives, include it in
the way you best know how. I wrote it as coffee but included compiled javascript.

=== THE API ENDPOINT ===

You can write anything that returns
[{ name: 'name of obj', path: '/path/to/obj' }, ...]
which is pretty easy in any language. I included some reference code if you're working in rails.

In my case, I have the Person object with a first_name and last_name column, and Person has a
full_name method. The characters for the person's name components are A-Za-Z and dashes, also spaces.
I want them sorted by last name.

Presumably your situation will be different.
You'll want to glance at this line-by-line to figure out how to properly do it.

=== THE MIGRATION ===

We use postgres' ability to index on a function to do character-insensitive searching. If
you don't want/need to do that, or are happy using a case-independent database collation, you don't
need to do that. The point is, you need to be able to find something LIKE what the person searched
for efficiently.

Change the table and column name(s) as appropriate obvi.
