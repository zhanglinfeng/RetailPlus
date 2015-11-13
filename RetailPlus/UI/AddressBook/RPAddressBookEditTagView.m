//
//  RPAddressBookEditTagView.m
//  RetailPlus
//
//  Created by lin dong on 14-8-25.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPAddressBookEditTagView.h"
#import "SVProgressHUD.h"

@implementation RPAddressBookEditTagView

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationTapped:)];
    [_viewMask addGestureRecognizer:tap];
}

- (void)locationTapped:(UITapGestureRecognizer *)tap
{
    [self removeFromSuperview];
}

-(void)setColleague:(UserDetailInfo *)colleague
{
    _colleague = colleague;
    [_tfTag becomeFirstResponder];
    [_autoCompleter showSuggestView];
}

-(AutocompletionTableView*)autoCompleter
{
    if (!_autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        //计算套在输入框外面的View相对对输入框父视图的位置大小
        CGPoint p=[_ivBg.superview convertPoint:_ivBg.frame.origin toView:self];
        CGRect rect=CGRectMake(p.x + 3, p.y - 3, 136, _ivBg.frame.size.height);
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:_tfTag inViewController:self withOptions:options frame:rect];
        _autoCompleter.type = AutoRemaindType_EditUserTag;
        _autoCompleter.bManualReadSuggest = YES;
    }
    return _autoCompleter;
}

-(void)setNTagIndex:(NSInteger)nTagIndex
{
    _nTagIndex = nTagIndex;
    
    switch (_nTagIndex) {
        case 0:
            _tfTag.text = _colleague.strTag1;
            break;
        case 1:
            _tfTag.text = _colleague.strTag2;
            break;
        case 2:
            _tfTag.text = _colleague.strTag3;
            break;
        default:
            break;
    }
    
    [_tfTag addTarget:self.autoCompleter action:@selector(textFieldEditDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    
    [_tfTag addTarget:self.autoCompleter action:@selector(textFieldEditDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
    [_tfTag addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [SVProgressHUD showWithStatus:@""];
    [[RPSDK defaultInstance] GetExistUserTagSuccess:^(id idResult) {
        _autoCompleter.suggestionsDictionary = idResult;
        [SVProgressHUD dismiss];
        [_autoCompleter showSuggestView];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD dismiss];
    }];
}

-(IBAction)OnDeleteTag:(id)sender
{
    _tfTag.text = @"";
    [_autoCompleter showSuggestView];
}

-(IBAction)OnOK:(id)sender
{
    NSString * strTag1 = _colleague.strTag1;
    NSString * strTag2 = _colleague.strTag2;
    NSString * strTag3 = _colleague.strTag3;
    
    switch (_nTagIndex) {
        case 0:
            strTag1 = _tfTag.text;
            _colleague.strTag1 = _tfTag.text;
            break;
        case 1:
            strTag2 = _tfTag.text;
            _colleague.strTag2 = _tfTag.text;
            break;
        case 2:
            strTag3 = _tfTag.text;
            _colleague.strTag3 = _tfTag.text;
            break;
        default:
            break;
    }
    
    [SVProgressHUD showWithStatus:@""];
    
    [[RPSDK defaultInstance] SetUserTags:_colleague.strUserId Tag1:strTag1 Tag2:strTag2 Tag3:strTag3 Success:^(id idResult) {
        switch (_nTagIndex) {
            case 0:
                _colleague.strTag1 = _tfTag.text;
                break;
            case 1:
                _colleague.strTag2 = _tfTag.text;
                break;
            case 2:
                _colleague.strTag3 = _tfTag.text;
                break;
            default:
                break;
        }
        [self.delegate OnEditTagEnd];
        [self removeFromSuperview];
        
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD dismiss];
    }];
    
    
}
@end
