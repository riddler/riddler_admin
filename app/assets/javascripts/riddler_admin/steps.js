// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){
  $('.step-context-preview').on('click', function(evt) {
    var stepId = $(this).data('stepId'),
      pctxId = $(this).data('pctxId')

    var url = "/riddler_admin/steps/" + stepId + "/internal_preview?pctx_id=" + pctxId

    Rails.ajax({
      type: "GET",
      url: url,
      success: function(data){
        eval(data);
      }
    })
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

  $(".step-container").sortable({
    revert: 50,
    opacity: 0.5,
    handle: ".handle",
    cursor: "move",
    containment: "parent",
    forcePlaceholderSize: true,
    update: function(event, ui) {
      step_ids = $(this).sortable("toArray", { attribute: "data-id" })

      Rails.ajax({
        type: "PUT",
        url: "/riddler_admin/steps/sort",
        data: $.param({ step_order: step_ids })
      })
    }
  })
})
