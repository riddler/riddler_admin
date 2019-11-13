// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){
  $('.feature-flag-context-preview').on('click', function(evt) {
    var featureFlagId = $(this).data('featureFlagId'),
      pctxId = $(this).data('pctxId')

    var url = window.riddler_admin_path + "feature_flags/" + featureFlagId + "/internal_preview?pctx_id=" + pctxId

    Rails.ajax({
      type: "GET",
      url: url,
      success: function(data){
        eval(data);
      }
    })
  });
})
