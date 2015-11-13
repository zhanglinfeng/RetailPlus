//
//  RPVMGuideCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPVMGuideCell : UITableViewCell
{
    IBOutlet UILabel *_lbName;
    
    
}
@property(nonatomic,assign)RPvmGuide * guide;
@property (strong, nonatomic) IBOutlet UILabel *lbSize;
@end
