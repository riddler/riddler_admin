// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){
  $('.email-context-preview').on('click', function(evt) {
    var emailId = $(this).data('emailId'),
      pctxId = $(this).data('pctxId')

    var url = window.riddler_admin_path + "emails/" + emailId + "/internal_preview?pctx_id=" + pctxId

    Rails.ajax({
      type: "GET",
      url: url,
      success: function(data){
        eval(data);
      }
    })
  });

  $('.send-preview-email-link').on('click', function(evt) {
    var email = window.prompt("Email address to send to:");
    if (email == "") return false;
    console.log(evt);
    return false;
  });

  $(".email-container").sortable({
    revert: 50,
    opacity: 0.5,
    handle: ".handle",
    cursor: "move",
    containment: "parent",
    forcePlaceholderSize: true,
    update: function(event, ui) {
      email_ids = $(this).sortable("toArray", { attribute: "data-id" })

      url = window.riddler_admin_path + "emails/sort"
      Rails.ajax({
        type: "PUT",
        url: url,
        data: $.param({ email_order: email_ids })
      })
    }
  })
})
