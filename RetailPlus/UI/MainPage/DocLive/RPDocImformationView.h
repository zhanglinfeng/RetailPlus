//
//  RPDocImformationView.h
//  RetailPlus
//
//  Created by zwhe on 13-12-10.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPDocImformationView : UIView
- (IBAction)okClick:(id)sender;
- (void)Show;

@property (strong, nonatomic) IBOutlet UIView    *viewDetail;
@property (strong, nonatomic) IBOutlet UIButton  *btnOK;
@property (strong, nonatomic) IBOutlet UIView  *viewFrame;
@property (strong, nonatomic) IBOutlet UIView  *viewMask;
@property (strong, nonatomic) IBOutlet UILabel *lbDesc;
@property (strong, nonatomic) IBOutlet UILabel *lbDocumentID;
@property (strong, nonatomic) IBOutlet UILabel *lbAuthor;
@property (strong, nonatomic) IBOutlet UILabel *lbCreatedTime;
@property (strong, nonatomic) Document * doc;
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;

@end
