//
//  RPDocSentCell.h
//  RetailPlus
//
//  Created by zwhe on 13-12-4.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RPDocLiveView.h"
#import "UIMarqueeLabel.h"
@protocol DocSentCellDelegate <NSObject>
-(void)OnDeleteSentDoc:(Document *)doc;

@end
@interface RPDocSentCell : UITableViewCell
{
    IBOutlet UIMarqueeLabel *_lbStoreName;
    IBOutlet UIView *_viewLine;
}
//@property (nonatomic)BOOL bLast;
@property (nonatomic,retain) Document * doc;
@property (nonatomic,assign)int index;
//@property (strong, nonatomic) IBOutlet UIButton *sent_btUpload;
@property (strong, nonatomic) IBOutlet UILabel *lbDesc;

@property (strong, nonatomic) IBOutlet UILabel *lbAuthor;
@property (strong, nonatomic) IBOutlet UILabel *lbDate;
@property (strong, nonatomic) IBOutlet UIImageView *lineImage;
@property (strong, nonatomic) IBOutlet UIImageView *ivType;
//@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIImageView *gifImageView;
@property (strong, nonatomic) IBOutlet UIImageView *ivIconRec;
@property(assign,nonatomic)id<DocSentCellDelegate>delegate;
- (IBAction)delectClick:(id)sender;
-(void)ShowExpand:(BOOL)bExpand;
@end
