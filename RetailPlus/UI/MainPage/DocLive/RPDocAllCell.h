//
//  RPDocAllCell.h
//  RetailPlus
//
//  Created by zwhe on 13-12-3.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMarqueeLabel.h"
@protocol DocumentCellDelegate <NSObject>
-(void)OnDocumentTask:(Document *)doc btTag:(NSInteger)num ;
//-(void)OnExpand:(Document *)doc;
@end

@interface RPDocAllCell : UITableViewCell
{
    IBOutlet UIMarqueeLabel *_lbStoreName;
    IBOutlet UIView *_viewLine;
}
@property (nonatomic,retain) Document * doc;
@property (strong, nonatomic) IBOutlet UIImageView *ivImage;
@property (strong, nonatomic) IBOutlet UIImageView *ivTypeImage;
@property (strong, nonatomic) IBOutlet UILabel *lbDesc;

@property (strong, nonatomic) IBOutlet UILabel *lbAuthor;
@property (strong, nonatomic) IBOutlet UILabel *lbDate;
@property (strong, nonatomic) IBOutlet UIButton *btInfomation;
@property (strong, nonatomic) IBOutlet UIButton *btForword;
@property (strong, nonatomic) IBOutlet UIButton *btEdit;
@property (strong, nonatomic) IBOutlet UIButton *btDelete;
@property (strong, nonatomic) IBOutlet UILabel *lbEdit;
@property (weak,nonatomic)id <DocumentCellDelegate>docCellDelegate;
//@property (nonatomic) BOOL isShow;
@property (strong, nonatomic) IBOutlet UIImageView *ivIconRec;
@property (strong, nonatomic) IBOutlet UIImageView *ivReceived;

- (IBAction)informationClick:(id)sender;
- (IBAction)forwordClick:(id)sender;
- (IBAction)editClick:(id)sender;
- (IBAction)delectClick:(id)sender;
-(void)ShowExpand:(BOOL)bExpand;

@end
