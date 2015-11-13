//
//  RPConfHistoryDetailView.m
//  RetailPlus
//
//  Created by lin dong on 14-6-20.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPConfHistoryDetailView.h"
#import "RPConfHistoryGuestCell.h"

@implementation RPConfHistoryDetailView

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
}

-(void)setConf:(RPConf *)conf
{
    _conf = conf;
    _lbConfTheme.text = _conf.strCallTheme;
    _lbCount.text = [NSString stringWithFormat:@"%d",_conf.arrayGuest.count];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    _lbDateTime.text = [formatter stringFromDate:_conf.dateCallHistory];
    [_tbMember reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPConfHistoryGuestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPConfHistoryGuestCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPConfHistoryCell" owner:self options:nil];
        cell = [array objectAtIndex:1];
    }
    cell.guest = [_conf.arrayGuest objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0)
        cell.bMaster = YES;
    else
        cell.bMaster = NO;
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _conf.arrayGuest.count;
}

-(IBAction)OnRepeat:(id)sender
{
    [_delegate OnRepeat:_conf];
}

-(IBAction)OnQuit:(id)sender
{
    [_delegate OnQuit];
}
@end
