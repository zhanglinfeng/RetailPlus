//
//  RPExamHeaderview.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-24.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RPSDKELDefine.h"
@protocol RPExamHeaderviewDelegate
-(void)OnExpandExamHeader:(RPELPaperList*)paperList;
@end
@interface RPExamHeaderview : UITableViewHeaderFooterView
{
    IBOutlet UILabel *_lbType;
    
    
    
}
@property(nonatomic,weak)id<RPExamHeaderviewDelegate>delegate;
@property(nonatomic,strong)RPELPaperList *paperList;
@property(nonatomic,strong)IBOutlet UIImageView *ivTriangle;
//@property(nonatomic,assign)NSInteger section;
- (IBAction)OnExpand:(id)sender;

@end
