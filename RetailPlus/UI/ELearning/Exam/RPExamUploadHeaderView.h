//
//  RPExamUploadHeaderView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-24.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RPExamUploadHeaderViewDelegate
-(void)OnUpLoadAll;
-(void)OnExpand;
@end
@interface RPExamUploadHeaderView : UITableViewHeaderFooterView
{
    IBOutlet UIButton *_btUpload;
    IBOutlet UILabel *_lbUpload;
    IBOutlet UILabel *_lbResuit;
    
//    IBOutlet UIButton *_btExpand;
}
@property(nonatomic,weak)id<RPExamUploadHeaderViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UILabel *lbPaperCount;
@property (strong, nonatomic) IBOutlet UIImageView *ivTriangle;
- (IBAction)OnUpLoad:(id)sender;
- (IBAction)OnExpan:(id)sender;
@end
