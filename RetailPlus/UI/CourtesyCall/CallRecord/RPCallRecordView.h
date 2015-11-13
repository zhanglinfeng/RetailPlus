//
//  RPCallRecordView.h
//  RetailPlus
//
//  Created by lin dong on 14-3-14.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPCourtesyCallRecordView.h"
#import "UIMarqueeLabel.h"
#import "RPStoreListView.h"
#import "PieChartView.h"

@protocol RPCallRecordListViewDelegate<NSObject>
-(void)endCallRecordList;
@end

@interface RPCallRecord : NSObject
@property(nonatomic,retain) NSString * strKey; //Mary Deng,Clair Wu,After Sales Call
@property(nonatomic) NSInteger         nCount;
@end

@interface RPCallRecordList : NSObject
@property (nonatomic,retain) NSMutableArray * arrayCustomer; //RPCallRecord
@property (nonatomic,retain) NSMutableArray * arrayCalledBy; //RPCallRecord
@property (nonatomic,retain) NSMutableArray * arrayPurpose;  //RPCallRecord
@end

@interface RPCallRecordView : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RPCallRecordViewTORecordListDelegate,RPStoreSelectDelegate,PieChartDelegate>
{
    IBOutlet UIView       * _viewFrame;
    IBOutlet UITableView  * _tbRecord;
    
    NSMutableArray        * _arrayRecord;//所有的回访记录数组
    NSMutableArray        * _arrayRecordShow;//筛选出来的回访记录数组，用于tableview显示
    IBOutlet RPCourtesyCallRecordView *_viewCallRecord;
    BOOL _bCallRecord;
    BOOL _bStoreList;
    
    IBOutlet UILabel *_lbYear;
    
    IBOutlet UILabel *_lbMonth;
    IBOutlet UIMarqueeLabel *_lbStoreName;
    IBOutlet UIMarqueeLabel *_lbAddress;
    IBOutlet UILabel *_lbResultCount;
    IBOutlet UIButton *_btMenu1;
    IBOutlet UIButton *_btMenu2;
    IBOutlet UIView *_viewMenu1;
    IBOutlet UIView *_viewMenu2;
    IBOutlet UITextField *_tfStaff;
    IBOutlet UITextField *_tfCustomer;
    IBOutlet UITextField *_tfPurpose;
    IBOutlet UIImageView *_viewfoot;
    UILabel *_label;
    IBOutlet UIButton *_btDeleteStaff;
    IBOutlet UIButton *_btDeleteCustomer;
    IBOutlet UIButton *_btDeletePurpose;
    IBOutlet UIView     *_viewChartFrame;
    PieChartView        *_viewChart;
    
    RPCallRecordList        * _listRecord;//所有的数组对象
    RPCallRecordList        * _listRecordShow;//筛选出来的数组对象，用于饼状图显示
    
    RPCallRecord *_callRecord;
    RPDatePicker *_pickDate;
    IBOutlet UITextField *_tfDate;
    NSDate               *_date;
    NSInteger            _indexCalledBy;
    NSInteger            _indexCustomer;
    NSInteger            _indexPurpose;
    NSInteger            _nChartType;
    RPStoreListView             * _viewStoreList;
    NSMutableArray      * _arrayColor;
    IBOutlet UILabel *_lbType;
    IBOutlet UIView *_viewData;
    IBOutlet UILabel *_lbCurrent;
    IBOutlet UILabel *_lbCurrentData;
    IBOutlet UILabel *_lbTotal;
    NSArray *_arrayAnalysisType;
    IBOutlet UIImageView *_ivTriangle1;
    IBOutlet UIImageView *_ivTriangle2;
    
    BOOL                _bHideFailed;
    IBOutlet UIButton   * _btnHideFailed;
}

@property(nonatomic,assign)id<RPCallRecordListViewDelegate>delegate;
@property (nonatomic,retain) UserDetailInfo * user;
@property(nonatomic,strong)NSArray *arrayType;
@property(nonatomic,assign)int entrance;//3代表从自己记录进入，4代表从别人记录进入该界面
@property (nonatomic,assign) StoreDetailInfo * storeSelected;
-(BOOL)OnBack;

- (IBAction)OnHelp:(id)sender;
- (IBAction)OnQuit:(id)sender;
- (IBAction)OnSelectDate:(id)sender;
- (IBAction)OnSelectStore:(id)sender;
- (IBAction)OnMenu1:(id)sender;
- (IBAction)OnMenu2:(id)sender;
- (IBAction)OnDeleteCustomer:(id)sender;
- (IBAction)OnDelectCalledBy:(id)sender;
- (IBAction)OnDeletePurpose:(id)sender;
- (IBAction)OnSelectType:(id)sender;
- (IBAction)OnNext:(id)sender;
- (IBAction)OnHideFailed:(id)sender;

-(void)ReloadData;

-(RPCallRecordList *)CalcRecordList:(NSMutableArray *)arrayList;
-(void)FiltRecord:(NSString *)strCustomer CalledBy:(NSString *)strCalledBy Purpose:(NSString *)strPurpose HideFailed:(BOOL)bHideFailed;

@end
