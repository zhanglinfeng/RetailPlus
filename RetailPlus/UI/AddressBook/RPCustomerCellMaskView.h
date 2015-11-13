//
//  RPCustomerCellMaskView.h
//  RetailPlus
//
//  Created by lin dong on 13-12-24.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@protocol RPCustomerCellMaskViewDelegate <NSObject>
    -(void)OnEditCustomer:(Customer *)customer;
    -(void)OnCustomerPurchase:(Customer *)customer;
@end

@interface RPCustomerCellMaskView : UIView<MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIView         * _viewFrame;
    IBOutlet UIButton       * _btnImage;
    IBOutlet UIView         * _viewCall;
    IBOutlet UIView         * _viewMessage;
    IBOutlet UIView         * _viewEdit;
    IBOutlet UIView         * _viewPurchase;
    IBOutlet UILabel        * _lbCall;
    IBOutlet UILabel        * _lbMessage;
    IBOutlet UILabel        * _lbEdit;
    IBOutlet UILabel        * _lbPurchase;
    IBOutlet UIButton       *_btEdit;
    IBOutlet UIButton       *_btPurchase;
    CGRect                  _rcCall;
    CGRect                  _rcMessage;
    CGRect                  _rcEdit;
    CGRect                  _rcPurchase;
}

@property (nonatomic,assign) id<RPCustomerCellMaskViewDelegate> delegate;
@property (nonatomic,assign) UIViewController   * vcFrame;

@property (nonatomic,assign) Customer * customer;

-(void)Show:(NSString *)strImgUrl Position:(CGPoint)pt;

-(IBAction)OnImage:(id)sender;
-(IBAction)OnCall:(id)sender;
-(IBAction)OnMessage:(id)sender;
-(IBAction)OnEdit:(id)sender;
-(IBAction)OnPurchase:(id)sender;
@end
