//
//  RPPurchaseRecordViewController.h
//  RetailPlus
//
//  Created by zwhe on 13-12-26.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPTaskBaseViewController.h"
#import "RPMainViewController.h"
#import "RPDatePicker.h"
//@protocol RPPurchaseRecordViewControllerDelegate <NSObject>
//-(void)OnModifyPurchaseEnd;
//@end

@interface RPPurchaseRecordViewController : RPTaskBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    BOOL            _bAddFrame;
    RPDatePicker    * _pickDate;
    BOOL            _isAdd;
    NSString        * _strModifyPurchaseId;
    BOOL _bModify;
}
//@property (nonatomic,assign) id<RPPurchaseRecordViewControllerDelegate> delegateModifyPurchase;

@property (strong, nonatomic) CustomerPurchase *record;
@property (nonatomic,assign) Customer        * customer;
@property (strong, nonatomic) IBOutlet UIView *viewBG;
@property (strong, nonatomic) IBOutlet UIView *viewBackground;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIView *view4;
@property (strong, nonatomic) IBOutlet UIView *view5;
@property (strong, nonatomic) IBOutlet UILabel *lbTotalSum;
@property (strong, nonatomic) IBOutlet UILabel *lbSum;
@property (strong, nonatomic) IBOutlet UILabel *lbAverage;
@property (strong, nonatomic) IBOutlet UILabel *lbAver;
@property (strong, nonatomic) IBOutlet UIImageView *ivLeft;
@property (strong, nonatomic) IBOutlet UIImageView *ivRight;
@property (strong, nonatomic) IBOutlet UITableView *tbPurchaseRecord;
@property (nonatomic,assign) id<RPMainViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *ivHeader;
@property (strong, nonatomic) IBOutlet UILabel *lbLinker;
@property (strong, nonatomic) IBOutlet UIImageView *ivVIP;
@property (strong, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) IBOutlet UILabel *lbAddress;
@property (nonatomic,assign) UIViewController * vcFrame;
@property (strong, nonatomic) IBOutlet UIView *viewAddFrame;
@property (strong, nonatomic) IBOutlet UIView *viewAddBG;
@property (strong, nonatomic) IBOutlet UITextField *tfDate;
@property (strong, nonatomic) IBOutlet UITextField *tfProductName;
@property (strong, nonatomic) IBOutlet UITextField *tfUnitPrice;
@property (strong, nonatomic) IBOutlet UITextField *tfAmount;
@property (strong, nonatomic) IBOutlet UITextField *tfQty;
@property (strong, nonatomic) NSArray * recordArray;
@property (strong, nonatomic) IBOutlet UIView *viewLine1;
@property (strong, nonatomic) IBOutlet UIView *viewLine2;
@property (strong, nonatomic) IBOutlet UIView *viewLine3;
@property (strong, nonatomic) IBOutlet UIImageView *ivAdd;
@property (strong, nonatomic) IBOutlet UILabel *lbAdd;
- (IBAction)OnAdd:(id)sender;
- (IBAction)OnSave:(id)sender;

@end
