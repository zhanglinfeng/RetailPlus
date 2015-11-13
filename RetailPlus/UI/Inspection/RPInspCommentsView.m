//
//  RPInspCommentsView.m
//  RetailPlus
//
//  Created by lin dong on 13-12-31.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPInspCommentsView.h"
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;

@implementation RPInspCommentsView

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
    
    _viewMark.layer.cornerRadius = 6;
    _viewMark.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewMark.layer.borderWidth = 1;
    
    _viewComments.layer.cornerRadius = 6;
    _viewComments.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewComments.layer.borderWidth = 1;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    [self addGestureRecognizer:tap];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [self endEditing:YES];
}

-(void)UpdateMark
{
    [_btnMark1 setSelected:NO];
    [_btnMark2 setSelected:NO];
    [_btnMark3 setSelected:NO];
    [_btnMark4 setSelected:NO];
    [_btnMark5 setSelected:NO];
    
    switch (_dataInsp.mark) {
        case MARK_1:
            [_btnMark1 setSelected:YES];
            _lbMarkDesc.text = NSLocalizedStringFromTableInBundle(@"BAD",@"RPString", g_bundleResorce,nil);
            break;
        case MARK_2:
            [_btnMark1 setSelected:YES];
            [_btnMark2 setSelected:YES];
            _lbMarkDesc.text = NSLocalizedStringFromTableInBundle(@"NORMAL",@"RPString", g_bundleResorce,nil);
            break;
        case MARK_3:
            [_btnMark1 setSelected:YES];
            [_btnMark2 setSelected:YES];
            [_btnMark3 setSelected:YES];
            _lbMarkDesc.text = NSLocalizedStringFromTableInBundle(@"GOOD",@"RPString", g_bundleResorce,nil);
            break;
        case MARK_4:
            [_btnMark1 setSelected:YES];
            [_btnMark2 setSelected:YES];
            [_btnMark3 setSelected:YES];
            [_btnMark4 setSelected:YES];
            _lbMarkDesc.text = NSLocalizedStringFromTableInBundle(@"GREAT",@"RPString", g_bundleResorce,nil);
            break;
        case MARK_5:
            [_btnMark1 setSelected:YES];
            [_btnMark2 setSelected:YES];
            [_btnMark3 setSelected:YES];
            [_btnMark4 setSelected:YES];
            [_btnMark5 setSelected:YES];
            _lbMarkDesc.text = NSLocalizedStringFromTableInBundle(@"EXCELLENT",@"RPString", g_bundleResorce,nil);
            break;
        default:
            break;
    }
}

-(IBAction)OnMark:(id)sender
{
    if (_dataInsp.mark == MARK_1 + ((UIButton *)sender).tag - 100)
        _dataInsp.mark = MARK_NONE;
    else
        _dataInsp.mark = MARK_1 + ((UIButton *)sender).tag - 100;
    
    [self UpdateMark];
}

-(void)setDataInsp:(InspData *)dataInsp
{
    _dataInsp = dataInsp;
    _tvComments.text = dataInsp.strDesc;
    [self UpdateMark];
}
-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{
    _storeSelected=storeSelected;
}
-(BOOL)OnBack
{
    _dataInsp.strDesc = _tvComments.text;
    return YES;
}

-(IBAction)OnOk:(id)sender
{
    if (_tvComments.text.length>RPMAX_DESC_LENGTH)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Comments length should not exceed 300 characters",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    _dataInsp.strDesc = _tvComments.text;
    [self.delegate OnAddCommentsEnd];
}

-(IBAction)OnCache:(id)sender
{
    _dataInsp.strDesc = _tvComments.text;
    [[RPSDK defaultInstance] SaveInspCacheData:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:_dataInsp isNormalExit:YES];//添加该代码于2014年04月21
    [self.delegate OnQuitComments];
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}
@end
