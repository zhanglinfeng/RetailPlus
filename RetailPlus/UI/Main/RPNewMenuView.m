//
//  RPNewMenuView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-10.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPNewMenuView.h"
extern NSBundle * g_bundleResorce;

@implementation RPTaskBT

@end

@implementation RPNewTaskGroup

@end
@implementation RPNewMenuView

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
    [self.delegate OnHideNewMenu];
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

-(void)OnSelGroup:(RPNewTaskGroup *)group
{
    //依次遍历self.view中的所有子视图
    for(id tmpView in [_svTask subviews])
    {
        //找到要删除的子视图的对象
        if([tmpView isKindOfClass:[UIButton class]])
        {
//            UIImageView *imgView = (UIImageView *)tmpView;
//            if(imgView.tag == 1)   //判断是否满足自己要删除的子视图的条件
//            {
//                [imgView removeFromSuperview]; //删除子视图
//                
//                break;  //跳出for循环，因为子视图已经找到，无须往下遍历
//            }
            [tmpView removeFromSuperview];
        }
    }
    
    _lbGroupTitle.text = group.strGroupName;
    float x=10.0;//Button横坐标
    float y=0;//Button纵坐标
    float m=110;//Button横坐标最大值
    int   n=1;//scrollview页数
    for (int i=0; i<group.arrayTask.count; i++)
    {
        
        if (x>m)
        {
            x=x-200;
            y=y+100;
            if (y>_svTask.frame.size.height-92)
            {
                m=_svTask.frame.size.width+m;
                x=_svTask.frame.size.width*n+10;
                y=0;
                n++;
            }
        }
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(x, y, 80, 92);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.contentEdgeInsets = UIEdgeInsetsMake(0,0, 5, 0);
        button.titleLabel.font=[UIFont systemFontOfSize:10.0];
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_svTask addSubview:button];
        
        RPTaskBT * task = [group.arrayTask objectAtIndex:i];
        [button setBackgroundImage:[UIImage imageNamed:task.strImageName] forState:UIControlStateNormal];
        [button setTitle:task.strTitle forState:UIControlStateNormal];
        button.tag = task.cmd;
        [button addTarget:self action:@selector(OnSelTask:) forControlEvents:UIControlEventTouchUpInside];
        x=x+100;
    }
    _svTask.contentSize=CGSizeMake(_svTask.frame.size.width*n, _svTask.frame.size.height);
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

-(IBAction)OnSelTask:(id)sender
{
    
    [self.delegate OnSelNewTask:((UIButton *)sender).tag];
}


-(void)reloadUIDemo
{
    _group1 = [[RPNewTaskGroup alloc] init];
    _group1.strGroupName = NSLocalizedStringFromTableInBundle(@"Customer",@"RPString", g_bundleResorce,nil);
    _group2 = [[RPNewTaskGroup alloc] init];
    _group2.strGroupName = NSLocalizedStringFromTableInBundle(@"Operation",@"RPString", g_bundleResorce,nil);
    _group3 = [[RPNewTaskGroup alloc] init];
    _group3.strGroupName = NSLocalizedStringFromTableInBundle(@"Business",@"RPString", g_bundleResorce,nil);
    _group4 = [[RPNewTaskGroup alloc] init];
    _group4.strGroupName = NSLocalizedStringFromTableInBundle(@"Environment",@"RPString", g_bundleResorce,nil);
    _group5 = [[RPNewTaskGroup alloc] init];
    _group5.strGroupName = NSLocalizedStringFromTableInBundle(@"Training",@"RPString", g_bundleResorce,nil);
    
    [_btnGroup1 setTitle:_group1.strGroupName forState:UIControlStateNormal];
    [_btnGroup2 setTitle:_group2.strGroupName forState:UIControlStateNormal];
    [_btnGroup3 setTitle:_group3.strGroupName forState:UIControlStateNormal];
    [_btnGroup4 setTitle:_group4.strGroupName forState:UIControlStateNormal];
    [_btnGroup5 setTitle:_group5.strGroupName forState:UIControlStateNormal];
    
    //Group1
    _group1.arrayTask = [[NSMutableArray alloc] init];
    RPTaskBT * task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Analytics",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group1.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Development",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group1.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-After Service",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group1.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Communication",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group1.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Event Planner",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group1.arrayTask addObject:task];
    //group2
    _group2.arrayTask = [[NSMutableArray alloc] init];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Daily Log",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group2.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Expense",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group2.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Media Information",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group2.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Market Information",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group2.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Attendance",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group2.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-OT",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group2.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Conference",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group2.arrayTask addObject:task];
    //Group3
    _group3.arrayTask = [[NSMutableArray alloc] init];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Retail Visit",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group3.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Mystery Shopper",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group3.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-PA",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group3.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Inventory",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group3.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Traffic Report",@"RPString", g_bundleResorce,nil);
    //   task.cmd = TASKCOMMAND_Inspection;
    [_group3.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Sales Report",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group3.arrayTask addObject:task];
    
    //Group4
    _group4.arrayTask = [[NSMutableArray alloc] init];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_boutique_maintenance01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Maintenance",@"RPString", g_bundleResorce,nil);
    task.cmd = N_TASKCOMMAND_Maintenance;
    [_group4.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_boutique_handover02@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Handover",@"RPString", g_bundleResorce,nil);
    task.cmd = N_TASKCOMMAND_Inspection;
    [_group4.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_construction_visiting01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Inspection",@"RPString", g_bundleResorce,nil);
    task.cmd = N_TASKCOMMAND_ConstructionVisiting;
    [_group4.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-VM",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group4.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-CCTV",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group4.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-BD",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group4.arrayTask addObject:task];
    
    //Group5
    _group5.arrayTask = [[NSMutableArray alloc] init];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Daily Task",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group5.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-New Store",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    [_group5.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-on-board traning",@"RPString", g_bundleResorce,nil);
    //   task.cmd = TASKCOMMAND_Inspection;
    [_group5.arrayTask addObject:task];
    
    _arrayTask = [[NSArray alloc] initWithObjects:_btnTask1,_btnTask2,_btnTask3,_btnTask4,_btnTask5,_btnTask6,_btnTask7,_btnTask8, nil];
    
    _btnGroup6.hidden = YES;
    [self OnSelGroup1:_btnGroup1];
}

-(void)reloadUI
{
    _group1 = [[RPNewTaskGroup alloc] init];
    _group1.strGroupName = NSLocalizedStringFromTableInBundle(@"Customer",@"RPString", g_bundleResorce,nil);
    _group2 = [[RPNewTaskGroup alloc] init];
    _group2.strGroupName = NSLocalizedStringFromTableInBundle(@"Operation",@"RPString", g_bundleResorce,nil);
    _group3 = [[RPNewTaskGroup alloc] init];
    _group3.strGroupName = NSLocalizedStringFromTableInBundle(@"Business",@"RPString", g_bundleResorce,nil);
    _group4 = [[RPNewTaskGroup alloc] init];
    _group4.strGroupName = NSLocalizedStringFromTableInBundle(@"Environment",@"RPString", g_bundleResorce,nil);
    _group5 = [[RPNewTaskGroup alloc] init];
    _group5.strGroupName = NSLocalizedStringFromTableInBundle(@"Training",@"RPString", g_bundleResorce,nil);
    
    [_btnGroup1 setTitle:_group1.strGroupName forState:UIControlStateNormal];
    [_btnGroup2 setTitle:_group2.strGroupName forState:UIControlStateNormal];
    [_btnGroup3 setTitle:_group3.strGroupName forState:UIControlStateNormal];
    [_btnGroup4 setTitle:_group4.strGroupName forState:UIControlStateNormal];
    [_btnGroup5 setTitle:_group5.strGroupName forState:UIControlStateNormal];
    
    //Group1
    _group1.arrayTask = [[NSMutableArray alloc] init];
    for (NSInteger n = 0; n < 13;n ++)
    {
    RPTaskBT * task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_buildingfunctions01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"Courtesy Call",@"RPString", g_bundleResorce,nil);
    task.cmd = N_TASKCOMMAND_CourtesyCall;
    [_group1.arrayTask addObject:task];
    }
    
    //group2
    _group2.arrayTask = [[NSMutableArray alloc] init];
    RPTaskBT * task = [[RPTaskBT alloc] init];
    task.strImageName = @"botton_hdovlgbk_deskicon@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"Handover Log Book",@"RPString", g_bundleResorce,nil);
    task.cmd = N_TASKCOMMAND_LogBook;
    [_group2.arrayTask addObject:task];
    
    //Group3
    _group3.arrayTask = [[NSMutableArray alloc] init];
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_boutique_handover02@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"Boutique Visit",@"RPString", g_bundleResorce,nil);
    task.cmd = N_TASKCOMMAND_BoutiqueVisiting;
    [_group3.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"botton_kpiinp_deskicon@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"KPI Data Entry",@"RPString", g_bundleResorce,nil);
    task.cmd = N_TASKCOMMAND_KPIDataEntry;
    [_group3.arrayTask addObject:task];
    
    
    //Group4
    _group4.arrayTask = [[NSMutableArray alloc] init];
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_boutique_maintenance01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Maintenance",@"RPString", g_bundleResorce,nil);
    task.cmd = N_TASKCOMMAND_Maintenance;
    [_group4.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"botton_btqhdov_deskicon@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Handover",@"RPString", g_bundleResorce,nil);
    task.cmd = N_TASKCOMMAND_Inspection;
    [_group4.arrayTask addObject:task];
    
    task = [[RPTaskBT alloc] init];
    task.strImageName = @"button_construction_visiting01@2x.png";
    task.strTitle = NSLocalizedStringFromTableInBundle(@"m-Inspection",@"RPString", g_bundleResorce,nil);
    task.cmd = N_TASKCOMMAND_ConstructionVisiting;
    [_group4.arrayTask addObject:task];
    
//    _arrayTask = [[NSArray alloc] initWithObjects:_btnTask1,_btnTask2,_btnTask3,_btnTask4,_btnTask5,_btnTask6,_btnTask7,_btnTask8, nil];
    
    _btnGroup5.hidden = YES;
    _btnGroup6.hidden = YES;
    [self OnSelGroup1:_btnGroup1];
    
    //    _group1 = [[RPTaskGroup alloc] init];
    //    _group1.strGroupName = NSLocalizedStringFromTableInBundle(@"Management",@"RPString", g_bundleResorce,nil);;
    //
    //    _group1.arrayTask = [[NSMutableArray alloc] init];
    //
    //    RPTaskBTN * task = [[RPTaskBTN alloc] init];
    //    task.strImageName = @"button_construction_visiting01@2x.png";
    //    task.strTitle = NSLocalizedStringFromTableInBundle(@"Construction Visit",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_ConstructionVisiting;
    //    [_group1.arrayTask addObject:task];
    //
    //    task = [[RPTaskBTN alloc] init];
    //    task.strImageName = @"button_boutique_handover02@2x.png";
    //    task.strTitle = NSLocalizedStringFromTableInBundle(@"Boutique Handover",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Inspection;
    //    [_group1.arrayTask addObject:task];
    //
    //    task = [[RPTaskBTN alloc] init];
    //    task.strImageName = @"button_boutique_maintenance01@2x.png";
    //    task.strTitle = NSLocalizedStringFromTableInBundle(@"Boutique Maintenance",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_Maintenance;
    //    [_group1.arrayTask addObject:task];
    //
    //    task = [[RPTaskBTN alloc] init];
    //    task.strImageName = @"button_boutique_maintenance01@2x.png";
    //    task.strTitle = NSLocalizedStringFromTableInBundle(@"KPI Data Entry",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_KPIDataEntry;
    //    [_group1.arrayTask addObject:task];
    //
    //    task = [[RPTaskBTN alloc] init];
    //    task.strImageName = @"button_boutique_maintenance01@2x.png";
    //    task.strTitle = NSLocalizedStringFromTableInBundle(@"Boutique Visit",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_BoutiqueVisiting;
    //    [_group1.arrayTask addObject:task];
    //
    //    task = [[RPTaskBTN alloc] init];
    //    task.strImageName = @"button_boutique_maintenance01@2x.png";
    //    task.strTitle = NSLocalizedStringFromTableInBundle(@"Handover Log Book",@"RPString", g_bundleResorce,nil);
    //    task.cmd = TASKCOMMAND_LogBook;
    //    [_group1.arrayTask addObject:task];
    //
    //    _arrayTask = [[NSArray alloc] initWithObjects:_btnTask1,_btnTask2,_btnTask3,_btnTask4,_btnTask5,_btnTask6,_btnTask7,_btnTask8, nil];
    //    
    //    [_btnGroup1 setTitle:_group1.strGroupName forState:UIControlStateNormal];
    //    
    //    _btnGroup2.hidden = YES;
    //    _btnGroup3.hidden = YES;
    //    _btnGroup4.hidden = YES;
    //    _btnGroup5.hidden = YES;
    //    _btnGroup6.hidden = YES;
    //    
    //    [self OnSelGroup1:_btnGroup1];
}

@end
