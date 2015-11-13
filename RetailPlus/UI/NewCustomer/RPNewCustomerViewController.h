//
//  RPNewCustomerViewController.h
//  RetailPlus
//
//  Created by zwhe on 13-12-26.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPTaskBaseViewController.h"
#import "RPMainViewController.h"
@interface RPNewCustomerViewController : RPTaskBaseViewController<UITextFieldDelegate>
@property (nonatomic,assign) id<RPMainViewControllerDelegate> delegate;
@property (nonatomic,assign) UIViewController * vcFrame;
@property (strong, nonatomic) IBOutlet UIView *viewBackground;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIScrollView *svFrame;
@property (strong, nonatomic) IBOutlet UITextField *tfName;
@property (strong, nonatomic) IBOutlet UITextField *tfPhoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *tfWONumber;
@property (strong, nonatomic) IBOutlet UITextField *tfDate;
@property (strong, nonatomic) IBOutlet UITextField *tfProduct;
@property (strong, nonatomic) IBOutlet UITextField *tfProductID;
@property (strong, nonatomic) IBOutlet UITextField *tfUnitPrice;
@property (strong, nonatomic) IBOutlet UITextField *tfQty;
@property (strong, nonatomic) IBOutlet UITextField *tfTotal;
- (IBAction)OnOK:(id)sender;
@end
