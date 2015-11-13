//
//  RPFinishView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-10.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RPFinishViewDelegate <NSObject>
-(void)endFinish;
@end
@interface RPFinishView : UIView<UITextViewDelegate>
{
    IBOutlet UIView *_view1;
    IBOutlet UIView *_view2;
    IBOutlet UIView *_view3;
    IBOutlet UIView *_view4;
    IBOutlet UIButton *_btYes;
    IBOutlet UIButton *_btCancel;
    IBOutlet UITextView *_tvReason;
}
@property(nonatomic,weak)id<RPFinishViewDelegate>delegate;
@property (nonatomic,assign) StoreDetailInfo * storeSelected;
@property (nonatomic,assign) NSInteger sn;
- (IBAction)OnSubmit:(id)sender;
- (IBAction)OnCencel1:(id)sender;
- (IBAction)OnYes:(id)sender;
- (IBAction)OnCancel2:(id)sender;
- (void)OnShow1;
- (void)OnShow2;
@end
