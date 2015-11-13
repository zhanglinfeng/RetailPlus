//
//  RPAddressBookEditTagView.h
//  RetailPlus
//
//  Created by lin dong on 14-8-25.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutocompletionTableView.h"

@protocol RPAddressBookEditTagViewDelegate <NSObject>
    -(void)OnEditTagEnd;
@end

@interface RPAddressBookEditTagView : UIView
{
    IBOutlet UIView      * _viewMask;
    IBOutlet UITextField * _tfTag;
    IBOutlet UIImageView * _ivBg;
}
@property (nonatomic,assign) id<RPAddressBookEditTagViewDelegate> delegate;
@property (nonatomic,assign) UserDetailInfo * colleague;
@property (nonatomic) NSInteger nTagIndex;
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;

@end
