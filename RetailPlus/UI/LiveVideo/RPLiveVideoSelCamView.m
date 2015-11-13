//
//  RPLiveVideoSelCamView.m
//  RetailPlus
//
//  Created by lin dong on 14-4-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPLiveVideoSelCamView.h"
#import "RPLiveVideoCamCell.h"

@implementation RPLiveVideoSelCamView

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

-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{
    _storeSelected = storeSelected;
    [_arrayCamera removeAllObjects];
    [_tbCamera reloadData];
    _lbStore.text = [NSString stringWithFormat:@"%@%@",storeSelected.strBrandName,storeSelected.strStoreName];
    
    [[RPSDK defaultInstance] GetLiveCameraList:storeSelected.strStoreId Success:^(id idResult) {
        _arrayCamera = idResult;
        [_tbCamera reloadData];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}

-(BOOL)OnBack
{
    return YES;
}

-(IBAction)OnLiveVideoEnd:(id)sender
{
    [self.delegate OnLiveVideoEnd];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return _arrayCamera.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPLiveVideoCamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPLiveVideoCamCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPLiveVideoCamCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.camera = [_arrayCamera objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tbCamera deselectRowAtIndexPath:indexPath animated:YES];

    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    _viewLive.frame = CGRectMake(keywindow.frame.size.width,0,keywindow.frame.size.width, keywindow.frame.size.height);
    [keywindow addSubview:_viewLive];
    
    [UIView beginAnimations:nil context:nil];
    _viewLive.frame = CGRectMake(0,0,keywindow.frame.size.width, keywindow.frame.size.height);
    [UIView commitAnimations];
    
    [_viewLive showVideo:_arrayCamera index:indexPath.row storeName:_storeSelected.strStoreName];
}


@end
