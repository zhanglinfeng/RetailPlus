//
//  RPInspReporterView.m
//  RetailPlus
//
//  Created by lin dong on 13-9-4.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPInspReporterView.h"
#import "RPInspReporterHeaderView.h"
#import "RPInspReporterCmdCell.h"
#import "RPBlockUIAlertView.h"
extern NSBundle * g_bundleResorce;

@implementation RPInspReporterView

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
    _viewFrame.layer.cornerRadius = 8;
    
    _vcAddReceiver = [[RPAddReceiverViewController alloc] initWithNibName:NSStringFromClass([RPAddReceiverViewController class]) bundle:g_bundleResorce];
    _vcAddReceiver.view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    _vcAddReceiver.delegate = self;
    _nState=1;
}

-(void)setReporters:(InspReporters *)reporters
{
    _reporters = reporters;
    [_tbReport reloadData];
}

-(void)setStrTitle:(NSString *)strTitle
{
    _strTitle = strTitle;
    _lbTitle.text = _strTitle;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        RPInspReporterCmdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPInspReporterCmdCell"];
        if (cell == nil)
        {
            NSArray *array = [g_bundleResorce loadNibNamed:@"RPInspReporterCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            cell.delegate = self;
            cell.section = [self.reporters.arraySection objectAtIndex:indexPath.section];
            
            BOOL bAll = YES;
            InspReporterSection * sectionGet = [self.reporters.arraySection objectAtIndex:_nCurSectionIndex];
            
            for (InspReporterUser * user in sectionGet.arrayUser) {
                if (!user.bSelected)
                {
                    bAll = NO;
//                    break;
                }
            }
            cell.bAll = bAll;
        }
        return cell;
    }
    else
    {
        RPAddReceiverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPAddReceiverCell"];
        if (cell == nil)
        {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPAddReceiverCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            cell.delegate = self;
        }
        
        InspReporterSection * section = [self.reporters.arraySection objectAtIndex:indexPath.section];
        InspReporterUser * user = [section.arrayUser objectAtIndex:indexPath.row - 1];
        if (user.bUserCollegue) {
            cell.colleague = user.collegue;
        }
        else
        {
            cell.bEmail = YES;
            cell.strEmail = user.strEmail;
        }
        
        cell.bSelect = user.bSelected;
        return cell;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.reporters.arraySection.count > 0) {
        if (_nCurSectionIndex == section) {
            InspReporterSection * section = [self.reporters.arraySection objectAtIndex:_nCurSectionIndex];
            
            return section.arrayUser.count + 1;
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 44;
    else
        return 50;
}
-(void)setNState:(NSInteger)nState
{
    _nState=nState;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RPInspReporterHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"RPInspReporterHeaderView" owner:nil options:nil] objectAtIndex:0];
    view.delegate = self;
    view.nIndex = section;
    view.section = [self.reporters.arraySection objectAtIndex:section];
    view.bExpand = (section == _nCurSectionIndex) ? YES : NO;
    view.nState=_nState;
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.reporters.arraySection == nil) return 0;
    
    return self.reporters.arraySection.count;
}

-(void)OnSelectAddColleague:(InspReporterSection *)section
{
    _vcAddReceiver.view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [self addSubview:_vcAddReceiver.view];
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (InspReporterUser * user in section.arrayUser) {
        if (user.bUserCollegue) {
            [array addObject:user.collegue];
        }
    }
    _vcAddReceiver.arraySelected = array;
    
    [UIView beginAnimations:nil context:nil];
    _vcAddReceiver.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    [_vcAddReceiver UpdateUI];
    
    _bShowAddColleague = YES;
}

-(void)OnSelectAddEmail:(InspReporterSection *)section
{
    _vcAddReceiver.viewAddEmail.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [self addSubview:_vcAddReceiver.viewAddEmail];
    
    [UIView beginAnimations:nil context:nil];
    _vcAddReceiver.viewAddEmail.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    _bShowAddEmail = YES;
}

-(void)EndShowAddEmail
{
    [UIView beginAnimations:nil context:nil];
    _vcAddReceiver.viewAddEmail.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    _bShowAddEmail = NO;
}

-(void)EndShowAddColleague
{
    [UIView beginAnimations:nil context:nil];
    _vcAddReceiver.view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    _bShowAddColleague = NO;
}

-(void)AddEmail:(NSString *)strEmail isEnd:(BOOL)bEnd
{
    InspReporterSection * section = [self.reporters.arraySection objectAtIndex:_nCurSectionIndex];
    
    BOOL bFound = NO;
    for (InspReporterUser * user in section.arrayUser) {
        if (!user.bUserCollegue)
        {
            if ([user.strEmail isEqualToString:strEmail]) {
                bFound = YES;
                break;
            }
        }
    }
    
    if (!bFound) {
        InspReporterUser * user = [[InspReporterUser alloc] init];
        user.bUserCollegue = NO;
        user.strEmail = strEmail;
        user.bSelected = YES;
        if (section.arrayUser == nil) {
            section.arrayUser = [[NSMutableArray alloc] init];
        }
        [section.arrayUser addObject:user];
    }
    
    [_tbReport reloadData];
    
    if (bEnd) {
        [self EndShowAddEmail];
    }
}

-(void)AddColleague:(NSMutableArray *)arrayColleague
{
    InspReporterSection * section = [self.reporters.arraySection objectAtIndex:_nCurSectionIndex];
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (UserDetailInfo * colleague in arrayColleague) {
        InspReporterUser * user = [[InspReporterUser alloc] init];
        user.collegue = colleague;
        user.bUserCollegue = YES;
        user.bSelected = YES;
        [array addObject:user];
    }
    
    for (InspReporterUser * user in section.arrayUser) {
        if (!user.bUserCollegue)
        {
            [array addObject:user];
        }
        
    }
    section.arrayUser = array;
    
    [_tbReport reloadData];
    
    [self EndShowAddColleague];
}


-(void)OnSelectAllUser:(BOOL)bAll
{
    InspReporterSection * section = [self.reporters.arraySection objectAtIndex:_nCurSectionIndex];
    
    for (InspReporterUser * user in section.arrayUser) {
        user.bSelected = bAll;
    }
    [_tbReport reloadData];
}

-(void)EndAddEmail
{
     [self EndShowAddEmail];
}

-(IBAction)OnConfirmUser:(id)sender
{
    [self.delegate OnEndAddUser:_reporters];
}

-(void)sectionTapped:(NSInteger)nCatagoryIndex
{
    _nCurSectionIndex = nCatagoryIndex;
    [_tbReport reloadData];
}

-(void)OnSelectUser:(UserDetailInfo *)colleagueSet bSelected:(BOOL)bSelect
{
    InspReporterSection * section = [self.reporters.arraySection objectAtIndex:_nCurSectionIndex];
    for (InspReporterUser * user in section.arrayUser) {
        if ([user.collegue.strUserId isEqualToString:colleagueSet.strUserId]) {
            user.bSelected = bSelect;
            break;
        }
        if (!user.bUserCollegue)
        {
            break;
        }
    }
    
    [_tbReport reloadData];
}

-(void)OnSelectEmail:(NSString *)strEmail bSelected:(BOOL)bSelect
{
    InspReporterSection * section = [self.reporters.arraySection objectAtIndex:_nCurSectionIndex];
    for (InspReporterUser * user in section.arrayUser) {
        if (!user.bUserCollegue && [user.strEmail isEqualToString:strEmail]) {
            user.bSelected = bSelect;
            break;
        }
    }
    
    [_tbReport reloadData];
}

-(BOOL)OnBack
{
    if (_bShowAddColleague) {
        [self EndShowAddColleague];
        return NO;
    }
    if (_bShowAddEmail) {
        [self EndShowAddEmail];
        return NO;
    }
    return YES;
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}
@end
