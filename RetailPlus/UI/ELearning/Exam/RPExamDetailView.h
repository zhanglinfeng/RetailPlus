//
//  RPExamDetailView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-25.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RPSDKELDefine.h"
@protocol RPExamDetailViewDelegate
-(void)selectOption;
@end
@interface RPExamDetailView : UIScrollView<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UIView *_viewQuestion;
    IBOutlet UILabel *_lbQuestion;
    IBOutlet UITableView *_tbOption;
    NSMutableArray *_arrayAnswers;
    UIImageView *_ivTemp;
    
}
@property(nonatomic,weak)id<RPExamDetailViewDelegate>delegateSelect;
@property (strong, nonatomic) IBOutlet UIImageView *ivQuestion;
@property(nonatomic,strong)RPELQuestion *question;
@end
