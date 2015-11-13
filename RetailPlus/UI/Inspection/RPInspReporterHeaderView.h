//
//  RPInspReporterHeaderView.h
//  RetailPlus
//
//  Created by lin dong on 13-9-4.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPInspReporterHeaderViewDelegate <NSObject>
- (void)sectionTapped:(NSInteger)nCatagoryIndex;
@end

@interface RPInspReporterHeaderView : UIView
{
    IBOutlet UILabel * _lbTitle1;
    IBOutlet UILabel * _lbTitle2;
    IBOutlet UILabel * _lbCount;
    IBOutlet UIView         * _viewgap;
    IBOutlet UIImageView    * _ivArrow;
}

@property (nonatomic) NSInteger                      nIndex;
@property (nonatomic) BOOL                           bExpand;
@property (nonatomic,assign) InspReporterSection * section;
@property (nonatomic,assign) id<RPInspReporterHeaderViewDelegate> delegate;
@property (nonatomic,assign)NSInteger   nState;
@end
