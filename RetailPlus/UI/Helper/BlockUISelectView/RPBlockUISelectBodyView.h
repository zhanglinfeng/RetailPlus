//
//  RPBlockUISelectBodyView.h
//  RetailPlus
//
//  Created by lin dong on 14-2-18.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPBlockUISelectBodyViewDelegate <NSObject>
    -(void)OnSelect:(NSInteger)nIndex;
@end

@interface RPBlockUISelectBodyView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIScrollView   * _svBody;
    IBOutlet UITableView    * _tbBody;
    IBOutlet UILabel        * _lbTitle;
    
    NSMutableArray          * _arraySelTitle;
}

@property (nonatomic,assign) id<RPBlockUISelectBodyViewDelegate> delegate;
@property (nonatomic,retain) NSString * strTitle;
@property (nonatomic) NSInteger nCurSel;
@property (nonatomic) NSInteger nMaxHeight;
@property (nonatomic,readonly) NSInteger nViewHeight;

-(void)AddSelTitle:(NSString *)strSelTitle;

@end
