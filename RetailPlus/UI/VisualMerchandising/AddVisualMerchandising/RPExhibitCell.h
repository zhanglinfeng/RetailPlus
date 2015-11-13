//
//  RPExhibitCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTextViewPlaceholder.h"
@protocol RPExhibitCellDelegate <NSObject>
-(void)OnDeleteImg:(VMImage*)vmImg;
-(void)showIndex:(int)index;
-(void)EndEditing;
@end
@interface RPExhibitCell : UITableViewCell<UITextViewDelegate>
{
    IBOutlet UIImageView *_ivPic;
    IBOutlet UITextView *_tvRemrak;
    
    IBOutlet UILabel *_tfRemark;
}
@property (assign, nonatomic) id<RPExhibitCellDelegate> delegate;
@property(nonatomic,strong) VMImage *vmImage;
@property(nonatomic,assign)int index;
- (IBAction)Ondelete:(id)sender;

@end
