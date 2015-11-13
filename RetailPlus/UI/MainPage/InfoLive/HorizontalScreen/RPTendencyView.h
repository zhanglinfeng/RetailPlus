//
//  RPTendencyView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-4-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPTendencyView : UIView
{
}
@property(nonatomic,strong)IBOutlet UIWebView *webView;
@property(nonatomic,strong)IBOutlet UIView *viewTop;
@property(nonatomic,strong)IBOutlet UILabel *lbDate;
@property(nonatomic,strong)IBOutlet UILabel *lbDateSelect;
@property(nonatomic,strong)IBOutlet UILabel *lbLeft;
@property(nonatomic,strong)IBOutlet UILabel *lbRight;
@property(nonatomic,strong)IBOutlet UILabel *lbStoreName;
@property(nonatomic,strong)IBOutlet UILabel *lbStoreName2;
@property(nonatomic,assign)int index;
@end
