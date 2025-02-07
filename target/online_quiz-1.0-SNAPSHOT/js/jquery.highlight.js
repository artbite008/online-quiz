
(function($){
  $.fn.highLight = function(str) {
    if(str == undefined || str ==" ") {
		return this.find("span.highlight").each(function() {
		  this.parentNode.firstChild.nodeName;
		  with (this.parentNode) {
		  	replaceChild(this.firstChild, this);
		  	normalize();
		  }
		}).end();
    } else {
      $(this).each(function(){
        elt = $(this).get(0);
        elt.normalize();
        $.each($.makeArray(elt.childNodes), function(i, node){
          if(node.nodeType == 3) {
            var searchnode = node;
			var pos = searchnode.data.indexOf(str);
            if(pos >= 0) {//查找
              var spannode = document.createElement('span');
              spannode.className = 'highlight';
              var middlebit = searchnode.splitText(pos);
              var searchnode = middlebit.splitText(str.length);
              var middleclone = middlebit.cloneNode(true);
              spannode.appendChild(middleclone);
              searchnode.parentNode.replaceChild(spannode, middlebit);
            }
          } else {
            $(node).highLight(str);
          }
        })
      })
    }
    return $(this);
  }
})(jQuery);


