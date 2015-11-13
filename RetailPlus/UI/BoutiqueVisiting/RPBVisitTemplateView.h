//
//  RPBVisitTemplateView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPBVisitDetailView.h"
@protocol RPBVisitTemplateViewDelegate <NSObject>
-(void)OnTemplateVisitEnd:(NSString *)reportId;
//-(void)OnGoTask:(NSString*)reportId;
@end
@interface RPBVisitTemplateView : UIView<UITableViewDataSource,UITableViewDelegate,RPBVisitDetailViewDelegate>
{
    
    IBOutlet UITableView                    *_tbTemplate;
    NSMutableArray                          *_arrayTemplate;
    IBOutlet RPBVisitDetailView             *_viewDetail;
    BOOL                                    _bViewDetail;
    IBOutlet UIView *_viewBackground;
}
@property (nonatomic,assign) UIViewController               * vcFrame;
@property (nonatomic,assign) id<RPBVisitTemplateViewDelegate>   delegate;
@property (nonatomic,strong) StoreDetailInfo  * storeSelected;
@property (nonatomic,strong) BVisitData       *dataVisit;
@property (nonatomic,strong)BVisitTemplate    *visitTemplate;
-(BOOL)OnBack;
- (IBAction)OnHelp:(id)sender;
- (IBAction)OnQuit:(id)sender;

@end
