  var Class = {
        create: function() {
            return function() {
                this.initialize.apply(this, arguments);
            }
        }
    }
    Object.extend = function(destination, source) {
        for (var property in source) {
            destination[property] = source[property];
        }
        return destination;
    }
    function addEventHandler(oTarget, sEventType, fnHandler) {
        if (oTarget.addEventListener) {
            oTarget.addEventListener(sEventType, fnHandler, false);
        } else if (oTarget.attachEvent) {
            oTarget.attachEvent("on" + sEventType, fnHandler);
        } else {
            oTarget["on" + sEventType] = fnHandler;
        }
    };

    var Scroller = Class.create();
    Scroller.prototype = {
        initialize: function(idScroller, idScrollMid, options) {
            var oScroll = this, oScroller = document.getElementById(idScroller), oScrollMid = document.getElementById(idScrollMid);

            this.SetOptions(options);
            this.Scroller = oScroller;
            this.Speed = this.options.Speed;
            this.timer = null;
            this.Pause = 0;

            //用于上下滚动
            this.heightScroller = parseInt(oScroller.style.height) || oScroller.offsetHeight;
            this.heightList = oScrollMid.offsetHeight;

            //用于左右滚动
            this.widthScroller = parseInt(oScroller.style.width) || oScroller.offsetWidth;
            this.widthList = oScrollMid.offsetWidth;

            //js取不到css设置的height和width

            oScroller.style.overflow = "hidden";
            oScrollMid.appendChild(oScrollMid.cloneNode(true));

            //方向设置
            switch (this.options.Side.toLowerCase()) {
                case "right":
                    if (this.widthList <= this.widthScroller) return;
                    this.Scroll = this.ScrollLeftRight;
                    this.side = -1;
                    break;
                case "left":
                    if (this.widthList <= this.widthScroller) return;
                    this.Scroll = this.ScrollLeftRight;
                    this.side = 1;
                    break;
                case "down":
                    if (this.heightList <= this.heightScroller) return;
                    this.Scroll = this.ScrollUpDown;
                    this.side = -1;
                    break;
                case "up":
                default:
                    if (this.heightList <= this.heightScroller) return;
                    this.Scroll = this.ScrollUpDown;
                    this.side = 1;
            }

            addEventHandler(oScroller, "mouseover", function() { oScroll.Stop(); });
            addEventHandler(oScroller, "mouseout", function() { oScroll.Start(); });

            this.Start();
        },
        //设置默认属性
        SetOptions: function(options) {
            this.options = {//默认值
                Step: 1, //每次变化的px量
                Speed: 20, //速度(越大越慢)
                Side: "up", //滚动方向:"up"是上，"down"是下，"left"是左，"right"是右
                PauseHeight: 0, //隔多高停一次
                PauseWidth: 0, //隔多宽停一次
                PauseStep: 1000//停顿时间(PauseHeight或PauseWidth大于0该参数才有效)
            };
            Object.extend(this.options, options || {});
        },
        //上下滚动
        ScrollUpDown: function() {
            this.Scroller.scrollTop = this.GetScroll(this.Scroller.scrollTop, this.heightScroller, this.heightList, this.options.PauseHeight);

            var oScroll = this;
            this.timer = window.setTimeout(function() { oScroll.Scroll(); }, this.Speed);
        },
        //左右滚动
        ScrollLeftRight: function() {
            //document.getElementById("test").innerHTML+=iStep+",";
            //注意:scrollLeft超过1400会自动变回1400 注意长度
            this.Scroller.scrollLeft = this.GetScroll(this.Scroller.scrollLeft, this.widthScroller, this.widthList, this.options.PauseWidth);

            var oScroll = this;
            this.timer = window.setTimeout(function() { oScroll.Scroll(); }, this.Speed);
        },
        //获取设置滚动数据
        GetScroll: function(iScroll, iScroller, iList, iPause) {
            var oScroll = this, iStep = this.options.Step * this.side;

            if (this.side > 0) {
                if (iScroll >= (iList * 2 - iScroller)) { iScroll -= iList; }
            } else {
                if (iScroll <= 0) { iScroll += iList; }
            }

            this.Speed = this.options.Speed;
            if (iPause > 0) {
                if (Math.abs(this.Pause) >= iPause) {
                    this.Speed = this.options.PauseStep; this.Pause = iStep = 0;
                } else {
                    this.Pause += iStep;
                }
            }

            return (iScroll + iStep);
        },
        //开始
        Start: function() {
            this.Scroll();
        },
        //停止
        Stop: function() {
            clearTimeout(this.timer);
        }
    };