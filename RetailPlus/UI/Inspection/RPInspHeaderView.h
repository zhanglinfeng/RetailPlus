//
//  RPInspHeaderView.h
//  RetailPlus
//
//  Created by lin dong on 13-8-19.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPInspHeaderViewDelegate <NSObject>
    - (void)sectionTapped:(NSInteger)nCatagoryIndex;
@end

@interface RPInspHeaderView : UIView
{
    IBOutlet UILabel        * _lbCatName;
    IBOutlet UILabel        * _lbIssueCount;
    IBOutlet UIImageView    * _imgMarked;
    IBOutlet UIImageView    * _imgMark1;
    IBOutlet UIImageView    * _imgMark2;
    IBOutlet UIImageView    * _imgMark3;
    IBOutlet UIImageView    * _imgMark4;
    IBOutlet UIImageView    * _imgMark5;
    IBOutlet UIView         * _viewGap;
    IBOutlet UIImageView    * _imgExpand;
    
    BOOL                    _bExpand;
}

@property (nonatomic,assign) id<RPInspHeaderViewDelegate> delegate;
@property (nonatomic,assign) InspCatagory * category;
@property (nonatomic) NSInteger nIndex;

-(void)setExpand:(BOOL)bExpand;
@end
