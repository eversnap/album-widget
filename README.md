# Eversnap Album Widget

Drop this script on your page and it will build you a beautiful widget that displays the photos of your Eversnap Album.

## How do I use it?

Everwhere you want a widget to be placed, add the following markup:

```html
<a class="eversnap-album" href="https://www.eversnapapp.com/album/{{ALBUM_ID}}"></div>
```

Then include the javascript code somewhere after:

```html
<script type="text/javascript">
!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="https://s3.amazonaws.com/media.weddingsnap.com/platform/widget.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","eversnap-wjs");
</script>
```

That's it! ;)
