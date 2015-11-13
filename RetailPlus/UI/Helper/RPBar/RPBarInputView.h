//
//  RPBarInputView.h
//  TestBarCode
//
//  Created by lin dong on 14-5-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPBarInputViewDelegate<NSObject>
-(void)SearchEnd:(NSString *)strCode;
@end

@interface RPBarInputView : UIView
{
    IBOutlet UIView      * _viewBackGroud;
    IBOutlet UIView      * _viewFrame;
    IBOutlet UITextField * _tfComment;
}

@property (nonatomic,assign) IBOutlet id<RPBarInputViewDelegate> delegate;

-(IBAction)OnSearch:(id)sender;
-(void)ShowCommentView;
@end
