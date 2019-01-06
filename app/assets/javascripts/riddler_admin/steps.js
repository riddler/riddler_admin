// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){
  $('#step-preview-refresh').on('ajax:beforeSend', function(evt) {
    paramsSource = $("#context-params-source").val()

    if (paramsSource != "") {
      var data = new window.FormData(),
        paramsLines = paramsSource.split("\n");

      $.each(paramsLines, function(idx, line) {
        var pair = line.split(":");
        var key = $.trim(pair[0]);
        var val = $.trim(pair[1]);
        data.append(key, val);
      });

      evt.detail[1].data = data
    };


    headersSource = $("#context-headers-source").val()
    if (headersSource != "") {
      var headersLines = headersSource.split("\n");
      var xhr = evt.detail[0];

      $.each(headersLines, function(idx, line) {
        var pair = line.split(":");
        var key = $.trim(pair[0]);
        var val = $.trim(pair[1]);
        xhr.setRequestHeader(key, val);
      });
    }
  });


  $(".element-container").sortable({
    revert: 50,
    opacity: 0.5,
    handle: ".handle",
    cursor: "move",
    containment: "parent",
    forcePlaceholderSize: true,
    update: function(event, ui) {
      element_ids = $(this).sortable("toArray", { attribute: "data-id" })

      Rails.ajax({
        type: "PUT",
        url: "/riddler_admin/elements/sort",
        data: $.param({ element_order: element_ids })
      })
    }
  })
})
