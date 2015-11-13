/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
RP.IL.Combining = {
    Init: function(rid, LS, MS) {
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
        this.BaseSeting.ct = parseInt(RP.Util.Request("ct1")) || 0;
        this.BaseSeting.ot1 = parseInt(RP.Util.Request("ot1")) || 0;
        this.BaseSeting.ot2 = parseInt(RP.Util.Request("ot2")) || 0;  // 0.Traffic 客流, 1. TraQty 销售笔数 ,2.ProQty  商品数量 , 3.Amount  销售总额, 4 转换率
        this.rid = rid;
        this.SetChart(LS, MS)
    },
    SetChart: function(LS, MS) {
        this.ChartMSet = this.ChartMSet || {
            padding: '10,20,10,25',
            align: 'center',
            scaleAlign: 'left',
            background_color: '#ccc',
            text_space: 0,
            fontsize: 8,
            offsetx: 0,
            offsety: -8,
            sub_option: {
                label: false,
                point_size: 2
            },
            border: {width: 0},
            coordinate: {
                background_color: null,
                grid_color: '#c0c0c0',
                axis: {
                    width: [0, 2, 1, 2]
                },
                scale: [{
                        position: 'left',
                        text_space: 0,
                        start_scale: 0,
                        end_scale: MS.end_scale,
                        scale_space: MS.scale_space,
                        scale_enable: false,
                        label: {
                            width: 16,
                            fontsize: 11,
                            color: '#666666',
                            offsetx: -16,
                            textAlign: "right"
                        },
                        listeners: {
                            parseText: function(t, x, y) {
                                if (t == 0) {
                                    return {text: ""};
                                }
                                return {text: t};
                            }
                        }
                    }

                ]
            }

        };

        this.ChartLSet = {
            // point_space: 50,
            padding: '10,20,10,25',
            z_index: 1000,
            scaleAlign: 'right',
            text_space: 0,
            fontsize: 8,
            offsetx: 0,
            offsety: -8,
            border: {width: 0},
            sub_option: {
                label: false
            },
            coordinate: {
                background_color: null,
                grid_color: '#c0c0c0',
                gridlinesVisible: false,
                axis: {
                    width: [0, 0, 1, 2]
                },
                scale: [{
                        position: 'right',
                        text_space: 0,
                        start_scale: 0,
                        scale_space: LS.scale_space,
                        end_scale: LS.end_scale,
                        scale_enable: false,
                        scale_size: 0,
                        scaleAlign: 'right',
                        label: {
                            width: 16,
                            fontsize: 11,
                            color: '#666666',
                            offsetx: 0,
                            textAlign: 'left'
                        },
                        listeners: {
                            parseText: function(t, x, y) {
                                if (t == 0) {
                                    return {text: ""};
                                }
                                return {text: t}
                            }
                        }

                    }

                ]
            }
        };

        this.ChartLSet1 = {
            // point_space: 50,
            padding: '10,20,10,25',
            z_index: 1000,
            scaleAlign: 'right',
            text_space: 0,
            fontsize: 8,
            offsetx: 0,
            offsety: -8,
            border: {width: 0},
            sub_option: {
                label: false
            },
            coordinate: {
                background_color: null,
                gridlinesVisible: false,
                axis: {
                    width: 0
                },
                scale: [{
                        position: 'right',
                        text_space: 0,
                        start_scale: 0,
                        scale_space: LS.scale_space,
                        end_scale: LS.end_scale,
                        scale_enable: false,
                        scale_size: 0,
                        scaleAlign: 'right',
                        label: {
                            width: 16,
                            fontsize: 11,
                            color: '#666666',
                            offsetx: 0,
                            textAlign: 'left'
                        },
                        listeners: {
                            parseText: function(t, x, y) {
                                if (t == 0) {
                                    return {text: ""};
                                }
                                return {text: t}
                            }
                        }

                    }
                ]
            }
        };

        this.ChartMSet.render = this.rid;
        this.ChartMSet.width
                = this.BaseSeting.w;
        this.ChartMSet.coordinate.width = this.BaseSeting.w - 40;
        this.ChartLSet.coordinate.width = this.BaseSeting.w - 40;
        this.ChartLSet1.coordinate.width = this.BaseSeting.w - 40;
        this.ChartMSet.height
                = this.ChartLSet.height
                = this.ChartLSet1.height
                = this.BaseSeting.h;
        this.ChartMSet.coordinate.height = this.BaseSeting.h - 24;
        this.ChartLSet.coordinate.height = this.BaseSeting.h - 24;
        this.ChartLSet1.coordinate.height = this.BaseSeting.h - 24;


    },
    RenderChart: function() {
        this.ChartM = new iChart.ColumnMulti2D(this.ChartMSet);
        this.ChartLSet.point_space = this.ChartM.get('column_width') * 2 + this.ChartM.get('column_space') - this.ChartM.get('column_width') / 8;
        this.ChartLSet1.point_space = this.ChartM.get('column_width') * 2 + this.ChartM.get('column_space') + this.ChartM.get('column_width') / 8;

        this.ChartLA = new iChart.LineBasic2D(this.ChartLSet);
        // this.ChartLSet1.coordinate = this.ChartM.coo;
        this.ChartLB = new iChart.LineBasic2D(this.ChartLSet1);

        this.ChartM.plugin(this.ChartLA);
        this.ChartM.plugin(this.ChartLB);
        this.ChartM.draw();
    }
};

$(function() {
    var ad = RP.IL.ApiHost.format("KPIReport/GetTrendChartData");
    var rd = new Date();
    rd.setFullYear(parseInt(RP.Util.Request("ry")));
    rd.setMonth(parseInt(RP.Util.Request("rm")) - 1);
    rd.setDate(parseInt(RP.Util.Request("rd")));

    var rd2 = new Date();
    rd2.setFullYear(parseInt(RP.Util.Request("ry")));
    rd2.setMonth(parseInt(RP.Util.Request("rm")) - 1);
    rd2.setDate(parseInt(RP.Util.Request("rd")));

    var QM = {
        DomainId: RP.Util.Request("doid") || "B6A1CBCD-DB4A-4B66-B219-091BBF540390",
        Token: RP.Util.Request("se") || "354FD0C9-CFE9-4996-92AA-5919C8121B7B",
        RangeType: parseInt(RP.Util.Request("rt")) || 0, // 0 Year,1 Season,2 Month,3 Week,4 Day
        RangeDate: rd.format("yyyy-MM-dd hh:mm:ss") || "2014-02-28 16:44:46",
        RangeIndex: parseInt(RP.Util.Request("ri")) || 1,
        // CompareType: parseInt(RP.Util.Request("ct1")) || 0,
        RangeYear: parseInt(RP.Util.Request("ry")) || 2014
    };


    var QM2 = {
        DomainId: RP.Util.Request("doid"),
        Token: RP.Util.Request("se"),
        RangeType: parseInt(RP.Util.Request("rt")) || 0, // 0 Year,1 Season,2 Month,3 Week,4 Day
        RangeDate: rd2.format("yyyy-MM-dd hh:mm:ss") || "2014-02-28 16:44:46",
        RangeIndex: parseInt(RP.Util.Request("ri")) || 1,
        // CompareType: parseInt(RP.Util.Request("ct1")) || 0,
        RangeYear: parseInt(RP.Util.Request("ry")) || 2014
    }


    var Ld = [];
    var Md = [];
    var Ld2 = [];
    var Md2 = [];
    var Labels = [];

    var dl = 0;
    var dlc = 0;

    // 0 Year,1 Season,2 Month,3 Week,4 Day
    switch (parseInt(RP.Util.Request("rt"))) {
        case 0:
            dl = 12;
            dlc = 2;
            if (parseInt(RP.Util.Request("ct1")) == 0) {
                rd2.setFullYear(rd2.getFullYear() - 1);
                QM2.RangeYear = QM2.RangeYear - 1;
            }
            break;
        case 1:
            dl = 14;
            dlc = 2;
            switch (parseInt(RP.Util.Request("ct1"))) {
                case 0:
                    var rm = parseInt(RP.Util.Request("rm"));
                    if ((rm - 3) <= 0 || QM2.RangeIndex - 1 <= 0) {
                        rd2.setFullYear(rd2.getFullYear() - 1);
                        QM2.RangeYear = QM2.RangeYear - 1;
                        QM2.RangeIndex = 4;
                    } else {
                        rd2.setMonth(rd2.getMonth() - 3);
                        QM2.RangeIndex = QM2.RangeIndex - 1;
                    }
                    break;
                case 1:
                    rd2.setFullYear(rd2.getFullYear() - 1);
                    QM2.RangeYear = QM2.RangeYear - 1;
                    break;
            }
            break;
        case 2: //2 Month
            dl = 32;
            dlc = 4;
            switch (parseInt(RP.Util.Request("ct1"))) {
                case 0:
                    var rm = parseInt(RP.Util.Request("rm"));
                    if ((rm - 1) <= 0 || QM2.RangeIndex - 1 <= 0) {
                        rd2.setFullYear(rd2.getFullYear() - 1);
                        QM2.RangeYear = QM2.RangeYear - 1;
                        QM2.RangeIndex = 12;
                        rd2.setMonth(11);
                    } else {
                        rd2.setMonth(rd2.getMonth() - 1);
                        QM2.RangeIndex = QM2.RangeIndex - 1;
                    }
                    break;
                case 1:
                    rd2.setFullYear(rd2.getFullYear() - 1);
                    QM2.RangeYear = QM2.RangeYear - 1;
                    break;
            }
            break;
        case 3: //3 Week
            dl = 7;
            dlc = 1;
            switch (parseInt(RP.Util.Request("ct1"))) {
                case 0:
                    var rd = parseInt(RP.Util.Request("rd"));
                    rd2.setTime(rd2.getTime() - 604800000);
                    if ((QM2.RangeIndex - 1) <= 0) {
                        rd2.setFullYear(rd2.getFullYear() - 1);
                        QM2.RangeYear = QM2.RangeYear - 1;
                        QM2.RangeIndex = 53;
                    } else {
                        QM2.RangeIndex = QM2.RangeIndex - 1;
                    }
                    break;
                case 1:
                    rd2.setFullYear(rd2.getFullYear() - 1);
                    QM2.RangeYear = QM2.RangeYear - 1;
                    break;
            }
            ;
            break;
        default:
            dl = 15;
            dlc = 3;
            switch (parseInt(RP.Util.Request("ct1"))) {
                case 0:
                    rd2.setDate(parseInt(RP.Util.Request("rd")) - 1);
                    //QM2.RangeIndex = QM2.RangeIndex - 1;
                    break;
                case 1:
                    rd2.setTime(rd2.getTime() - 604800000);
                    break;
                case 2:
                    var rm = parseInt(RP.Util.Request("rm"));
                    if ((rm - 1) <= 0 || QM2.RangeIndex - 1 <= 0) {
                        rd2.setFullYear(rd2.getFullYear() - 1);
                        QM2.RangeYear = QM2.RangeYear - 1;
                        rd2.setMonth(11);
                    } else {
                        rd2.setMonth(rd2.getMonth() - 1);
                    }
                    break;
                case 3:
                    rd2.setFullYear(rd2.getFullYear() - 1);
                    QM2.RangeYear = QM2.RangeYear - 1;
                    break;
            }
            ;
            break;
    }

    QM2.RangeDate = rd2.format("yyyy-MM-dd hh:mm:ss");

    for (var i = 0; i < dl; i++) {
        var fd = QM.RangeType == 4 ? 8 : 1;
        if ((i + 1) % dlc == 0) {
            //Md[i] = { value: 0, color: '#4572a7', name: i + 1 };
            Labels[i] = i + fd;
        } else {
            //Md[i] = { value: 0, color: '#4572a7', name: "" };
            Labels[i] = " ";
        }

        Md[i] = 0;
        Ld[i] = 0;
        Md2[i] = 0;
        Ld2[i] = 0;
    }
    ;

    (function(data) {
        // 0.Traffic 客流, 1. TraQty 销售笔数 ,2.ProQty  商品数量 , 3.Amount  销售总额, 4 转换率
        // 0 Year,1 Season,2 Month,3 Week,4 Day
        var lld = 10;
        var lmd = 10;
        if (parseInt(RP.Util.Request("ot2")) == 4) {
            lld = 100
        }

        if (parseInt(RP.Util.Request("ot1")) == 4) {
            lmd = 100;
        }

        var f = QM.RangeType == 4 ? 8 : 1;
        var lv2;
        var v2;
        for (var i = 0; i < dl; i++) {
            lv = Ld[i] = selTypeVal(parseInt(RP.Util.Request("ot2")));
            v = Md[i] = selTypeVal(parseInt(RP.Util.Request("ot1")));
            if (lv > lld)
                lld = lv;
            if (v > lmd)
                lmd = v;
        }
        (function(data2) {
            var f2 = QM.RangeType == 4 ? 8 : 1;
            var lv2;
            var v2;
            for (var i = 0; i < dl; i++) {
                lv2 = Ld2[i] = selTypeVal(parseInt(RP.Util.Request("ot2")));

                v2 = Md2[i] = selTypeVal(parseInt(RP.Util.Request("ot1")));
                if (lv2 > lld)
                    lld = lv2;
                if (v2 > lmd)
                    lmd = v2;
            }
            ;
        })();
        var sl = 5;
        var LS = RP.Util.GetScaleValue(lld, sl);
        var MS = RP.Util.GetScaleValue(lmd, sl);

        RP.IL.Combining.Init('canvasDiv', LS, MS);

        RP.IL.Combining.ChartLSet.data = [
            {
                value: Ld,
                color: '#e85252',
                line_width: 2
            }
        ];
        RP.IL.Combining.ChartLSet1.data = [
            {
                value: Ld2,
                color: '#faaa37',
                line_width: 2
            }
        ];
        RP.IL.Combining.ChartMSet.data = [
            {
                value: Md,
                color: '#14b4b9'
            }, {
                value: Md2,
                color: '#3269af'
            }
        ];
        RP.IL.Combining.ChartMSet.labels = Labels;
        RP.IL.Combining.RenderChart();

    })();



});

