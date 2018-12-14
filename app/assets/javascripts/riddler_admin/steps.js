// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){
  $('#step-preview-refresh').on('ajax:beforeSend', function(evt) {
    paramsSource = $("#context-params-source").val()

    if (paramsSource != "") {
      var data = new window.FormData(),
        paramsLines = paramsSource.split("\n");

      $.each(paramsLines, function(idx, line) {
        pair = line.split(":");
        key = $.trim(pair[0]);
        val = $.trim(pair[1]);
        data.append(key, val);
      });

      evt.detail[1].data = data
    };


    headersSource = $("#context-headers-source").val()
    if (headersSource != "") {
      headersLines = headersSource.split("\n");
      xhr = evt.detail[0];

      $.each(headersLines, function(idx, line) {
        pair = line.split(":");
        key = $.trim(pair[0]);
        val = $.trim(pair[1]);
        xhr.setRequestHeader(key, val);
      });
    }
  });


  $("#step-elements").sortable({
    revert: 50,
    opacity: 0.5,
    cursor: "move",
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
