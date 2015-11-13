//
//  RPLogBookCommentView.h
//  RetailPlus
//
//  Created by lin dong on 14-3-5.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPLogBookCommentViewDelegate<NSObject>
    -(void)PostCommentEnd;
@end

@interface RPLogBookCommentView : UIView
{
    IBOutlet UIView      * _viewBackGroud;
    IBOutlet UIView      * _viewFrame;
    IBOutlet UITextField * _tfComment;
}

@property (nonatomic,assign) id<RPLogBookCommentViewDelegate> delegate;
@property (nonatomic,retain) LogBookDetail                  * detail;
@property (nonatomic,assign) StoreDetailInfo                * storeSelected;
-(IBAction)OnPostComment:(id)sender;

-(void)ShowCommentView;
@end
