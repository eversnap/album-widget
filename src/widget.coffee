document.write('<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8/jquery.min.js"></' + 'script>')
$ = jQuery.noConflict( true )

API_BASE = 'http://www.eversnapapp.com/api/v4'
MEDIA_PREFIX = 'https://d1haew79obdw6u.cloudfront.net/platform/'

class EversnapWidget
    albumPattern = /eversnapapp\.com\/album\/([^\/]+)/i
    albumTemplate = '''
    <div id="album">
        <header id="album__header">
            <a id="logo" target="_blank" href="http://eversnapapp.com/"></a>
            <h1 id="album__title"></h1>
            <a id="album__join" target="_blank">Join album</a>
        </header>
        <div id="album__photos">
        </div>
    </div>
    '''
    constructor: (@el) ->
        @$el = $(@el)
        @id = @$el.attr('href').match(albumPattern)[1]
        @width = @$el.attr('width') or 640
        @height = @$el.attr('height') or 480

        @iframe = $("<iframe id='eversnap-album-#{@id}' scrolling='no' frameborder='0' allowtransparency='true' title='Eversnap Album'>")
            .css
                width: @width
                height: @height
                border: 'none'
                maxWidth: '100%'
                minWidth: '180px'

        @$el.replaceWith( @iframe )
        @iframe.promise().done =>
            iframeDocument = $(@iframe[0].contentWindow.document)
            @initDocument(iframeDocument)

    initDocument: (@iframeDocument) ->
        @body = $('body', @iframeDocument)
        head = $('head', @iframeDocument)
        $('<link>').attr('rel','stylesheet')
            .attr('type','text/css')
            .attr('href','styles/widget.css')
            .appendTo(head);

        @retrieveAlbum(@id)
        $(@body).on "click", "a.album__photo", (e) ->
            e.preventDefault()
            el = $(@)
            window.open(el.attr("href"), "popupPhoto", "height=400,width=400,status=no,toolbar=no,menubar=no,location=no")
            false

    albumUrl: (id) ->
        "https://www.eversnapapp.com/album/#{id}"
        
    retrieveAlbum: (id) ->
        email = 'guest@weddingsnap.com'
        token = 'e2f77be504f849c6e2c99f62b9f208ad6f89b89b'
        $.ajax({
            type: "GET",
            crossDomain: true,
            headers: 
                Authorization: "ApiKey #{email}:#{token}"
            url: "#{API_BASE}/itemlist/#{id}/?format=json",
            dataType: 'json',
            success: (data) =>
                @body.html albumTemplate
                @body.find('#album__title').html("Album #{data.album_title or '(no name)'}")
                @body.find("#album__join").attr("href", @albumUrl(@id))
                album__height = @body.height()
                header_height = @body.find('#album__header').outerHeight(true)
                @body.find('#album__photos').height(album__height - header_height)
                html = ''
                $.each data.objects, (i, v) ->
                    html += """<a class='album__photo' href='#{MEDIA_PREFIX}#{v.image_full}' ><img class='photo' src='#{MEDIA_PREFIX}#{v.image_thumb}' /><div class="photo-info"><span class="photo-likes">#{v.likesNum or 0}</span><span class="photo-comments">#{v.commentsNum or 0}</span></div></a>""";
                @body.find('#album__photos').html html
        })

$(document).ready ->
    $('.eversnap-album').each ->
        widget = new EversnapWidget(this)
