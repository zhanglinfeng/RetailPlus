/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
RP.IL.Comparison = {
    Init: function(ridL, ridR, LS, RS) {
        this.BaseSeting = this.BaseSeting || {};
        this.BaseSeting.se = RP.Util.Request("se") || "";
        this.BaseSeting.doid = RP.Util.Request("doid") || "";
        this.BaseSeting.w = parseInt(RP.Util.Request("w")) || 400;
        this.BaseSeting.h = parseInt(RP.Util.Request("h")) || 300;
        this.BaseSeting.rt = parseInt(RP.Util.Request("rt")) || 0;// 0 Year,1 Season,2 Month,3 Week,4 Day
        this.BaseSeting.rd = new Date();
        this.BaseSeting.rd.setFullYear(parseInt(RP.Util.Request("ry")));
        this.BaseSeting.rd.setMonth(parseInt(RP.Util.Request("rm")));
        this.BaseSeting.rd.setDate(parseInt(RP.Util.Request("rd")));
        this.BaseSeting.ry = (parseInt(RP.Util.Request("ry")));
        this.BaseSeting.ri = parseInt(RP.Util.Request("ri")) || 0;
        this.BaseSeting.ct1 = parseInt(RP.Util.Request("ct1")) || 0;
        this.BaseSeting.ct2 = parseInt(RP.Util.Request("ct2")) || 0;
        this.BaseSeting.ot1 = parseInt(RP.Util.Request("ot1")) || 0;
        this.BaseSeting.ot2 = parseInt(RP.Util.Request("ot2")) || 0;  // 0.Traffic 客流, 1. TraQty 销售笔数 ,2.ProQty  商品数量 , 3.Amount  销售总额, 4 转换率
        this.ridL = ridL;
        this.ridR = ridR;
        this.SetChart(LS, RS);
    },
    SetChart: function(LS, RS) {
        this.ChartLSet = this.ChartLSet || {
            padding: 0,
            width: 100,
            border: {width: 0},
            label: {fontsize: 0, height: 0, color: '#666666'}
        };
        this.ChartRSet = this.ChartRSet || {
            padding: 0,
            width: 100,
            border: {width: 0},
            label: {fontsize: 0, height: 0, color: '#666666'}
        };
        this.ChartLSet.align = 'left';
        this.ChartLSet.fontsize = 11;
        this.ChartRSet.fontsize = 11;
        this.ChartLSet.border = {width: 0};
        this.ChartRSet.border = {width: 0};
        this.ChartLSet.offsety = 5;
        this.ChartRSet.offsety = 5;
        this.ChartRSet.background_color
                = this.ChartLSet.background_color = '#ccc';
        this.ChartLSet.text_space = 40;
        this.ChartRSet.text_space = 40;
        this.ChartRSet.align = 'Right';
        this.ChartLSet.coordinate = this.ChartLSet.coordinate || {
            background_color: null,
            axis: {
                width: [0, 0, 2, 1]
            },
            scale: []
        };
        this.ChartRSet.coordinate = this.ChartRSet.coordinate || {
            background_color: null,
            axis: {
                width: [0, 0, 2, 1]
            },
            scale: []
        };
        this.ChartLSet.coordinate.width
                = this.ChartRSet.coordinate.width
                = this.ChartRSet.width
                = this.ChartLSet.width
                = this.BaseSeting.w / 2;
        this.ChartRSet.height
                = this.ChartLSet.height
                = this.BaseSeting.h;
        this.ChartLSet.render = this.ridL;
        this.ChartRSet.render = this.ridR;

        this.ChartRSet.coordinate.scale.push(this.ScaleSet('right', 0, RS.end_scale, RS.scale_space,
                {
                    width: 16,
                    fontsize: 11,
                    color: '#000',
                    offsety: 5,
                    offsetx: -25,
                    textAlign: 'right',
                }
        ));
        this.ChartLSet.coordinate.scale.push(this.ScaleSet("left", 0, LS.end_scale, LS.scale_space,
                {
                    width: 16,
                    fontsize: 11,
                    color: '#000',
                    offsety: 5,
                    offsetx: 6,
                    textAlign: "left",
                }
        ));

    },
    ScaleSet: function(rol, sts, es, ss, lab) {
        return {
            position: rol,
            scale_width: 0,
            scaleAlign: rol,
            start_scale: sts,
            end_scale: es,
            scale_space: ss,
            scale_enable: true,
            label: lab,
            listeners: {
                parseText: function(t, x, y) {
                    if (t == 0) {
                        return {text: ""};
                    }
                    return {text: t}
                }
            }
        };
    },
    RenderChart: function() {

        this.ChartL = new iChart.Column2D(this.ChartLSet);
        this.ChartR = new iChart.Column2D(this.ChartRSet);
        this.ChartR.draw();
        this.ChartL.draw();
    }
};

$(function() {
    var ad = RP.IL.ApiHost.format("KPIReport/GetKPIChartData");
    var rd = new Date();
    rd.setFullYear(parseInt(RP.Util.Request("ry")));
    rd.setMonth(parseInt(RP.Util.Request("rm")) - 1);
    rd.setDate(parseInt(RP.Util.Request("rd")));


    var QM = {
        DomainId: RP.Util.Request("doid") || "B6A1CBCD-DB4A-4B66-B219-091BBF540390",
        Token: RP.Util.Request("se") || "354FD0C9-CFE9-4996-92AA-5919C8121B7B",
        RangeType: parseInt(RP.Util.Request("rt")) || 0,
        RangeDate: rd.format("yyyy-MM-dd hh:mm:ss") || "2014-02-28 16:44:46",
        RangeIndex: parseInt(RP.Util.Request("ri")) || 1,
        RangeYear: parseInt(RP.Util.Request("ry")) || 2014,
        CompareType1: parseInt(RP.Util.Request("ct1")) || 0,
        CompareType2: parseInt(RP.Util.Request("ct2")) || 0,
    };

    var Ld = [];
    var Rd = [];

    for (var i = 0; i < 3; i++) {
        Rd.push(
                {
                    value: 0, color: '#666'
                }
        );
        Ld.push(
                {
                    value: 0, color: '#666'
                }
        );
    }
    ;

    (function() {
        // 0.Traffic 客流, 1. TraQty 销售笔数 ,2.ProQty  商品数量 , 3.Amount  销售总额, 4 转换率
        var lld = 10;
        var lrd = 10;

        if (parseInt(RP.Util.Request("ot1")) == 4) {
            lld = 100
        }

        if (parseInt(RP.Util.Request("ot2")) == 4) {
            lrd = 100;
        }

        for (var i = 0; i < 3; i++) {

            var lv = selTypeVal( parseInt(RP.Util.Request("ot1")));
            Ld[i] = {value: lv, color: selColor(i)};
            if (lv > lld)
                lld = lv;

        }

        for (var i = 0; i < 3; i++) {

            var rv = selTypeVal(parseInt(RP.Util.Request("ot2")));
            Rd[i] = {value: rv, color: selColor(i)}
            if (rv > lrd)
                lrd = rv;

        }

        var sl = 5;
        var LS = RP.Util.GetScaleValue(lld, sl);
        var RS = RP.Util.GetScaleValue(lrd, sl);

        RP.IL.Comparison.Init('canvasDiv', 'canvasDiv2', LS, RS);
        RP.IL.Comparison.ChartLSet.data = Ld;
        RP.IL.Comparison.ChartRSet.data = Rd;
        RP.IL.Comparison.RenderChart();

    })();



});

var selColor = function(i) {
    switch (i) {
        case 0:
            return '#e11e00'
            break;
        case 1:
            return '#7f7f7f'
            break;
        case 2:
            return '#3269af'
            break;
    }
};


// 0.Traffic 客流, 1. TraQty 销售笔数 ,2.ProQty  商品数量 , 3.Amount  销售总额, 4 转换率


