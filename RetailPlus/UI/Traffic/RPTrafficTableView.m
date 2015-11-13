//
//  RPTrafficTableView.m
//  RetailPlus
//
//  Created by lin dong on 13-8-14.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPTrafficTableView.h"
#import "RPTrafficTableViewCell.h"

@implementation RPTrafficTableView

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPTrafficTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPTrafficTableViewCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPTrafficTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    return cell;
}


@end
