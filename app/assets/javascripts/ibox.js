// ibox image zoomer plugin // roXon

(function($) {
    $.fn.ibox = function() {
        
        // set zoom ratio //
        resize = 20;
        ////////////////////
        var img = this;
        img.parent().append('<div id="ibox" />');
        var ibox = $('#ibox');
        var elX = 0;
        var elY = 0;

        img.each(function() {
            var el = $(this);

            el.mouseenter(function() {
                ibox.html('');
                var elH = el.height();
                elX = el.position().left - 6; // 6 = CSS#ibox padding+border
                elY = el.position().top - 6;
                var h = el.height();
                var w = el.width();
                var wh;
                checkwh = (h < w) ? (wh = (w / h * resize) / 2) : (wh = (w * resize / h) / 2);

                $(this).clone().prependTo(ibox);
                ibox.css({
                    top: elY + 'px',
                    left: elX + 'px'
                });

                ibox.stop().fadeTo(200, 1, function() {
                    $(this).animate({top: '-='+(resize/2), left:'-='+wh},400).children('img').animate({height:'+='+resize},400);
                });
            });

            ibox.mouseleave(function() {
                ibox.html('').hide();
            });
        });
    };
})(jQuery);

$(document).ready(function() {
    $('#images img').ibox();
});​