// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){

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
    },


    old_update: function(event, ui) {
      params = {
        type: ui.item.data("klass"),
        step_id: ui.item.parent().data("stepId")
      }
      $.get("/riddler_admin/elements/new", params, function(data) {
        ui.item.removeAttr("style");
        ui.item.html(data);
      });
    }
  })

  /*
  $(".element-classes-draggable").draggable({
    connectToSortable: "#step-elements",
    revertDuration: 50,
    revert: "invalid",
    helper: "clone"
  })
  */

})
