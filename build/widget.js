(function() {
  var $, API_BASE, EversnapWidget, MEDIA_PREFIX;

  document.write('<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8/jquery.min.js"></' + 'script>');

  $ = jQuery.noConflict(true);

  API_BASE = 'http://www.eversnapapp.com/api/v4';

  MEDIA_PREFIX = 'https://d1haew79obdw6u.cloudfront.net/platform/';

  EversnapWidget = (function() {
    var albumPattern, albumTemplate;

    albumPattern = /eversnapapp\.com\/album\/([^\/]+)/i;

    albumTemplate = '<div id="album">\n    <header id="album__header">\n        <a id="logo" target="_blank" href="http://eversnapapp.com/"></a>\n        <h1 id="album__title"></h1>\n        <a id="album__join" target="_blank">Join album</a>\n    </header>\n    <div id="album__photos">\n    </div>\n</div>';

    function EversnapWidget(el) {
      var _this = this;
      this.el = el;
      this.$el = $(this.el);
      this.id = this.$el.attr('href').match(albumPattern)[1];
      this.width = this.$el.attr('width') || 640;
      this.height = this.$el.attr('height') || 480;
      this.iframe = $("<iframe id='eversnap-album-" + this.id + "' scrolling='no' frameborder='0' allowtransparency='true' title='Eversnap Album'>").css({
        width: this.width,
        height: this.height,
        border: 'none',
        maxWidth: '100%',
        minWidth: '180px'
      });
      this.$el.replaceWith(this.iframe);
      this.iframe.promise().done(function() {
        var iframeDocument;
        iframeDocument = $(_this.iframe[0].contentWindow.document);
        return _this.initDocument(iframeDocument);
      });
    }

    EversnapWidget.prototype.initDocument = function(iframeDocument) {
      var head;
      this.iframeDocument = iframeDocument;
      this.body = $('body', this.iframeDocument);
      head = $('head', this.iframeDocument);
      $('<link>').attr('rel', 'stylesheet').attr('type', 'text/css').attr('href', 'styles/widget.css').appendTo(head);
      this.retrieveAlbum(this.id);
      return $(this.body).on("click", "a.album__photo", function(e) {
        var el;
        e.preventDefault();
        el = $(this);
        window.open(el.attr("href"), "popupPhoto", "height=400,width=400,status=no,toolbar=no,menubar=no,location=no");
        return false;
      });
    };

    EversnapWidget.prototype.albumUrl = function(id) {
      return "https://www.eversnapapp.com/album/" + id;
    };

    EversnapWidget.prototype.retrieveAlbum = function(id) {
      var email, token,
        _this = this;
      email = 'guest@weddingsnap.com';
      token = 'e2f77be504f849c6e2c99f62b9f208ad6f89b89b';
      return $.ajax({
        type: "GET",
        crossDomain: true,
        headers: {
          Authorization: "ApiKey " + email + ":" + token
        },
        url: "" + API_BASE + "/itemlist/" + id + "/?format=json",
        dataType: 'json',
        success: function(data) {
          var album__height, header_height, html;
          _this.body.html(albumTemplate);
          _this.body.find('#album__title').html("Album " + (data.album_title || '(no name)'));
          _this.body.find("#album__join").attr("href", _this.albumUrl(_this.id));
          album__height = _this.body.height();
          header_height = _this.body.find('#album__header').outerHeight(true);
          _this.body.find('#album__photos').height(album__height - header_height);
          html = '';
          $.each(data.objects, function(i, v) {
            return html += "<a class='album__photo' href='" + MEDIA_PREFIX + v.image_full + "' ><img class='photo' src='" + MEDIA_PREFIX + v.image_thumb + "' /><div class=\"photo-info\"><span class=\"photo-likes\">" + (v.likesNum || 0) + "</span><span class=\"photo-comments\">" + (v.commentsNum || 0) + "</span></div></a>";
          });
          return _this.body.find('#album__photos').html(html);
        }
      });
    };

    return EversnapWidget;

  })();

  $(document).ready(function() {
    return $('.eversnap-album').each(function() {
      var widget;
      return widget = new EversnapWidget(this);
    });
  });

}).call(this);
