$(function() {
  var $window = $(window)

  $('#language-logos, #profile-vcard').tooltip({
      selector: "[data-toggle=tooltip]"
  });

  // side bar
  setTimeout(function () {
    $('.prudge-sidenav').affix({
      offset: {
        top: function () { return $window.width() <= 980 ? 290 : 210 }
      , bottom: 270
      }
    })
  }, 100);

  $('#profile-tabs a').click(function (e) {
    e.preventDefault();
    $(this).tab('show');

    var link = $(this).data("link");
    if (link == undefined) return;

    var target = $($(this).data("target"));
    if (target.data('loaded') != undefined) return;

    var icon = $(this).find('i');
    var iconClass = icon.attr('class');
    icon.removeClass().addClass('icon-refresh icon-spin');
    
    $.ajax({
          url: link,
          type: 'GET',
          success: function(data, status, xhr) {
              target.html(data);
          },
          error: function(xhr, status, message) {
              target.html("Error");
          },
          complete: function(xhr, status){
              icon.removeClass().addClass(iconClass);
              target.data('loaded', 'true');
          }
      });
  });

  $("#flow_pagination a").live("click", function() {
    $(this).html("").addClass("loading");
    $.get(this.href, null, null, "script");
    return false;
  });

  $('.load-solutions').live("click", function(){
    var href = $(this).attr('href');
    $('#solved').slideUp('fast', function(){
         $('#spinner').show();
         $.get(href, function(resp){
           $('#spinner').hide();
           $('#solved').html(resp);
           $('#solved').slideDown('slow');
         });
         });
    return false;
    });

  $('.watch input').change(
    function(){
      if ($(this).is(':checked')) {
        $.get('/watchers/' + $(this).val() + '/watch');
      }else{
        $.get('/watchers/' + $(this).val() + '/unwatch');  
      }
    }
  );

  $('#check-button').click(function(){
      $('#check-button').hide();
      $('#result-content').hide();
      $('#check-wait').show();
  });

  $('#comment-form').submit(function(e){
      $('#comment-spinner').show();
      $('#comment-message').html('');
      $('#comment-form').disable();

      $.ajax({
          url: $(this).attr("action"),
          type: 'POST',
          data: $(this).serialize(),
          success: function(data, status, xhr) {
              $('#comment_text').val('');
              $('#comments').prepend(data);
          },
          error: function(xhr, status, message) {
              $('#comment-message').html(message);
          },
          complete: function(xhr, status){
              $('#comment-spinner').hide();
              $('#comment-form').enable();
          }
      });

      return false;
  });

//  var wmd_options = {"output":"Markdown"};
//  createWmd("textarea", "#preview");
});
