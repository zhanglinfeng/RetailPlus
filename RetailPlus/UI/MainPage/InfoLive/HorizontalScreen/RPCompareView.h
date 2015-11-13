//
//  RPCompareView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-4-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPCompareView : UIView

{
    
}
@property(nonatomic,strong)IBOutlet UILabel *lbDateSelect2;
@property(nonatomic,strong)IBOutlet UILabel *lbStoreName;
@property(nonatomic,strong)IBOutlet UILabel *lbStoreName2;
@property(nonatomic,strong)IBOutlet UILabel *lbDateSelect1;
@property(nonatomic,strong)IBOutlet UILabel *lbDate;
@property(nonatomic,strong)IBOutlet UIView *viewTop;
@property(nonatomic,strong)IBOutlet UIWebView *webView;
@property(nonatomic,strong)IBOutlet UILabel *lbLeft;
@property(nonatomic,strong)IBOutlet UILabel *lbRight;
@property(nonatomic,assign)int index1;
@property(nonatomic,assign)int index2;
- (IBAction)OnChooseDate:(id)sender;
- (IBAction)OnDateSelect1:(id)sender;
- (IBAction)OnDateSelect2:(id)sender;


@end
