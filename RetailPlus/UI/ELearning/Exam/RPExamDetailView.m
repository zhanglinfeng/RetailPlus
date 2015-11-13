//
//  RPExamDetailView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-25.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPExamDetailView.h"
#import "RPExamOptionCell.h"
#import "UIImageView+WebCache.h"
#import "RPShowImgViewController.h"
#import "RPAppDelegate.h"
#import "RPMainViewController.h"

@implementation RPExamDetailView

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
    _ivTemp=[[UIImageView alloc]init];
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationTapped:)];
//    [_ivQuestion addGestureRecognizer:tap];
//    _ivQuestion.userInteractionEnabled=YES;
//    tap.cancelsTouchesInView=NO;//为yes只响应优先级最高的事件，Button高于手势，textfield高于手势，textview高于手势，手势高于tableview。为no同时都响应，默认为yes
}
- (void)locationTapped:(UITapGestureRecognizer *)tap
{
    RPShowImgViewController * vcWeb = [[RPShowImgViewController alloc] initWithNibName:NSStringFromClass([RPShowImgViewController class]) bundle:nil];
    
    RPAppDelegate * app = (RPAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.viewController presentViewController:vcWeb animated:YES completion:^{
        [vcWeb SetImageUrl:_question.strThumbUrl];
    }];
}
-(void)loadViewFrame
{
    _tbOption.scrollEnabled = NO;
    
    _lbQuestion.frame=CGRectMake(_lbQuestion.frame.origin.x, _lbQuestion.frame.origin.y, _lbQuestion.frame.size.width, [self calcLabelHeight:_question.strTitle]);
    if (_ivQuestion.image)
    {
        _ivQuestion.frame=CGRectMake(_ivQuestion.frame.origin.x, _lbQuestion.frame.size.height+_lbQuestion.frame.origin.y+10, 140,88);
    }
    else
    {
        _ivQuestion.frame=CGRectMake(_ivQuestion.frame.origin.x, _lbQuestion.frame.size.height+_lbQuestion.frame.origin.y, 0,0);
    }
    
    _viewQuestion.frame=CGRectMake(_viewQuestion.frame.origin.x, _viewQuestion.frame.origin.y, _viewQuestion.frame.size.width, _lbQuestion.frame.size.height+_ivQuestion.frame.size.height+32);
    _tbOption.frame=CGRectMake(_tbOption.frame.origin.x, _viewQuestion.frame.size.height+10, _tbOption.frame.size.width, 38*_question.arrayOption.count);
//    NSLog(@"%f=======",_tbOption.frame.size.height);
//    NSLog(@"%f=======",_viewQuestion.frame.size.height);
    self.contentSize = CGSizeMake(self.frame.size.width - 1, _viewQuestion.frame.size.height+_tbOption.frame.size.height+8);
//     NSLog(@"%f=======",self.contentSize.height);
//    self.contentSize = CGSizeMake(self.frame.size.width - 1, 800);
    self.bounces = NO;
}
-(NSInteger)calcLabelHeight:(NSString *)strText
{
    NSInteger nLableHeight = 20;
    
    CGSize size = [strText sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(287, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    if (size.height >20) {
        nLableHeight = size.height;
    }
    else
    {
        nLableHeight = 20;
    }
    
    return nLableHeight+10;
}

-(void)setQuestion:(RPELQuestion *)question
{
    
    _question=question;
    _lbQuestion.text=_question.strTitle;
    __block RPExamDetailView *blockSelf = self;
     blockSelf.ivQuestion.image = nil;
    __block UITableView * tbOption = _tbOption;
    
    [_ivTemp setImageWithURLString:_question.strThumbUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            blockSelf.ivQuestion.image=image;
        }
        [blockSelf loadViewFrame];
        [tbOption reloadData];
    }];
    
    [self loadViewFrame];
    [_tbOption reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (_question.arrayAnswers.count>0)
//    {
//        _arrayAnswers=_question.arrayAnswers;
//    }
//    else
//    {
//        _arrayAnswers=[[NSMutableArray alloc]init];
//    }
    
    if (_question.arrayAnswers==nil)
    {
        _question.arrayAnswers=[NSMutableArray arrayWithCapacity:1];
    }

    RPExamOptionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPExamOptionCell"];
    if (cell==nil)
    {
        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPExamOptionCell" owner:self options:nil];
        cell=[arrayNib objectAtIndex:0];
    }
    if (_question.questionsType==1 )
    {
        cell.ivSelect.image=[UIImage imageNamed:@"icon_single_check_white@2x.png"];
    }
    else
    {
        cell.ivSelect.image=[UIImage imageNamed:@"icon_multi_check_white@2x.png"];
    }
    cell.Option=[_question.arrayOption objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPExamOptionCell *cell=(RPExamOptionCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.Option.bSelect = !cell.Option.bSelect;
    if (cell.Option.bSelect)
    {
//        [_arrayAnswers addObject:[_question.arrayOption objectAtIndex:indexPath.row]];
        if (_question.questionsType==1)//单选
        {
            //将点击行以外的行都设置为未选择
            for (RPELOption *option in _question.arrayOption)
            {
                if (cell.Option!=option)
                {
                    option.bSelect=NO;
                }
            }
            [_question.arrayAnswers removeAllObjects];
            [_question.arrayAnswers addObject:[_question.arrayOption objectAtIndex:indexPath.row]];
            
        }
        else
        {
            [_question.arrayAnswers addObject:[_question.arrayOption objectAtIndex:indexPath.row]];
        }
        
       
    }
    else
    {
//        [_arrayAnswers removeObject:[_question.arrayOption objectAtIndex:indexPath.row]];
        [_question.arrayAnswers removeObject:[_question.arrayOption objectAtIndex:indexPath.row]];
    }
    [_tbOption reloadData];
//     _question.arrayAnswers=_arrayAnswers;
    [self.delegateSelect selectOption];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _question.arrayOption.count;
}
@end
