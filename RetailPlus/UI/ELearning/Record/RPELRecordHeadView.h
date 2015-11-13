//
//  RPELRecordHeadView.h
//  RetailPlus
//
//  Created by lin dong on 14-8-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPELRecordHeadViewDelegate <NSObject>
    -(void)OnExpandCatagory:(RPELRecordCatagory *)catagory;
@end

@interface RPELRecordHeadView : UIView
{
    IBOutlet UILabel        * _lbCatagory;
    IBOutlet UIImageView    * _ivExpand;
    IBOutlet UIView         * _viewContent;
}

@property (nonatomic,assign)id<RPELRecordHeadViewDelegate>  delegate;
@property (nonatomic)       BOOL                            bLearnRecord;
@property (nonatomic,retain)RPELRecordCatagory              * catagory;
@end
