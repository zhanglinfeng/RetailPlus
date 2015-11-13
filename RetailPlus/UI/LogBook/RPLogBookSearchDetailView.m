//
//  RPLogBookSearchDetailView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-5.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPLogBookSearchDetailView.h"
#import "RPLogBookSearchCell.h"
#import "RPLogBookCell.h"
@implementation RPLogBookSearchDetailView

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
    _viewBackground.layer.cornerRadius=10;
    _tbDetail.layer.cornerRadius=6;
}

-(void)setDetail:(LogBookDetail *)detail
{
    _detail=detail;
    [_tbDetail reloadData];
}
-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{
    _storeSelected = storeSelected;
    _lbStoreName.text=storeSelected.strStoreName;
    _lbStoreTitle.text = [NSString stringWithFormat:@"%@ %@",storeSelected.strCityName,storeSelected.strBrandName];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPLogBookCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPLogBookCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPLogBookCell" owner:self options:nil];
        
        cell = [array objectAtIndex:0];
    }
    cell.detail=_detail;
    cell.delegate = self;
    cell.storeSelected = _storeSelected;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [RPLogBookCell calcCellHeight:_detail];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_detail)
        return 1;
    return 0;
}

-(void)UpdateDetailTable
{
    [_tbDetail reloadData];
}

-(void)deleteEnd
{
    _detail = nil;
    [_tbDetail reloadData];
    [self.delegete refreshLogBook];
}
@end
