/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


var RP = RP || {};
RP.IL = {};
RP.IL.ApiHost = "http://localhost:56791/{0}";

RP.Util = {
    Request: function (pa) {
        var reg = new RegExp("(^|&)" + pa + "=([^&]*)(&|$)");
        var r = window.location.search.substr(1).match(reg);
        if (r != null)
            return unescape(r[2]);
        return null;
    },

    Query: function (url, data, fun, isa) {
        $.ajax({
            type: "POST",
            url: url,
            async: isa,
            data: $.toJSON(data),
            cache: false,
            contentType: 'application/json',
            dataType: "JSON",
            success: fun
        });
    },
    //scale_space: 20,
    //end_scale: 100,

    GetScaleValue: function (d, n) {
        d = Math.ceil(d);
        var l = d.toString().length -1;
        var d2;
        d2 = Math.ceil(d / (10 * l));
        d2 = d2 * (10 * l);
        d3 = Math.ceil(d2 / n);
        return { end_scale: d3 * n, scale_space: d3 };
    }

 
};

RP.DeBug = {
    Track: function (obj) {
        var props = "";
        for (var p in obj) {
            if (typeof (obj[p]) == " function ") {
                obj[p]();
            } else {
                props += p + " = " + obj[p] + " \t ";
            }
        }
        alert(props);
    }
};



String.prototype.format = function (args) {
    if (arguments.length > 0) {
        var result = this;
        if (arguments.length == 1 && typeof (args) == "object") {
            for (var key in args) {
                var reg = new RegExp("({" + key + "})", "g");
                result = result.replace(reg, args[key]);
            }
        }
        else {
            for (var i = 0; i < arguments.length; i++) {
                if (arguments[i] == undefined) {
                    return "";
                }
                else {
                    var reg = new RegExp("({[" + i + "]})", "g");
                    result = result.replace(reg, arguments[i]);
                }
            }
        }
        return result;
    }
    else {
        return this;
    }
};


Date.prototype.format = function (fmt) { //author: meizz 
    var o = {
        "M+": this.getMonth()+1,                 //�·� 
        "d+": this.getDate() ,                    //�� 
        "h+": this.getHours(),                   //Сʱ 
        "m+": this.getMinutes(),                 //�� 
        "s+": this.getSeconds(),                 //�� 
        "q+": Math.floor((this.getMonth() + 3) / 3), //���� 
        "S": this.getMilliseconds()             //���� 
    };
    if (/(y+)/.test(fmt))
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt))
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
};



(function ($) {
    $.toJSON = function (o) {
        if (typeof (JSON) == 'object' && JSON.stringify)
            return JSON.stringify(o); var type = typeof (o); if (o === null)
                return "null"; if (type == "undefined")
                    return undefined; if (type == "number" || type == "boolean")
                        return o + ""; if (type == "string")
                            return $.quoteString(o); if (type == 'object') {
                                if (typeof o.toJSON == "function")
                                    return $.toJSON(o.toJSON()); if (o.constructor === Date()) {
                                        var month = o.getUTCMonth() + 1; if (month < 10) month = '0' + month; var day = o.getUTCDate()(); if (day < 10) day = '0' + day; var year = o.getUTCFullYear(); var hours = o.getUTCHours(); if (hours < 10) hours = '0' + hours; var minutes = o.getUTCMinutes(); if (minutes < 10) minutes = '0' + minutes; var seconds = o.getUTCSeconds(); if (seconds < 10) seconds = '0' + seconds; var milli = o.getUTCMilliseconds(); if (milli < 100) milli = '0' + milli; if (milli < 10) milli = '0' + milli; return '"' + year + '-' + month + '-' + day + 'T' +
                                        hours + ':' + minutes + ':' + seconds + '.' + milli + 'Z"';
                                    }
                                if (o.constructor === Array) {
                                    var ret = []; for (var i = 0; i < o.length; i++)
                                        ret.push($.toJSON(o[i]) || "null"); return "[" + ret.join(",") + "]";
                                }
                                var pairs = []; for (var k in o) {
                                    var name; var type = typeof k; if (type == "number")
                                        name = '"' + k + '"'; else if (type == "string")
                                            name = $.quoteString(k); else
                                            continue; if (typeof o[k] == "function")
                                                continue; var val = $.toJSON(o[k]); pairs.push(name + ":" + val);
                                }
                                return "{" + pairs.join(", ") + "}";
                            }
    }; $.evalJSON = function (src) {
        if (typeof (JSON) == 'object' && JSON.parse)
            return JSON.parse(src); return eval("(" + src + ")");
    }; $.secureEvalJSON = function (src) {
        if (typeof (JSON) == 'object' && JSON.parse)
            return JSON.parse(src); var filtered = src; filtered = filtered.replace(/\\["\\\/bfnrtu]/g, '@'); filtered = filtered.replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, ']'); filtered = filtered.replace(/(?:^|:|,)(?:\s*\[)+/g, ''); if (/^[\],:{}\s]*$/.test(filtered))
                return eval("(" + src + ")"); else
                throw new SyntaxError("Error parsing JSON, source is not valid.");
    }; $.quoteString = function (string) {
        if (string.match(_escapeable)) {
            return '"' + string.replace(_escapeable, function (a)
            { var c = _meta[a]; if (typeof c === 'string') return c; c = a.charCodeAt(); return '\\u00' + Math.floor(c / 16).toString(16) + (c % 16).toString(16); }) + '"';
        }
        return '"' + string + '"';
    }; var _escapeable = /["\\\x00-\x1f\x7f-\x9f]/g; var _meta = { '\b': '\\b', '\t': '\\t', '\n': '\\n', '\f': '\\f', '\r': '\\r', '"': '\\"', '\\': '\\\\' };
})(jQuery);

   // 0.Traffic 客流, 1. TraQty 销售笔数 ,2.ProQty  商品数量 , 3.Amount  销售总额, 4 转换率
var selTypeVal = function ( i) {
    var d1=Math.floor(Math.random() * (300-200+1)+200);
    var d2=Math.floor(Math.random() * ( d1+ 1));
    var d3=Math.floor(Math.random() *(800-100+1)+100);
    var d4=d3* Math.floor(Math.random() * (5000-1500+1)+1500);
    switch (i) {
        case 0:
            return d1;
            break;
        case 1:
            return d2;
            break;
        case 2:
            return d3;
            break;
        case 3:
            return d4;
            break;
        case 4:
            return Math.round(d2/d1*100) ;
            break;
    }
};