// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){
  $('.toggle-context-preview').on('click', function(evt) {
    var toggleId = $(this).data('toggleId'),
      pctxId = $(this).data('pctxId')

    var url = window.riddler_admin_path + "toggles/" + toggleId + "/internal_preview?pctx_id=" + pctxId

    Rails.ajax({
      type: "GET",
      url: url,
      success: function(data){
        eval(data);
      }
    })
  });

  $(".toggle-container").sortable({
    revert: 50,
    opacity: 0.5,
    handle: ".handle",
    cursor: "move",
    containment: "parent",
    forcePlaceholderSize: true,
    update: function(event, ui) {
      toggle_ids = $(this).sortable("toArray", { attribute: "data-id" })

      url = window.riddler_admin_path + "toggles/sort"
      Rails.ajax({
        type: "PUT",
        url: url,
        data: $.param({ toggle_order: toggle_ids })
      })
    }
  })
})
