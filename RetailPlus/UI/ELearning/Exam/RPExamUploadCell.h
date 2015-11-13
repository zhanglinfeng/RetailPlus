//
//  RPExamUploadCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-25.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RPExamUploadCellDelegate
-(void)endUpload:(Document*)doc;
@end
@interface RPExamUploadCell : UITableViewCell
{
    IBOutlet UILabel *_lbCode;
    IBOutlet UILabel *_lbTitel;
    IBOutlet UILabel *_lbTime;
    
}
@property(nonatomic,weak)id<RPExamUploadCellDelegate>delegate;
@property(nonatomic,strong)RPELPaper *paper;
@property(nonatomic,strong)Document * doc;
- (IBAction)OnUpload:(id)sender;
@end
