//
//  RPBVisitHeaderView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RPBVisitHeaderViewDelegate <NSObject>
- (void)sectionTapped:(NSInteger)nCatagoryIndex;
@end

@interface RPBVisitHeaderView : UIView
{
    IBOutlet UILabel        * _lbCatName;
    IBOutlet UILabel        * _lbIssueCount;
    IBOutlet UIImageView    * _imgMarked;
    IBOutlet UIView         * _viewGap;
    IBOutlet UIImageView    * _imgExpand;
    
    BOOL                    _bExpand;
}

@property (nonatomic,assign) id<RPBVisitHeaderViewDelegate> delegate;
@property (nonatomic,assign) BVisitItem * visitItem;
@property (nonatomic) NSInteger nIndex;

-(void)setExpand:(BOOL)bExpand;
@end
