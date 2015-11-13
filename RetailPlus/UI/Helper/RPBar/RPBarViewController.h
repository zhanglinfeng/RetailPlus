//
//  RPBarViewController.h
//  TestBarCode
//
//  Created by lin dong on 14-4-30.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "RPBarInputView.h"

@protocol RPBarViewControllerDelegate <NSObject>
-(void)ScanedCode:(UIViewController *)ctrl Code:(NSString *)strCode isCurrentScan:(BOOL)bScaned;
@end

@interface RPBarViewController : UIViewController<ZBarReaderViewDelegate,RPBarInputViewDelegate,ZBarReaderDelegate>
{
    NSTimer                 * _timer;
    NSInteger               _num;
    NSInteger               _nLineWidth;
    NSInteger               _nBeginPos;
    NSInteger               _nEndPos;
    NSInteger               _nLeft;
    
    BOOL                    _upOrdown;
    BOOL                    _bTorchOn;
    BOOL                    _bDismissed;
    UIImageView             * _ivLine;
    
    IBOutlet UILabel        * _lbTip;
    IBOutlet UIView         * _viewMask;
    IBOutlet UIImageView    * _ivMask;
    IBOutlet RPBarInputView * _viewInput;
    IBOutlet UIButton *_btLight;
}

@property (nonatomic,assign) UIViewController * vcFrame;
@property (nonatomic,assign) id<RPBarViewControllerDelegate> delegate;
@property (nonatomic,retain) IBOutlet ZBarReaderView * viewReader;

-(void)dismiss;

-(IBAction)OnBack:(id)sender;

-(IBAction)OnPic:(id)sender;
-(IBAction)OnInput:(id)sender;
-(IBAction)OnTorch:(id)sender;

@end
