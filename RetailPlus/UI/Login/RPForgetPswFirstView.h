//
//  RPForgetPswFirstView.h
//  RetailPlus
//
//  Created by lin dong on 13-11-11.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPForgetPswFirstViewDelegate <NSObject>
-(void)OnByMobilePhone:(NSString *)strNumber;
-(void)OnByEmail:(NSString *)strNumber;
@end

@interface RPForgetPswFirstView : UIView<UITextFieldDelegate>
{
    IBOutlet UIView         * _viewTextFrame;
    
}
@property (strong, nonatomic) IBOutlet UITextField *tfNumber;

@property(nonatomic,retain) id<RPForgetPswFirstViewDelegate> delegate;

-(IBAction)OnMobile:(id)sender;
-(IBAction)OnEmail:(id)sender;

@end
