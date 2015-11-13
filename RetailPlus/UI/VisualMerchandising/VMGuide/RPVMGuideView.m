//
//  RPVMGuideView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPVMGuideView.h"
#import "RPVMGuideCell.h"

#import "RPBlockUIAlertView.h"
extern NSBundle * g_bundleResorce;
@implementation RPVMGuideView

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
    //设置tableView无分割线
    _tbGuide.separatorStyle=UITableViewCellSeparatorStyleNone;
    _viewHead.layer.cornerRadius=10;
    _viewSearch.layer.cornerRadius=6;
    [self loadData];
}
-(void)loadData
{
    [[RPSDK defaultInstance] GetVisualDisplayAttachmentsSuccess:^(NSMutableArray *array)
     {
         _arrayGuide=array;
         [self search:_tfSearch.text];
     } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
         
     }];
    
}
-(void)backDoc
{
    [self loadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPWebDocViewController * vcWeb = [[RPWebDocViewController alloc] initWithNibName:NSStringFromClass([RPWebDocViewController class]) bundle:nil];
    vcWeb.cache = [RPSDK defaultInstance].cacheTraining;
    
    RPvmGuide * guide= (RPvmGuide *)[_arraySearch objectAtIndex:indexPath.row];
    
    vcWeb.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    vcWeb.strUrl = guide.strUrl;
    vcWeb.strTitle = guide.strName;
    
    vcWeb.delegate=self;
    [self.vcFrame presentViewController:vcWeb animated:YES completion:^{
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arraySearch.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPVMGuideCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPVMGuideCell"];
    if (cell==nil)
    {
        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPVMGuideCell" owner:self options:nil];
        cell=[arrayNib objectAtIndex:0];
    }
    RPvmGuide * guide= (RPvmGuide *)[_arraySearch objectAtIndex:indexPath.row];
    cell.guide=guide;
    
    NSDictionary * dict = [[RPSDK defaultInstance].cacheTraining cachedResponseHeadersForURL:[NSURL URLWithString:[guide.strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    if (dict)
    {
        cell.lbSize.text=NSLocalizedStringFromTableInBundle(@"downloaded",@"RPString", g_bundleResorce,nil);
        cell.lbSize.textColor=[UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
    }
    else
    {
        cell.lbSize.text=[NSString stringWithFormat:@"%0.1f M",guide.size];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38;
}
-(void)search:(NSString*)s
{
    _arraySearch = [self genSearchArray:_arrayGuide condition:s];
  
    [_tbGuide reloadData];
    
}
-(NSMutableArray *)genSearchArray:(NSMutableArray *)array condition:(NSString *)strSearch
{
    if (!strSearch) {
        strSearch=@"";
    }
    
    if (strSearch.length == 0) {
        return array;
    }
    
    NSString *str=strSearch;
    NSMutableArray * arrayResult = [[NSMutableArray alloc] init];
    
    for (int i=0; i<array.count; i++)
    {
        RPvmGuide *vmGuide=[[RPvmGuide alloc]init];
        vmGuide=[array objectAtIndex:i];
        
        NSRange res = [vmGuide.strName rangeOfString:str options:NSCaseInsensitiveSearch];
        
        
        
            if ((strSearch.length == 0) || (res.length != 0  ))
            {
                [arrayResult addObject:vmGuide];
            }
        
    }
    
    return arrayResult;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self search:_tfSearch.text];
    return YES;
}
- (IBAction)OnSearch:(id)sender
{
    [self search:_tfSearch.text];
}

- (IBAction)OnDeleteSearch:(id)sender
{
    _tfSearch.text=@"";
    [self search:_tfSearch.text];
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}
-(IBAction)OnQuit:(id)sender
{
    [self endEditing:YES];
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to exit?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            [self.delegate endVMGuide];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
    
}
@end
