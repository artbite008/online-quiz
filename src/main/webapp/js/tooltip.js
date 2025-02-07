/***********************************************
 * Cool DHTML tooltip script II- © Dynamic Drive DHTML code library (www.dynamicdrive.com)
 * This notice MUST stay intact for legal use
 * Visit Dynamic Drive at http://www.dynamicdrive.com/ for full source code
 ***********************************************/

var offsetfromcursorX = 12//Customize x offset of tooltip
var offsetfromcursorY = 10//Customize y offset of tooltip
var offsetdivfrompointerX = 10//Customize x offset of tooltip DIV relative to pointer image
var offsetdivfrompointerY = 14//Customize y offset of tooltip DIV relative to pointer image. Tip: Set it to (height_of_pointer_image-1).
document.write('<div id="dhtmltooltip"></div>')//write out tooltip DIV
document.write('<img id="dhtmlpointer" src="../images/tooltip_arrow.gif"/>')//write out pointer image
var ie = document.all
var ns6 = document.getElementById && !document.all
var enabletip = false
if (ie || ns6)
    var tipobj = document.all ? document.all["dhtmltooltip"] : document.getElementById ? document.getElementById("dhtmltooltip") : ""

var pointerobj = document.all ? document.all["dhtmlpointer"] : document.getElementById ? document.getElementById("dhtmlpointer") : ""

function ietruebody() {
    return (document.compatMode && document.compatMode != "BackCompat") ? document.documentElement : document.body
}

function ddrivetip(element, thetext, thewidth, thecolor) {
    if (ns6 || ie) {
        if (typeof thewidth != "undefined"){
            tipobj.style.width = thewidth + "px";
        }
        if (typeof thecolor != "undefined" && thecolor != ""){
            tipobj.style.backgroundColor = thecolor;
        }
        tipobj.innerHTML = thetext;
        positiontip(element);
    }
}

function positiontip(element) {
    var position = getElementPosition(element);
    var nondefaultpos = false;
    var curX = position.x;
    var curY = position.y;
    
    //Find out how close the mouse is to the corner of the window
    var winwidth = ie && !window.opera ? ietruebody().clientWidth : window.innerWidth - 20
    var winheight = ie && !window.opera ? ietruebody().clientHeight : window.innerHeight - 20

    var rightedge = ie && !window.opera ? winwidth - event.clientX - offsetfromcursorX : winwidth - element.clientX - offsetfromcursorX
    var bottomedge = ie && !window.opera ? winheight - event.clientY - offsetfromcursorY : winheight - element.clientY - offsetfromcursorY

    var leftedge = (offsetfromcursorX < 0) ? offsetfromcursorX * ( - 1) :  - 1000

    //if the horizontal distance isn't enough to accomodate the width of the context menu
    if (rightedge < tipobj.offsetWidth) {
        //move the horizontal position of the menu to the left by it's width
        tipobj.style.left = curX - tipobj.offsetWidth + "px"
        nondefaultpos = true
    }
    else if (curX < leftedge)
        tipobj.style.left = "5px"
    else {
        //position the horizontal position of the menu where the mouse is positioned
        tipobj.style.left = curX + offsetfromcursorX - offsetdivfrompointerX + 60 + "px"
        pointerobj.style.left = curX + offsetfromcursorX + 60 +"px"
    }

    //same concept with the vertical position
    if (bottomedge < tipobj.offsetHeight) {
        tipobj.style.top = curY - tipobj.offsetHeight - offsetfromcursorY + "px"
        nondefaultpos = true
    }
    else {
        tipobj.style.top = curY + offsetfromcursorY + offsetdivfrompointerY - 55 + "px"
        pointerobj.style.top = curY + offsetfromcursorY + tipobj.offsetHeight -42 + "px"
    }
    tipobj.style.visibility = "visible"
    if (!nondefaultpos)
        pointerobj.style.visibility = "visible"
    else 
        pointerobj.style.visibility = "hidden"
}

function hideddrivetip() {
    if (ns6 || ie) {
        enabletip = false
        tipobj.style.visibility = "hidden"
        pointerobj.style.visibility = "hidden"
        tipobj.style.left = "-1000px"
        tipobj.style.backgroundColor = ''
        tipobj.style.width = ''
    }
}

//document.onmousemove = positiontip;

function getElementPosition(element) {
    var result = new Object();
    result.x = 0;
    result.y = 0;
    result.width = 0;
    result.height = 0;
    if (element.offsetParent) {
        result.x = element.offsetLeft;
        result.y = element.offsetTop;
        var parent = element.offsetParent;
        while (parent) {
            result.x += parent.offsetLeft;
            result.y += parent.offsetTop;
            var parentTagName = parent.tagName.toLowerCase();
            if (parentTagName != "table" &&
                parentTagName != "body" && 
                parentTagName != "html" && 
                parentTagName != "div" && 
                parent.clientTop && 
                parent.clientLeft) {
                result.x += parent.clientLeft;
                result.y += parent.clientTop;
            }
            parent = parent.offsetParent;
        }
    }
    else if (element.left && element.top) {
        result.x = element.left;
        result.y = element.top;
    }
    else {
        if (element.x) {
            result.x = element.x;
        }
        if (element.y) {
            result.y = element.y;
        }
    }
    if (element.offsetWidth && element.offsetHeight) {
        result.width = element.offsetWidth;
        result.height = element.offsetHeight;
    }
    else if (element.style && element.style.pixelWidth && element.style.pixelHeight) {
        result.width = element.style.pixelWidth;
        result.height = element.style.pixelHeight;
    }
    return result;
}