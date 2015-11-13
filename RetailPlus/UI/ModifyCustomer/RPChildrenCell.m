//
//  RPNewCustomerCell.m
//  RetailPlus
//
//  Created by zwhe on 13-12-19.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPChildrenCell.h"
//
//@implementation RPChildrenCell
//
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}
//
//
//-(void)awakeFromNib
//{
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationTapped:)];
//    [self addGestureRecognizer:tap];
//
//}
//
//- (void)locationTapped:(UITapGestureRecognizer *)tap
//{
//    [self endEditing:YES];
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
//
//-(void)setChild:(MyChildren *)child
//{
////    _child=child;
////    NSString *age=[NSString stringWithFormat:@"%d",child.age];
////    [_btSex setTitle:child.sex forState:UIControlStateNormal];
////    _tfAge.text=age;
////    _tfAge.keyboardType=UIKeyboardTypeDecimalPad;
////    [_tfAge addTarget:self action:@selector(saveAge) forControlEvents:UIControlEventEditingChanged];
//    
//    
//    _child=child;
//    _tvChildren.text=child.childrenInfo;
//
//}
//-(void)textViewDidEndEditing:(UITextView *)textView
//{
//    _child.childrenInfo=_tvChildren.text;
//}
//
//
////-(void)saveAge
////{
////    NSLog(@"====%@",_tfAge.text);
////    
////    _child.age=[_tfAge.text intValue];
////}
//
//- (IBAction)OnchooseSex:(id)sender {
//    
//    
//    [_customerCellDelegate OnSelectSex:_child Index:_i];
//}
//
////- (IBAction)OnChooseAge:(id)sender {
////    [_customerCellDelegate OnSelectAge:_child Index:_i];
////}
//- (IBAction)OnDelete:(id)sender {
//    [_customerCellDelegate OnDeleteChild:_child];
//}
//@end
