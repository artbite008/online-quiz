// 锚点(Anchor)间平滑跳转
function scroller(anchorId)
{     
    $('html,body').animate({scrollTop: $(anchorId).offset().top}, 500);
}
