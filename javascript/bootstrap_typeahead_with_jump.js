(function() {
  var searchFor;

  $(document).ready(function() {
    return $(".typeahead-api-jump").each(function(idx, elem) {
      var api_path;
      elem = $(elem);
      api_path = elem.attr('data-api-path');
      return elem.typeahead({
        source: function(query, process) {
          return searchFor(query, process, api_path);
        },
        updater: function(item) {
          var path;
          path = item.replace(/.*\|/, '');
          if (path) {
            window.location.href = path;
          }
          return item.replace(/\|.*/, '');
        },
        matcher: function(item) {
          return true;
        },
        sorter: function(items) {
          return items;
        },
        highlighter: function(item) {
          return item.replace(/\|.*/, '');
        }
      });
    });
  });

  searchFor = $.debounce(function(query, process, api_path) {
    return $.get(api_path, {
      q: query
    }, function(data) {
      var vals;
      vals = [];
      $.each(data, function(idx, obj) {
        return vals.push("" + obj.name + "|" + obj.path);
      });
      return process(vals);
    });
  }, 300);

}).call(this);
