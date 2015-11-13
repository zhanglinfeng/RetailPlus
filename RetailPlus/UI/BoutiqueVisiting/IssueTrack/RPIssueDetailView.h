//
//  RPIssueDetailView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-9-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPIssueDetailView : UIView
{
    IBOutlet UIView *_viewTitle;
    IBOutlet UIView *_viewDesc;
    IBOutlet UIButton *_btPic1;
    IBOutlet UIButton *_btPic2;
    IBOutlet UIButton *_btPic3;
    IBOutlet UITextField *_tfTitle;
    IBOutlet UITextView *_tvDesc;
}
@property (nonatomic,retain) InspIssue          * issue;
@end
