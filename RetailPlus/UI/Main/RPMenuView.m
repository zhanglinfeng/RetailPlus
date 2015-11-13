//
//  RPMenuView.m
//  RetailPlus
//
//  Created by lin dong on 13-8-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "RPMenuView.h"
#import "RPOwnedModel.h"
#import "RPBlockUIAlertView.h"

extern NSBundle * g_bundleResorce;

@implementation RPTaskBTN

@end

@implementation RPTaskGroup

@end

@implementation RPMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)awakeFromNib
{
    CALayer *sublayer = _viewRightBack.layer;
    sublayer.cornerRadius =10.0;
    
    _btnGroup1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _btnGroup1.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    _btnGroup1.contentEdgeInsets = UIEdgeInsetsMake(0,0, 10, 15);
    
    _btnGroup2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _btnGroup2.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    _btnGroup2.contentEdgeInsets = UIEdgeInsetsMake(0,0, 10, 15);
    
    _btnGroup3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _btnGroup3.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    _btnGroup3.contentEdgeInsets = UIEdgeInsetsMake(0,0, 10, 15);
    
    _btnGroup4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _btnGroup4.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    _btnGroup4.contentEdgeInsets = UIEdgeInsetsMake(0,0, 10, 15);
    
    _btnGroup5.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _btnGroup5.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    _btnGroup5.contentEdgeInsets = UIEdgeInsetsMake(0,0, 10, 15);
    
    _btnGroup6.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _btnGroup6.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    _btnGroup6.contentEdgeInsets = UIEdgeInsetsMake(0,0, 10, 15);
 //   [self reloadLang];
}

-(void)hideMenu
{
    [UIView beginAnimations:nil context:nil];
    self.frame = CGRectMake(0, _rcOriginalViewFrame.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [self.delegate OnHideMenu];
}

-(void)showMenu
{
    [UIView beginAnimations:nil context:nil];
    self.frame = _rcOriginalViewFrame;
    [UIView commitAnimations];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches   anyObject];
    CGPoint pt = [touch locationInView:_viewHideBar];
    _nTouchBegin = pt.y;
    _rcOriginalViewFrame = self.frame;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_nTouchBegin > 0) {
        UITouch *touch = [touches anyObject];
        CGPoint currentLocation = [touch locationInView:_viewHideBar];
        CGRect frame = self.frame;
        frame.origin.x = 0;
        frame.origin.y += currentLocation.y - _nTouchBegin;
        if (frame.origin.y > 44) {
            frame.origin.y = 44;
        }
        self.frame = frame;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_nTouchBegin > 0) {
        UITouch *touch = [touches anyObject];
        CGPoint currentLocation = [touch locationInView:_viewHideBar];
        CGRect frame = self.frame;
        frame.origin.x = 0;
        frame.origin.y += currentLocation.y - _nTouchBegin;
        self.frame = frame;
        
        if ((self.frame.origin.y + self.frame.size.height) < (self.frame.size.height * 4 / 5))
            [self hideMenu];
        else
            [self showMenu];
    }
}

-(void)OnSelGroup:(RPTaskGroup *)group
{
    _lbGroupTitle.text = group.strGroupName;
    
    NSInteger n = 0;
    for (UIImageView * iv in _arrayLock) {
        iv.hidden = YES;
    }
    
    for (UIButton * btn in _arrayTask) {
        if (n >= group.arrayTask.count)
        {
            btn.hidden = YES;
            continue;
        }
        
        btn.hidden = NO;
        RPTaskBTN * task = [group.arrayTask objectAtIndex:n];
        [btn setBackgroundImage:[UIImage imageNamed:task.strImageName] forState:UIControlStateNormal];
        [btn setTitle:task.strTitle forState:UIControlStateNormal];
        
        
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0,0, 5, 0);
        btn.tag = task.cmd;
        if (task.bOwned) {
            btn.alpha = 1;
            btn.userInteractionEnabled = YES;
            
            UIImageView * iv = [_arrayLock objectAtIndex:n];
            iv.hidden = YES;
        }
        else
        {
            btn.alpha = 0.2;
            btn.userInteractionEnabled = YES;
            
            UIImageView * iv = [_arrayLock objectAtIndex:n];
            iv.hidden = NO;
        }
        n ++;
    }
}

-(IBAction)OnSelGroup1:(id)sender
{
    [_btnGroup1 setSelected:YES];
    [_btnGroup2 setSelected:NO];
    [_btnGroup3 setSelected:NO];
    [_btnGroup4 setSelected:NO];
    [_btnGroup5 setSelected:NO];
    [_btnGroup6 setSelected:NO];
    
    _btnGroup1.userInteractionEnabled = NO;
    _btnGroup2.userInteractionEnabled = YES;
    _btnGroup3.userInteractionEnabled = YES;
    _btnGroup4.userInteractionEnabled = YES;
    _btnGroup5.userInteractionEnabled = YES;
    _btnGroup6.userInteractionEnabled = YES;
    
    [self OnSelGroup:_group1];
    
    _viewArrow.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    _viewArrow.frame = CGRectMake(_viewArrow.frame.origin.x, ((UIButton *)sender).frame.origin.y  + 16, _viewArrow.frame.size.width, _viewArrow.frame.size.height);
    [UIView commitAnimations];
}

-(IBAction)OnSelGroup2:(id)sender
{
    [_btnGroup1 setSelected:NO];
    [_btnGroup2 setSelected:YES];
    [_btnGroup3 setSelected:NO];
    [_btnGroup4 setSelected:NO];
    [_btnGroup5 setSelected:NO];
    [_btnGroup6 setSelected:NO];
    
    _btnGroup1.userInteractionEnabled = YES;
    _btnGroup2.userInteractionEnabled = NO;
    _btnGroup3.userInteractionEnabled = YES;
    _btnGroup4.userInteractionEnabled = YES;
    _btnGroup5.userInteractionEnabled = YES;
    _btnGroup6.userInteractionEnabled = YES;
    
    [self OnSelGroup:_group2];
    
    _viewArrow.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    _viewArrow.frame = CGRectMake(_viewArrow.frame.origin.x, ((UIButton *)sender).frame.origin.y  + 16, _viewArrow.frame.size.width, _viewArrow.frame.size.height);
    [UIView commitAnimations];
}

-(IBAction)OnSelGroup3:(id)sender
{
    [_btnGroup1 setSelected:NO];
    [_btnGroup2 setSelected:NO];
    [_btnGroup3 setSelected:YES];
    [_btnGroup4 setSelected:NO];
    [_btnGroup5 setSelected:NO];
    [_btnGroup6 setSelected:NO];
    
    _btnGroup1.userInteractionEnabled = YES;
    _btnGroup2.userInteractionEnabled = YES;
    _btnGroup3.userInteractionEnabled = NO;
    _btnGroup4.userInteractionEnabled = YES;
    _btnGroup5.userInteractionEnabled = YES;
    _btnGroup6.userInteractionEnabled = YES;
    
    [self OnSelGroup:_group3];
    
    _viewArrow.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    _viewArrow.frame = CGRectMake(_viewArrow.frame.origin.x, ((UIButton *)sender).frame.origin.y  + 16, _viewArrow.frame.size.width, _viewArrow.frame.size.height);
    [UIView commitAnimations];
}

-(IBAction)OnSelGroup4:(id)sender
{
    [_btnGroup1 setSelected:NO];
    [_btnGroup2 setSelected:NO];
    [_btnGroup3 setSelected:NO];
    [_btnGroup4 setSelected:YES];
    [_btnGroup5 setSelected:NO];
    [_btnGroup6 setSelected:NO];
    
    _btnGroup1.userInteractionEnabled = YES;
    _btnGroup2.userInteractionEnabled = YES;
    _btnGroup3.userInteractionEnabled = YES;
    _btnGroup4.userInteractionEnabled = NO;
    _btnGroup5.userInteractionEnabled = YES;
    _btnGroup6.userInteractionEnabled = YES;
    
    [self OnSelGroup:_group4];
    
    _viewArrow.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    _viewArrow.frame = CGRectMake(_viewArrow.frame.origin.x, ((UIButton *)sender).frame.origin.y + 16, _viewArrow.frame.size.width, _viewArrow.frame.size.height);
    [UIView commitAnimations];
}

-(IBAction)OnSelGroup5:(id)sender
{
    [_btnGroup1 setSelected:NO];
    [_btnGroup2 setSelected:NO];
    [_btnGroup3 setSelected:NO];
    [_btnGroup4 setSelected:NO];
    [_btnGroup5 setSelected:YES];
    [_btnGroup6 setSelected:NO];
    
    _btnGroup1.userInteractionEnabled = YES;
    _btnGroup2.userInteractionEnabled = YES;
    _btnGroup3.userInteractionEnabled = YES;
    _btnGroup4.userInteractionEnabled = YES;
    _btnGroup5.userInteractionEnabled = NO;
    _btnGroup6.userInteractionEnabled = YES;
    
    [self OnSelGroup:_group5];
    
    _viewArrow.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    _viewArrow.frame = CGRectMake(_viewArrow.frame.origin.x,((UIButton *)sender).frame.origin.y  + 16, _viewArrow.frame.size.width, _viewArrow.frame.size.height);
    [UIView commitAnimations];
}

-(IBAction)OnSelGroup6:(id)sender
{
//    [_btnMng setSelected:NO];
//    [_btnCRM setSelected:NO];
//    [_btnStuff setSelected:NO];
//    [_btnOperation setSelected:NO];
//    [_btnTranning setSelected:NO];
//    [_btnConsult setSelected:YES];
//    
//    _btnMng.userInteractionEnabled = YES;
//    _btnCRM.userInteractionEnabled = YES;
//    _btnStuff.userInteractionEnabled = YES;
//    _btnOperation.userInteractionEnabled = YES;
//    _btnTranning.userInteractionEnabled = YES;
//    _btnConsult.userInteractionEnabled = NO;
//    
//    [self OnSelGroup:_groupConsult];
//    
//    _viewArrow.hidden = NO;
//    
//    [UIView beginAnimations:nil context:nil];
//    _viewArrow.frame = CGRectMake(_viewArrow.frame.origin.x, ((UIButton *)sender).frame.origin.y  + 16, _viewArrow.frame.size.width, _viewArrow.frame.size.height);
//    [UIView commitAnimations];
}

-(RPTaskBTN *)FindBtnTask:(NSInteger)nTag inGroup:(RPTaskGroup *)group
{
    for (NSInteger n = 0;n < group.arrayTask.count;n ++) {
        RPTaskBTN * task = [group.arrayTask objectAtIndex:n];
        if (task.cmd == nTag) {
            return task;
        }
    }
    return nil;
}

-(IBAction)OnSelTask:(id)sender
{
    RPTaskBTN * task = [self FindBtnTask:((UIButton *)sender).tag inGroup:_group1];
    if (task) goto End;
    
    task = [self FindBtnTask:((UIButton *)sender).tag inGroup:_group2];
    if (task) goto End;

    task = [self FindBtnTask:((UIButton *)sender).tag inGroup:_group3];
    if (task) goto End;
    
    task = [self FindBtnTask:((UIButton *)sender).tag inGroup:_group4];
    if (task) goto End;
    
    task = [self FindBtnTask:((UIButton *)sender).tag inGroup:_group5];
    if (task) goto End;
    
End:
    if (task)
    {
        if (task.bOwned == YES)
            [self.delegate OnSelTask:((UIButton *)sender).tag];
        else
        {
            NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
            RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:task.strBuyString cancelButtonTitle:strOK clickButton:^(NSInteger indexButton){
            } otherButtonTitles:nil];
            [alertView show];
        }
    }
}


-(void)reloadUIDemo
{
    _group1 = [[RPTaskGroup alloc] init];
    _group1.strGroupName = NSLocalizedStringFromTableInBundle(@"Customer",@"RPString", g_bundleResorce,nil);
    _group2 = [[RPTaskGroup alloc] init];
    _group2.strGroupName = NSLocalizedStringFromTableInBundle(@"Operation",@"RPString", g_bundleResorce,nil);
    _group3 = [[RPTaskGroup alloc] init];
    _group3.strGroupName = NSLocalizedStringFromTableInBundle(@"Business",@"RPString", g_bundleResorce,nil);
    _group4 = [[RPTaskGroup alloc] init];
    _group4.strGroupName = NSLocalizedStringFromTableInBundle(@"Environment",@"RPString", g_bundleResorce,nil);
    _group5 = [[RPTaskGroup alloc] init];
    _group5.strGroupName = NSLocalizedStringFromTableInBundle(@"Training",@"RPString", g_bundleResorce,nil);
    
    [_btnGroup1 setTitle:_group1.strGroupName forState:UIControlStateNormal];
    [_btnGroup2 setTitle:_group2.strGroupName forState:UIControlStateNormal];
    [_btnGroup3 setTitle:_group3.strGroupName forState:UIControlStateNormal];
    [_btnGroup4 setTitle:_group4.strGroupName forState:UIControlStateNormal];
    [_btnGroup5 setTitle:_group5.strGroupName forState:UIControlStateNormal];
    
//Group1
    _group1.arrayTask = [[NSMutableArray alloc] init];
    RPTaskBTN * task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Analytics",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group1.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Development",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group1.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-After Service",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group1.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Communication",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group1.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Event Planner",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group1.arrayTask addObject:task];
//group2
    _group2.arrayTask = [[NSMutableArray alloc] init];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Daily Log",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group2.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Expense",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group2.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Media Information",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group2.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Market Information",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group2.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Attendance",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group2.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-OT",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group2.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Conference",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group2.arrayTask addObject:task];
//Group3
    _group3.arrayTask = [[NSMutableArray alloc] init];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Retail Visit",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group3.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Mystery Shopper",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group3.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-PA",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group3.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Inventory",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group3.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Traffic Report",@"RPString", g_bundleResorce,nil);
//   task.cmd = TASKCOMMAND_Inspection;
    [_group3.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Sales Report",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group3.arrayTask addObject:task];
    
//Group4
    _group4.arrayTask = [[NSMutableArray alloc] init];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_boutique_maintenance01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Maintenance",@"RPString", g_bundleResorce,nil);
    task.cmd = TASKCOMMAND_Maintenance;
    [_group4.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_boutique_handover02@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Handover",@"RPString", g_bundleResorce,nil);
    task.cmd = TASKCOMMAND_Inspection;
    [_group4.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_construction_visiting01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Inspection",@"RPString", g_bundleResorce,nil);
    task.cmd = TASKCOMMAND_ConstructionVisiting;
    [_group4.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-VM",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group4.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-CCTV",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group4.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-BD",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group4.arrayTask addObject:task];
    
//Group5
    _group5.arrayTask = [[NSMutableArray alloc] init];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Daily Task",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group5.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-New Store",@"RPString", g_bundleResorce,nil);
//    task.cmd = TASKCOMMAND_Inspection;
    [_group5.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-on-board traning",@"RPString", g_bundleResorce,nil);
 //   task.cmd = TASKCOMMAND_Inspection;
    [_group5.arrayTask addObject:task];
    
    _arrayTask = [[NSArray alloc] initWithObjects:_btnTask1,_btnTask2,_btnTask3,_btnTask4,_btnTask5,_btnTask6,_btnTask7,_btnTask8, nil];
    
    for (UIImageView * iv in _arrayLock) {
        iv.hidden = YES;
    }
    _arrayLock = [[NSMutableArray alloc] init];
    for (UIButton * btn in _arrayTask) {
        UIImageView * iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_lockedfunction.png"]];
        iv.frame = btn.frame;
        [btn.superview addSubview:iv];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.hidden = YES;
        [_arrayLock addObject:iv];
    }
    
    _btnGroup6.hidden = YES;
    [self OnSelGroup1:_btnGroup1];
}

-(void)reloadUI
{
    _group1 = [[RPTaskGroup alloc] init];
    _group1.strGroupName = NSLocalizedStringFromTableInBundle(@"Customer",@"RPString", g_bundleResorce,nil);
    _group2 = [[RPTaskGroup alloc] init];
    _group2.strGroupName = NSLocalizedStringFromTableInBundle(@"Operation",@"RPString", g_bundleResorce,nil);
    _group3 = [[RPTaskGroup alloc] init];
    _group3.strGroupName = NSLocalizedStringFromTableInBundle(@"Management",@"RPString", g_bundleResorce,nil);
    _group4 = [[RPTaskGroup alloc] init];
    _group4.strGroupName = NSLocalizedStringFromTableInBundle(@"Training",@"RPString", g_bundleResorce,nil);
    _group5 = [[RPTaskGroup alloc] init];
    _group5.strGroupName = NSLocalizedStringFromTableInBundle(@"Consulting",@"RPString", g_bundleResorce,nil);

    
    [_btnGroup1 setTitle:_group1.strGroupName forState:UIControlStateNormal];
    [_btnGroup1 setTitle:_group1.strGroupName forState:UIControlStateSelected];
    [_btnGroup2 setTitle:_group2.strGroupName forState:UIControlStateNormal];
    [_btnGroup2 setTitle:_group2.strGroupName forState:UIControlStateSelected];
    [_btnGroup3 setTitle:_group3.strGroupName forState:UIControlStateNormal];
    [_btnGroup3 setTitle:_group3.strGroupName forState:UIControlStateSelected];
    [_btnGroup4 setTitle:_group4.strGroupName forState:UIControlStateNormal];
    [_btnGroup4 setTitle:_group4.strGroupName forState:UIControlStateSelected];
    [_btnGroup5 setTitle:_group5.strGroupName forState:UIControlStateNormal];
    [_btnGroup5 setTitle:_group5.strGroupName forState:UIControlStateSelected];
    
    //Group1
    _group1.arrayTask = [[NSMutableArray alloc] init];
    RPTaskBTN * task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_cts_call_dskicn@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Courtesy Call",@"RPString", g_bundleResorce,nil);
    task.cmd = TASKCOMMAND_CourtesyCall;
    task.bOwned = [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_CCall];
    task.strBuyString = @"您还未购买此模块喔, 快快和我们联系开通使用吧!\n客户回访, 帮您达到最优回访效果.";
    [_group1.arrayTask addObject:task];
    
    
    //group2
    _group2.arrayTask = [[NSMutableArray alloc] init];
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"botton_hdovlgbk_deskicon@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Daily Log",@"RPString", g_bundleResorce,nil);
    task.cmd = TASKCOMMAND_LogBook;
    task.bOwned = [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_Logbook];
    task.strBuyString = @"您还未购买此模块喔, 快快和我们联系开通使用吧!\n交接本,新时代的移动电子交接本";
    [_group2.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_boutique_maintenance01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Maintenance",@"RPString", g_bundleResorce,nil);
    task.cmd = TASKCOMMAND_Maintenance;
    task.bOwned = [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_Maintenance];
    task.strBuyString = @"您还未购买此模块喔, 快快和我们联系开通使用吧!";
    [_group2.arrayTask addObject:task];
    
    task=[[RPTaskBTN alloc] init];
    task.strImageName = @"button_code_query@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Code Query",@"RPString", g_bundleResorce,nil);
    task.cmd = TASKCOMMAND_CodeQuery;
    task.bOwned = [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_CodeQuery];
    task.strBuyString = @"您还未购买此模块喔, 快快和我们联系开通使用吧!\n条码扫描, 清晰准确追踪您的商品";
    [_group2.arrayTask addObject:task];
    
    task=[[RPTaskBTN alloc]init];
    task.strImageName = @"button_vm_dsk@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Visual Merchandising",@"RPString", g_bundleResorce,nil);
    task.cmd = TASKCOMMAND_Visual;
    task.bOwned = [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_Visual];
    task.strBuyString = @"您还未购买此模块喔, 快快和我们联系开通使用吧!\n视觉陈列, 让店铺时刻呈现完美状态";
    [_group2.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_dailystock_dsk@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-DailyStock",@"RPString", g_bundleResorce,nil);
    task.cmd = TASKCOMMAND_DailyStock;
    task.bOwned = [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_DailyStock];
    task.strBuyString = @"您还未购买此模块喔, 快快和我们联系开通使用吧!";
    [_group2.arrayTask addObject:task];
    
    //Group3
    _group3.arrayTask = [[NSMutableArray alloc] init];
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_boutique_handover02@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Boutique Visit",@"RPString", g_bundleResorce,nil);
    task.cmd = TASKCOMMAND_BoutiqueVisiting;
    task.bOwned = [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_BVisiting];
    task.strBuyString = @"您还未购买此模块喔, 快快和我们联系开通使用吧!\n零售巡店 让您的巡店效率无极限提高";
    [_group3.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"botton_kpiinp_deskicon@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-KPI Data Entry",@"RPString", g_bundleResorce,nil);
    task.cmd = TASKCOMMAND_KPIDataEntry;
    task.bOwned = [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_KPI];
    task.strBuyString = @"您还未购买此模块喔, 快快和我们联系开通使用吧!\nKPI管理, 马上有数据,界面很友好";
    [_group3.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"botton_btqhdov_deskicon@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Handover",@"RPString", g_bundleResorce,nil);
    task.cmd = TASKCOMMAND_Inspection;
    task.bOwned = [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_Inspection];
    task.strBuyString = @"您还未购买此模块喔, 快快和我们联系开通使用吧!";
    [_group3.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_construction_visiting01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Inspection",@"RPString", g_bundleResorce,nil);
    task.cmd = TASKCOMMAND_ConstructionVisiting;
    task.bOwned = [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_Visiting];
    task.strBuyString = @"您还未购买此模块喔, 快快和我们联系开通使用吧!";
    [_group3.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_cctv_dsktp@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Live Video",@"RPString", g_bundleResorce,nil);
    task.cmd = TASKCOMMAND_LIVEVIDEO;
    task.bOwned = [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_LiveVideo];
    task.strBuyString = @"您还未购买此模块喔, 快快和我们联系开通使用吧!\n视频直播, 店铺实况一手掌握";
    [_group3.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_cnfrc_call_dsk@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-ConfCall",@"RPString", g_bundleResorce,nil);
    task.cmd = TASKCOMMAND_ConfCall;
    task.bOwned = YES;//[RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_ConfCall];
    task.strBuyString = @"您还未购买此模块喔, 快快和我们联系开通使用吧!\n会议电话, 工作沟通畅通无阻";
    [_group3.arrayTask addObject:task];
    
    //Group4
    _group4.arrayTask = [[NSMutableArray alloc] init];
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_publicfolder_dskicn@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Folder",@"RPString", g_bundleResorce,nil);
    task.cmd = TASKCOMMAND_Training;
    task.bOwned = [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_Training];
    task.strBuyString = @"您还未购买此模块喔, 快快和我们联系开通使用吧!\n产品培训, 让培训变得简单好玩";
    [_group4.arrayTask addObject:task];
    
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_elearning_dsk@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-E-Learning",@"RPString", g_bundleResorce,nil);
    task.cmd = TASKCOMMAND_Elearning;
    task.bOwned = [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_ELearning];
    task.strBuyString = @"您还未购买此模块喔, 快快和我们联系开通使用吧!";
    [_group4.arrayTask addObject:task];
    
    //Group5
    _group5.arrayTask = [[NSMutableArray alloc] init];
    task = [[RPTaskBTN alloc] init];
    task.strImageName = @"button_retail_cnsts_desk@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-RetailConsult",@"RPString", g_bundleResorce,nil);
    task.cmd = TASKCOMMAND_RetailConsulting;
    task.bOwned = YES;
    task.strBuyString = @"您还未购买此模块喔, 快快和我们联系开通使用吧!\n零售咨询, 你的任何需求将在这里得到支持";
    [_group5.arrayTask addObject:task];
    
    _arrayTask = [[NSArray alloc] initWithObjects:_btnTask1,_btnTask2,_btnTask3,_btnTask4,_btnTask5,_btnTask6,_btnTask7,_btnTask8, nil];
    
    for (UIImageView * iv in _arrayLock) {
        iv.hidden = YES;
    }
    
    _arrayLock = [[NSMutableArray alloc] init];
    for (UIButton * btn in _arrayTask) {
        UIImageView * iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_lockedfunction.png"]];
        iv.frame = btn.frame;
        [btn.superview addSubview:iv];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.hidden = YES;
        [_arrayLock addObject:iv];
    }
    
    _btnGroup6.hidden = YES;
    [self OnSelGroup1:_btnGroup1];
}
@end
