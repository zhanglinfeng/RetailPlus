//
//  RPDocUnfinished.h
//  RetailPlus
//
//  Created by zwhe on 13-12-4.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RPDocLiveView.h"
#import "UIMarqueeLabel.h"
@protocol DocUnfinishedCellDelegate <NSObject>
-(void)OnDeleteDoc:(Document *)doc;

@end
@interface RPDocUnfinishedCell : UITableViewCell
{
    IBOutlet UIMarqueeLabel *_lbStoreName;
    IBOutlet UIView *_viewLine;
}
@property (strong, nonatomic)Document *doc;

@property (strong, nonatomic) IBOutlet UILabel *lbDesc;
@property (strong, nonatomic) IBOutlet UILabel *lbAuthor;
@property (strong, nonatomic) IBOutlet UILabel *lbDate;
@property (strong, nonatomic) IBOutlet UIImageView *ivIconRec;
@property (assign,nonatomic)id <DocUnfinishedCellDelegate>docCellDelegate;
- (IBAction)informationClick:(id)sender;
- (IBAction)forwordClick:(id)sender;
- (IBAction)editClick:(id)sender;
- (IBAction)delectClick:(id)sender;
-(void)ShowExpand:(BOOL)bExpand;
@end
