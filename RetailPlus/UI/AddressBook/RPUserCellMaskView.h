//
//  RPUserCellMaskView.h
//  RetailPlus
//
//  Created by lin dong on 14-1-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@protocol RPUserCellMaskViewDelegate <NSObject>
-(void)OnCustomerlist:(UserDetailInfo *)colleague;
@end

@interface RPUserCellMaskView : UIView<MFMessageComposeViewControllerDelegate>
{
    IBOutlet UIView         * _viewFrame;
    IBOutlet UIButton       * _btnImage;
    IBOutlet UIView         * _viewCall;
    IBOutlet UIView         * _viewMessage;
    IBOutlet UIView         * _viewClientsList;
   
    IBOutlet UILabel        * _lbCall;
    IBOutlet UILabel        * _lbMessage;
    IBOutlet UILabel        * _lbClientsList;
    IBOutlet UIImageView    * _ivLock;
    
    
    CGRect                  _rcCall;
    CGRect                  _rcMessage;
    CGRect                  _rcClientsList;
   
}

@property (nonatomic,assign) id<RPUserCellMaskViewDelegate> delegate;
@property (nonatomic,assign) UIViewController   * vcFrame;
@property (nonatomic,assign) UserDetailInfo * colleague;
-(void)Show:(NSString *)strImgUrl Position:(CGPoint)pt;
-(IBAction)OnImage:(id)sender;
-(IBAction)OnCall:(id)sender;
-(IBAction)OnMessage:(id)sender;
-(IBAction)OnClientsList:(id)sender;

@end
