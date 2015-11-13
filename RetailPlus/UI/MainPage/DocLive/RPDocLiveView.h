//
//  RPDocLiveView.h
//  RetailPlus
//
//  Created by lin dong on 13-11-22.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPDocAllCell.h"
#import "RPDocUnfinishedCell.h"
#import "RPDocSentCell.h"
#import "RPDocImformationView.h"
#import "RPBlockUIAlertView.h"
#import "RefreshView.h"
#import "RPStoreBusinessDelegate.h"
#import "RPDatePicker.h"
#import "RPStoreListView.h"
#import "RPSearch.h"

typedef enum
{
    DocLiveTaskType_Recv,
    DocLiveTaskType_Sent,
    DocLiveTaskType_Unfinish
}DocLiveTaskType;

@protocol RPDocLiveDelegate <NSObject>
-(void)OnForwardDoc:(Document *)doc;
-(void)OnStoreBVisit:(BVisitListModel *)bVisitListModel Store:(StoreDetailInfo *)store ;
@end

@protocol RPDocLiveViewDelegate <NSObject>
-(void)DoDomainSelect;
@end

//@protocol AllDocumentCellDelegate <NSObject>
//-(void)OnDocumentTask:(Document *)doc;
//@end

@interface RPDocLiveView : UIView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DocumentCellDelegate,RefreshViewDelegate,DocUnfinishedCellDelegate,DocSentCellDelegate,RPSearchDelegate>
{
    IBOutlet UITableView            * _tbDocument;
    IBOutlet RPDocImformationView   * _viewInfo;
    IBOutlet UIView                 * _viewFilt;
    IBOutlet UIView                 * _viewContent;
    IBOutlet UITextField            * _tfEndDate;
    IBOutlet UITextField            * _tfStartDate;
    IBOutlet UITextField            * _tfFiltDomain;
    IBOutlet UIButton               * _btnDeleteFiltDomain;
    
//    RPStoreListView                 *_viewStoreList;
    
    NSMutableArray * _arrayDocAll;
    NSArray * _arrayDocUnSent;
    NSMutableArray * _arrayDocSent;
    NSArray * _arrayDocUnfinish;
    
    NSString       * _strLastAllDocId;
    NSString       * _strLastSentDocId;
    
    
    NSInteger        _nExpandCellIndex;
    CGRect           _rcUvBackground;
    
    NSArray * _arraySearchDoc;
    NSArray * _arraySearchUnsent;
    NSArray * _arraySearchSent;
    NSArray * _arraySearchUnfinished;
    DocLiveTaskType      taskType;
    
    
    BOOL _isRecvOnly;
    
    NSTimer *getPointTimer;
    
    RefreshView *_refreshView;
    
//    BOOL isKeyboardShow;
    
    NSArray             * _arrayStore;
    BOOL                _bShowFilt;
    RPDatePicker        * _datePickerStart;
    RPDatePicker        * _datePickerEnd;
   
    RPSearch            * _search;
    BOOL                _bEditingDate;
}

- (IBAction)unfinishedClick:(id)sender;
- (IBAction)receiveClick:(id)sender;
- (IBAction)sentClick:(id)sender;
- (IBAction)clearClick:(id)sender;
- (IBAction)receOnlyClick:(id)sender;
- (void)Reload;
-(void)OnShowDocView;

-(void)OnSelectDomain:(DomainInfo *)domain;
-(void)OnSelectedStore:(StoreDetailInfo *)store;
//@property (strong, nonatomic) id<AllDocumentCellDelegate>allDocumentDelegate;
@property (nonatomic, assign) id<RPDocLiveDelegate> delegate;
@property (nonatomic, assign) id<RPDocLiveViewDelegate> delegateCtrl;
@property (nonatomic, assign) id<RPStoreBusinessDelegate> delegateStore;

@property (strong,nonatomic) UIViewController * viewController;

@property (strong, nonatomic) IBOutlet UILabel *lbReceived;
@property (strong, nonatomic) IBOutlet UILabel *lbSent;
@property (strong, nonatomic) IBOutlet UILabel *lbUnfinished;
@property (strong, nonatomic) IBOutlet UIView *uvBackground;
//@property (strong,nonatomic)  RPDocAllCell *receCell;
@property (strong, nonatomic) IBOutlet UIImageView *ivTopbar;
@property (strong, nonatomic) IBOutlet UIButton *btRecOnly;
@property (strong, nonatomic) IBOutlet UIView *uvReceOnly;
@property (strong, nonatomic) IBOutlet UIView *uvSearch;
@property (strong, nonatomic) IBOutlet UIImageView *ivDocuments;
@property (strong, nonatomic) IBOutlet UIImageView *ivPublish;
@property (strong, nonatomic) IBOutlet UIImageView *ivUnfinished;
@property (strong, nonatomic) IBOutlet UIView *uvBGround;

@property (strong, nonatomic) DomainInfo          * filtDomain;
@property (strong, nonatomic) StoreDetailInfo     * filtStore;

@end
