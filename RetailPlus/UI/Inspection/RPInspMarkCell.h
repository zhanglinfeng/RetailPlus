//
//  RPInspMarkCell.h
//  RetailPlus
//
//  Created by lin dong on 13-8-19.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPInspMarkCellDelegate <NSObject>
    -(void)OnMark:(InspCatagory *)catagory;
@end

@interface RPInspMarkCell : UITableViewCell
{
    IBOutlet UIView     * _viewMarkDesc;
    IBOutlet UIButton   * _btnMark1;
    IBOutlet UIButton   * _btnMark2;
    IBOutlet UIButton   * _btnMark3;
    IBOutlet UIButton   * _btnMark4;
    IBOutlet UIButton   * _btnMark5;
    IBOutlet UILabel    * _lbMarkDesc;
}

@property (nonatomic,assign) InspCatagory * catagory;
@property (nonatomic,assign) id<RPInspMarkCellDelegate> delegate;
-(IBAction)OnMark:(id)sender;

@end
