//
//  RPBVisitIssueTrackHeadView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-8-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RPBVisitIssueTrackHeadViewDelegate <NSObject>
-(void)endSelectCatagory;
@end;
@interface RPBVisitIssueTrackHeadView : UIView
{
    IBOutlet UILabel        * _lbStoreName;
    IBOutlet UILabel        * _lbAddress;
    IBOutlet UIImageView    * _ivStore;
    IBOutlet UIImageView    *_ivTriangle;
    IBOutlet UILabel *_lbCount;
}
@property (strong, nonatomic) IBOutlet UIButton *btSelect;
@property (nonatomic,strong) BVisitSearchRetCatagory *issueSearchRetCatagory;
@property (nonatomic,weak)id<RPBVisitIssueTrackHeadViewDelegate>delegate;
- (IBAction)OnSelect:(id)sender;
- (IBAction)OnExpend:(id)sender;

@end
