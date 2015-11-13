//
//  RPBVisitTemplateView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBVisitTemplateView.h"
#import "RPBVisitTemplateCell.h"
#import "RPBlockUIAlertView.h"
extern NSBundle * g_bundleResorce;
@implementation RPBVisitTemplateView

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
    [_tbTemplate setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _viewBackground.layer.cornerRadius=10;
    
}
-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{
    _storeSelected=storeSelected;
    [[RPSDK defaultInstance]GetBVisitTemplate:_storeSelected.strStoreId Success:^(NSMutableArray *array) {
        _arrayTemplate=array;
        _dataVisit.arrayCatagory=_arrayTemplate;
        [_tbTemplate reloadData];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
    
}
-(void)OnVisitEnd:(NSString *)reportId
{
    [self dismissView:_viewDetail];
//    _bConfirmQuit = YES;
    [self.delegate OnTemplateVisitEnd:reportId];
}
//-(void)OnGoTask:(NSString *)reportId
//{
//    [self dismissView:_viewDetail];
//    [self.delegate OnGoTask:reportId];
//}
-(void)setDataVisit:(BVisitData *)dataVisit
{
    _dataVisit=dataVisit;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayTemplate.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPBVisitTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPBVisitTemplateCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPBVisitCell" owner:self options:nil];
        
        cell = [array objectAtIndex:4];
    }
    BVisitTemplate *visitTemplate=[[BVisitTemplate alloc]init];
    visitTemplate=[_arrayTemplate objectAtIndex:indexPath.row];
    cell.visitTemplate=visitTemplate;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BVisitTemplate *visitTemplate=[[BVisitTemplate alloc]init];
    visitTemplate=[_arrayTemplate objectAtIndex:indexPath.row];
    
    if (_visitTemplate==visitTemplate)
    {
        _viewDetail.dataVisit=_dataVisit;
        _viewDetail.storeSelected=_storeSelected;
        _viewDetail.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        
        [self addSubview:_viewDetail];
        _viewDetail.vcFrame=self.vcFrame;
        _viewDetail.delegate=self;
        
        [UIView beginAnimations:nil context:nil];
        _viewDetail.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        _bViewDetail=YES;
    }
    else
    {
        [[RPSDK defaultInstance]GetBVisitTemplateDetail:visitTemplate.strTemplateId Success:^(NSMutableArray *array) {
            _visitTemplate=visitTemplate;
            _dataVisit.arrayCatagory=array;
            _dataVisit.strTemplateId=visitTemplate.strTemplateId;
            _dataVisit.strTemplateName=visitTemplate.strTemplateName;
            _dataVisit.strTemplateDesc=visitTemplate.strTemplateDesc;
            _dataVisit.strCategoryTag=visitTemplate.strCategoryTag;
            _dataVisit.strComment = @"";
            _dataVisit.strTitle = visitTemplate.strTemplateName;
            _dataVisit.strSourceReportId=@"";
            _dataVisit.nStatus=1;
            
            _viewDetail.dataVisit=_dataVisit;
            _viewDetail.storeSelected=_storeSelected;
            _viewDetail.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
            
            [self addSubview:_viewDetail];
            _viewDetail.vcFrame=self.vcFrame;
            _viewDetail.delegate=self;
            
            _viewDetail.strCacheDataId = [[RPSDK defaultInstance] SaveBVisitCacheData:_storeSelected.strStoreId Desc:_storeSelected.strStoreName Data:_dataVisit isNormalExit:YES];
            
            [UIView beginAnimations:nil context:nil];
            _viewDetail.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            _bViewDetail=YES;
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
    }
}

-(void)dismissView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [view endEditing:YES];
}
-(BOOL)OnBack
{
    if (_bViewDetail)
    {
        if ([_viewDetail OnBack]) {
            [self dismissView:_viewDetail];
            _bViewDetail=NO;
        }
        return NO;
    }
    
    return YES;
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}

- (IBAction)OnQuit:(id)sender
{
    [self dismissView:_viewDetail];
    //    _bConfirmQuit = YES;
    [self.delegate OnTemplateVisitEnd:nil];
}
@end
