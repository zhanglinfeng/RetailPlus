//
//  AutocompletionTableView.m
//
//  Created by Gushin Arseniy on 11.03.12.
//  Copyright (c) 2012 Arseniy Gushin. All rights reserved.
//

#import "AutocompletionTableView.h"

@interface AutocompletionTableView () 
@property (nonatomic, strong) NSArray *suggestionOptions; // of selected NSStrings 
@property (nonatomic, strong) UITextField *textField; // will set automatically as user enters text
@property (nonatomic, strong) UIFont *cellLabelFont; // will copy style from assigned textfield
@property (nonatomic)CGRect tbFrame;
@end

@implementation AutocompletionTableView

@synthesize suggestionsDictionary = _suggestionsDictionary;
@synthesize suggestionOptions = _suggestionOptions;
@synthesize textField = _textField;
@synthesize cellLabelFont = _cellLabelFont;
@synthesize options = _options;
@synthesize tbFrame=_tbFrame;
#pragma mark - Initialization
- (UITableView *)initWithTextField:(UITextField *)textField inViewController:(UIView *) parentViewController withOptions:(NSDictionary *)options frame:(CGRect)rect
{
    //set the options first
    self.options = options;
//    _vcFrame=parentViewController;
    // frame must align to the textfield
    _tbFrame = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height, rect.size.width, 150);
    
    // save the font info to reuse in cells
    self.cellLabelFont = textField.font;
    
    self = [super initWithFrame:_tbFrame
             style:UITableViewStylePlain];
    self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.separatorColor = [UIColor colorWithWhite:0.8 alpha:1];
    //self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.layer.borderWidth=1;
    self.layer.borderColor=[UIColor colorWithWhite:0.8 alpha:1].CGColor;
    
    self.delegate = self;
    self.dataSource = self;
    self.scrollEnabled = YES;
    
    // turn off standard correction
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    // to get rid of "extra empty cell" on the bottom
    // when there's only one cell in the table
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textField.frame.size.width, 1)]; 
    v.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:v];
    self.hidden = YES;  
    [parentViewController addSubview:self];
//    [_vcFrame.view bringSubviewToFront:self];
    _suggestionsDictionary = [[RPSDK defaultInstance] ReadAutoRemindData:_type];
    return self;
}

-(void)setType:(AutoRemaindType)type
{
    _type = type;
    _suggestionsDictionary = [[RPSDK defaultInstance] ReadAutoRemindData:_type];
}

-(void)setBManualReadSuggest:(BOOL)bManualReadSuggest
{
    if (bManualReadSuggest) {
        [_suggestionsDictionary removeAllObjects];
    }
    _bManualReadSuggest = bManualReadSuggest;
}

#pragma mark - Logic staff
- (BOOL) substringIsInDictionary:(NSString *)subString
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    NSRange range;
    
    for (NSString *tmpString in self.suggestionsDictionary)
    {
        if (_type == AutoRemaindType_EditUserTag && subString.length == 0) {
            [tmpArray addObject:tmpString];
        }
        else
        {
            range = ([[self.options valueForKey:ACOCaseSensitive] isEqualToNumber:[NSNumber numberWithInt:1]]) ? [tmpString rangeOfString:subString] : [tmpString rangeOfString:subString options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound) [tmpArray addObject:tmpString];
        }
    }
    if ([tmpArray count]>0)
    {
        self.suggestionOptions = tmpArray;
        return YES;
    }
    return NO;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"提示行数===%d",self.suggestionOptions.count);
    return self.suggestionOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    
    if ([self.options valueForKey:ACOUseSourceFont]) 
    {
        cell.textLabel.font = [self.options valueForKey:ACOUseSourceFont];
    } else 
    {
        cell.textLabel.font = self.cellLabelFont;
    }
    cell.textLabel.adjustsFontSizeToFitWidth = NO;
    cell.textLabel.text = [self.suggestionOptions objectAtIndex:indexPath.row];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.textField setText:[self.suggestionOptions objectAtIndex:indexPath.row]];
    [self hideOptionsView];
}

#pragma mark - UITextField delegate
- (void)textFieldEditDidBegin:(UITextField *)textField
{
    if (_type==AutoRemaindType_CountTag)
    {
        if (textField.tag==0)
        {
            self.frame=_tbFrame;
        }
        else if(textField.tag==1)
        {
            self.frame=CGRectMake(_tbFrame.origin.x+84, _tbFrame.origin.y, _tbFrame.size.width, _tbFrame.size.height);
        }
        else if(textField.tag==2)
        {
            self.frame=CGRectMake(_tbFrame.origin.x+169, _tbFrame.origin.y, _tbFrame.size.width, _tbFrame.size.height);
        }
    }
    
    if (_type == AutoRemaindType_EditUserTag) {
        self.textField = textField;
        NSString *curString = textField.text;
        if ([self substringIsInDictionary:curString])
        {
            [self showOptionsView];
            [self reloadData];
        }
        else
            [self hideOptionsView];
    }
}

- (void)textFieldEditDidEnd:(UITextField *)textField
{
    if (textField.text.length == 0) return;
    
    for (NSString * str in self.suggestionsDictionary) {
        if ([str isEqualToString:textField.text]) return;
    }
    
    [self.suggestionsDictionary addObject:textField.text];
    
    if (!_bManualReadSuggest)
        [[RPSDK defaultInstance]SaveAutoRemindData:_type Data:self.suggestionsDictionary];
}

- (void) showSuggestView
{
    NSString *curString = _textField.text;
    if (_type == AutoRemaindType_EditUserTag) {
        if ([self substringIsInDictionary:curString])
        {
            [self showOptionsView];
            [self reloadData];
        }
        else
            [self hideOptionsView];
    }
}

- (void)textFieldValueChanged:(UITextField *)textField
{
//    self.suggestionsDictionary = [NSArray arrayWithObjects:@"hostel",@"caret",@"carrot",@"house",@"horse",@"hostel",@"caret",@"carrot",@"house",@"horse",@"hostel",@"caret",@"carrot",@"house",@"horse",@"hostel",@"caret",@"carrot",@"house",@"horse", nil];
    
    self.textField = textField;
    NSString *curString = textField.text;
    
    if (_type == AutoRemaindType_EditUserTag) {
        if ([self substringIsInDictionary:curString])
        {
            [self showOptionsView];
            [self reloadData];
        }
        else
            [self hideOptionsView];
    }
    else
    {
        if (![curString length])
        {
            [self hideOptionsView];
            return;
        } else if ([self substringIsInDictionary:curString])
        {
            [self showOptionsView];
            [self reloadData];
        } else [self hideOptionsView];
    }
}

#pragma mark - Options view control
- (void)showOptionsView
{
    self.hidden = NO;
    if (_suggestionOptions.count < 5) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 30 * _suggestionOptions.count);
    }
    else
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 30 * 5);
    }
}

- (void) hideOptionsView
{
    self.hidden = YES;
}

@end
