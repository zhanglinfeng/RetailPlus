//
//  RPELExamViewController.m
//  RetailPlus
//
//  Created by lin dong on 14-7-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPELExamViewController.h"

#import "SVProgressHUD.h"
#import "RPExamListCell.h"

extern NSBundle * g_bundleResorce;
@interface RPELExamViewController ()

@end

@implementation RPELExamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _viewHeader.layer.cornerRadius=10;
    _viewSearch.layer.cornerRadius=5;
    _arrayAllPaper=[[NSMutableArray alloc]init];
    _arraySubmitPaper=[[NSMutableArray alloc]init];
    _arraySearch=[[NSMutableArray alloc]init];
    _bExpand=NO;
//    _arrayExpand=[[NSMutableArray alloc]init];
    [self loadData];
    [self addPaperTemp:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadData
{
//    NSMutableArray *arrayPaper=[[NSMutableArray alloc]init];
//    NSMutableArray *arrayQuestions=[[NSMutableArray alloc]init];
//    //************************第一组**************************//
//    ////////////第一张卷子//////////
//    RPELQuestion *question=[[RPELQuestion alloc]init];
//    question.strId=@"001";
//    question.strNo=@"#001";
//    question.strTitle=@"数学题";
//    question.strDesc=@"开始一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一加一等于几一几一加一等于几";
//    question.strThumbUrl=@"";
//    question.questionsType=RPELQuestionType_SingleChoice;
//    question.arrayOption=[NSMutableArray arrayWithObjects:@"A、1",@"B、10",@"C、题意不明",@"D、4", nil];
//    [arrayQuestions addObject:question];
//    question=[[RPELQuestion alloc]init];
//    question.strId=@"002";
//    question.strNo=@"#002";
//    question.strTitle=@"语文题";
//    question.strDesc=@"下面那首诗是李白的";
//    question.strThumbUrl=@"";
//    question.questionsType=RPELQuestionType_SingleChoice;
//    question.arrayOption=[NSMutableArray arrayWithObjects:@"A、蜀道难，难于上青天",@"B、垂死病中惊坐起",@"C、笑问客从何处来",@"D、会当凌绝顶", nil];
//    [arrayQuestions addObject:question];
//    question=[[RPELQuestion alloc]init];
//    question.strId=@"003";
//    question.strNo=@"#003";
//    question.strTitle=@"智力题";
//    question.strDesc=@"一公斤水可以浮起一公斤铁吗";
//    question.strThumbUrl=@"";
//    question.questionsType=RPELQuestionType_SingleChoice;
//    question.arrayOption=[NSMutableArray arrayWithObjects:@"A、不能，铁密度比水大",@"B、能，把铁做成空心的",@"C、不能，排水体积不够",@"D、不能", nil];
//    [arrayQuestions addObject:question];
//    
//    RPELPaper *paper=[[RPELPaper alloc]init];
//    paper.strId=@"01";
//    paper.strNo=@"2010";
//    paper.strType=@"期中考试";
//    paper.strTitle=@"数学考试";
//    paper.strReminder=@"禁止舞弊";
//    paper.arrayQuestions=arrayQuestions;
//    paper.nScore=88;
//    [arrayPaper addObject:paper];
//    
//    
//    ///////////第二张卷子///////////
//    arrayQuestions=[[NSMutableArray alloc]init];
//    question=[[RPELQuestion alloc]init];
//    question.strId=@"001";
//    question.strNo=@"#001";
//    question.strTitle=@"数学题";
//    question.strDesc=@"一加一等于几";
//    question.strThumbUrl=@"";
//    question.questionsType=RPELQuestionType_SingleChoice;
//    question.arrayOption=[NSMutableArray arrayWithObjects:@"A、1",@"B、10",@"C、题意不明",@"D、4", nil];
//    [arrayQuestions addObject:question];
//    question=[[RPELQuestion alloc]init];
//    question.strId=@"002";
//    question.strNo=@"#002";
//    question.strTitle=@"语文题";
//    question.strDesc=@"下面那首诗是李白的，呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵";
//    question.strThumbUrl=@"";
//    question.questionsType=RPELQuestionType_SingleChoice;
//    question.arrayOption=[NSMutableArray arrayWithObjects:@"A、蜀道难，难于上青天",@"B、垂死病中惊坐起",@"C、笑问客从何处来",@"D、会当凌绝顶", nil];
//    [arrayQuestions addObject:question];
//    
//    paper=[[RPELPaper alloc]init];
//    paper.strId=@"01";
//    paper.strNo=@"2010";
//    paper.strType=@"期中考试";
//    paper.strTitle=@"语文考试";
//    paper.strReminder=@"禁止舞弊";
//    paper.arrayQuestions=arrayQuestions;
//    paper.nScore=88;
//    [arrayPaper addObject:paper];
//
//    RPELPaperList *paperList=[[RPELPaperList alloc]init];
//    paperList.arrayRPELPaper=arrayPaper;
//    paperList.strType=@"期中考试";
//    paperList.bExpand=YES;
//    [_arrayAllPaper addObject:paperList];
//    //************************第二组**************************//
//    ////////////第一张卷子//////////
//    arrayQuestions=[[NSMutableArray alloc]init];
//    arrayPaper=[[NSMutableArray alloc]init];
//    question=[[RPELQuestion alloc]init];
//    question.strId=@"001";
//    question.strNo=@"#001";
//    question.strTitle=@"数学题";
//    question.strDesc=@"一加一等于几";
//    question.strThumbUrl=@"";
//    question.questionsType=RPELQuestionType_SingleChoice;
//    question.arrayOption=[NSMutableArray arrayWithObjects:@"A、1",@"B、10",@"C、题意不明",@"D、4", nil];
//    [arrayQuestions addObject:question];
//    question=[[RPELQuestion alloc]init];
//    question.strId=@"002";
//    question.strNo=@"#002";
//    question.strTitle=@"语文题";
//    question.strDesc=@"下面那首诗是李白的，哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈";
//    question.strThumbUrl=@"";
//    question.questionsType=RPELQuestionType_SingleChoice;
//    question.arrayOption=[NSMutableArray arrayWithObjects:@"A、蜀道难，难于上青天",@"B、垂死病中惊坐起",@"C、笑问客从何处来",@"D、会当凌绝顶", nil];
//    [arrayQuestions addObject:question];
//    
//    paper=[[RPELPaper alloc]init];
//    paper.strId=@"01";
//    paper.strNo=@"2010";
//    paper.strType=@"期中考试";
//    paper.strTitle=@"数学考试";
//    paper.strReminder=@"禁止舞弊";
//    paper.arrayQuestions=arrayQuestions;
//    paper.nScore=88;
//    [arrayPaper addObject:paper];
//    
//    
//    ///////////第二张卷子///////////
//    arrayQuestions=[[NSMutableArray alloc]init];
//    question=[[RPELQuestion alloc]init];
//    question.strId=@"001";
//    question.strNo=@"#001";
//    question.strTitle=@"数学题";
//    question.strDesc=@"一加一等于几";
//    question.strThumbUrl=@"";
//    question.questionsType=RPELQuestionType_SingleChoice;
//    question.arrayOption=[NSMutableArray arrayWithObjects:@"A、1",@"B、10",@"C、题意不明",@"D、4", nil];
//    [arrayQuestions addObject:question];
//    question=[[RPELQuestion alloc]init];
//    question.strId=@"002";
//    question.strNo=@"#002";
//    question.strTitle=@"语文题";
//    question.strDesc=@"下面那首诗是李白的";
//    question.strThumbUrl=@"";
//    question.questionsType=RPELQuestionType_SingleChoice;
//    question.arrayOption=[NSMutableArray arrayWithObjects:@"A、蜀道难，难于上青天",@"B、垂死病中惊坐起",@"C、笑问客从何处来",@"D、会当凌绝顶", nil];
//    [arrayQuestions addObject:question];
//    
//    paper=[[RPELPaper alloc]init];
//    paper.strId=@"01";
//    paper.strNo=@"2010";
//    paper.strType=@"期中考试";
//    paper.strTitle=@"语文考试";
//    paper.strReminder=@"禁止舞弊";
//    paper.arrayQuestions=arrayQuestions;
//    paper.nScore=88;
//    [arrayPaper addObject:paper];
//    
//    paperList=[[RPELPaperList alloc]init];
//    paperList.arrayRPELPaper=arrayPaper;
//    paperList.strType=@"期末考试";
//    paperList.bExpand=YES;
//    [_arrayAllPaper addObject:paperList];
    [[RPSDK defaultInstance]GetPaperListSuccess:^(NSMutableArray *arrayResult) {
        _arrayAllPaper=arrayResult;
        _arraySearch=_arrayAllPaper;
        [_tbExamList reloadData];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
    }];

}
-(void)OnNavBack
{
    [self DoNavBack];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        RPExamUploadCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPExamUploadCell"];
        if (cell==nil)
        {
            NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPExamUploadCell" owner:self options:nil];
            cell=[arrayNib objectAtIndex:0];
        }
//        cell.paper=[_arraySubmitPaper objectAtIndex:indexPath.row];
        cell.doc=[_arraySubmitPaper objectAtIndex:indexPath.row];
        cell.delegate=self;
        return cell;
    }
    else
    {
        RPExamListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPExamListCell"];
        if (cell==nil)
        {
            NSArray *arrayNib=[g_bundleResorce loadNibNamed:@"RPExamListCell" owner:self options:nil];
            cell=[arrayNib objectAtIndex:0];
        }
        cell.paper=[((RPELPaperList*)[_arraySearch objectAtIndex:indexPath.section-1]).arrayRPELPaper objectAtIndex:indexPath.row];
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0) {
        _examViewController=[[RPExamViewController alloc]initWithNibName:NSStringFromClass([RPExamViewController class]) bundle:g_bundleResorce];
        _examViewController.delegate=self.delegate;
        //    _examViewController.delegateAddRecord=self;
        //    _examViewController.vcFrame=self.vcFrame;
        //    _examViewController.sn=_snSum;
        //    _examViewController.storeSelected=_storeSelected;
        _examViewController.paper=[((RPELPaperList*)[_arraySearch objectAtIndex:indexPath.section-1]).arrayRPELPaper objectAtIndex:indexPath.row];
        _examViewController.delegateSubmit=self;
        [self.navigationController pushViewController:_examViewController animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        if (_arraySubmitPaper.count==0)
        {
            return 0;
        }
        return 54;
    }
    else
    {
        return 32;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if (_arraySubmitPaper.count==0)
        {
            return 0;
        }
        return 46;
    }
    else
    {
        return 54;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        if (_bExpand)
        {
            return _arraySubmitPaper.count;
        }
        else
        {
            return 0;
        }
        
    }
    else
    {

        if (((RPELPaperList*)[_arraySearch objectAtIndex:section-1]).bExpand)
        {
            return ((RPELPaperList*)[_arraySearch objectAtIndex:section-1]).arrayRPELPaper.count;
        }
        else
        {
            return 0;
        }
        
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section==0)
    {
        RPExamUploadHeaderView * view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RPExamUploadHeaderView"];
        if (view == nil) {
            view = [[[NSBundle mainBundle] loadNibNamed:@"RPExamUploadHeaderView" owner:nil options:nil] objectAtIndex:0];
            view.delegate = self;
        }
        
        view.backgroundColor=[UIColor clearColor];
        view.ivTriangle.hidden=!_bExpand;
        view.lbPaperCount.text=[NSString stringWithFormat:@"%i",_arraySubmitPaper.count];
        return view;
    }
    else
    {
        RPExamHeaderview * view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RPExamHeaderview"];
        if (view == nil) {
            view = [[[NSBundle mainBundle] loadNibNamed:@"RPExamHeaderview" owner:nil options:nil] objectAtIndex:0];
        }
        view.delegate=self;
//        view.section=section;
        view.paperList=(RPELPaperList *)[_arraySearch objectAtIndex:section-1];
        view.backgroundColor=[UIColor clearColor];
        if (view.paperList.bExpand)
        {
            view.ivTriangle.image=[UIImage imageNamed:@"icon_arrow_down_white@2x.png"];
        }
        else
        {
            view.ivTriangle.image=[UIImage imageNamed:@"icon_arrow_right_white@2x.png"];
        }
        return view;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arraySearch.count+1;
}

- (IBAction)OnDeleteSearch:(id)sender
{
    _tfSearch.text=@"";
    _arraySearch=_arrayAllPaper;
    [_tbExamList reloadData];
}
-(void)OnUpLoadAll
{
    NSInteger i=0;
    NSInteger m=_arraySubmitPaper.count;
    for (Document *doc in _arraySubmitPaper)
    {
        i++;
        [[RPSDK defaultInstance]SubmitCacheData:doc.dataUnSent Success:^(id idResult) {
            
            if (i==m)
            {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTableInBundle(@"Submit Success",@"RPString", g_bundleResorce,nil)];
            }
            [_arraySubmitPaper removeObject:doc];
            [_tbExamList reloadData];
            [self loadData];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
        }];
    }
    
    
}
-(void)OnExpand
{
    _bExpand=!_bExpand;
    [_tbExamList reloadData];
}
-(void)OnExpandExamHeader:(RPELPaperList *)paperList
{
//    NSNumber *num=[NSNumber numberWithInteger:section];
//    for (num in _arrayExpand )
//    {
//        [_arrayExpand removeObject:num];
//        [_tbExamList reloadData];
//        return;
//    }
//    
//    [_arrayExpand addObject:[NSNumber numberWithInteger:section]];
//    paperList.bExpand=!paperList.bExpand;
    [_tbExamList reloadData];
}

-(IBAction)OnQuit:(id)sender
{
    [self.view endEditing:YES];
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to exit?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            [self DoQuit];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
    
    
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self.view];
}

-(void)addPaperTemp:(RPELPaper *)paper
{
    _arraySubmitPaper= [[RPSDK defaultInstance]GetPaperCacheList:CACHETYPE_ELEARNINGEXAM];
    //    [_arraySubmitPaper addObject:paper];
    [self loadData];
    [_tbExamList reloadData];
    
}
-(void)endUpload:(Document *)doc
{
    [self loadData];
    [_arraySubmitPaper removeObject:doc];
    [_tbExamList reloadData];
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
        RPELPaperList *paperList=[array objectAtIndex:i];
        NSMutableArray *arrayPaper= [[NSMutableArray alloc] init];
        for (int j=0; j<paperList.arrayRPELPaper.count; j++)
        {
            RPELPaper *paper=[paperList.arrayRPELPaper objectAtIndex:j];
            NSRange res1 = [paper.strTitle rangeOfString:str options:NSCaseInsensitiveSearch];
            NSRange res2 = [paper.strNo rangeOfString:str options:NSCaseInsensitiveSearch];
            if ((res1.length != 0  || res2.length != 0 ))
            {
                [arrayPaper addObject:paper];
            }
        }
        if (arrayPaper.count>0)
        {
            RPELPaperList *rpELPaperList=[[RPELPaperList alloc]init];
            rpELPaperList.strType=paperList.strType;
            rpELPaperList.bExpand=YES;
            rpELPaperList.arrayRPELPaper=arrayPaper;
            [arrayResult addObject:rpELPaperList];
        }
        
        
        
    }
    
    return arrayResult;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _arraySearch=[self genSearchArray:_arrayAllPaper condition:_tfSearch.text];
    [_tbExamList reloadData];
    return YES;
}
@end
