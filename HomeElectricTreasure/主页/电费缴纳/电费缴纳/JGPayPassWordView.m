//
//  JGPayPassWordView.m
//  NDP_eHome
//
//  Created by zhuangtao on 16/3/22.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import "JGPayPassWordView.h"
#import "IQKeyboardManager.h"
@interface JGPayPassWordView ()<UITextFieldDelegate>
@property (strong,nonatomic) NSArray *textArr;

@end

@implementation JGPayPassWordView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.isFirstTime = YES;
    //设置是否支付布尔值：NO
    self.isPayed = NO;
    self.payWordField.delegate = self;
    self.actStr = [NSMutableString stringWithString:@""];
    self.textArr = @[self.one,self.two,self.three,self.four,self.five,self.six];
    self.viewHight.constant = (SCREEN_WIDTH-20)/6.0;
    self.payAllMoneyBtn.layer.cornerRadius=3;
    self.cancelBtn.layer.cornerRadius=3;
    self.subPayView.layer.cornerRadius = 5;
    self.subPayView.layer.masksToBounds = YES;
    [IQKeyboardManager sharedManager].enable = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
    
//    self.superViewHight.constant = 220+(SCREEN_WIDTH-20)/6.0;
//    self.onewidth.constant = self.twoWidth.constant = self.threeWidth.constant = self.foreWidht.constant = self.fiveWidth.constant = self.sexWidth.constant = (SCREEN_WIDTH-21-20)/6.0;
//    self.fourCenterx.constant = ((SCREEN_WIDTH-21-20)/6.0)/2.0+1.5;
    for (UITextField *objTextF in self.textArr) {
        objTextF.layer.borderColor=[StorageUserInfromation stringTOColor:@"#E7E7E7"].CGColor;
        objTextF.layer.borderWidth=0.5 ;
    }
    [self.payWordField becomeFirstResponder];
    
}
- (void)showKeyBoard:(NSNotification *)info{
//    [IQKeyboardManager sharedManager].enable = NO;
//    NSDictionary *userInfo = [info userInfo];
//    CGRect keyBoardBounds = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//
//    if (self.isFirstTime) {
        CGFloat distant;
        if (SCREEN_WIDTH == 320) {
            distant = 270-45;
        }else if (SCREEN_WIDTH == 375){
            distant = 285-45;
        }else if(SCREEN_WIDTH == 414) {
            distant = 300-45;
        }else{
            distant = 300-45;
        }
    [UIView animateWithDuration:0.3 animations:^{
        self.viewBottomToSuperView.constant = distant;
        [self layoutSubviews];

    }];
        self.isFirstTime = NO;

//    }
//    else{
//        [UIView animateWithDuration:0.3 animations:^{
//        self.subPayView.frame = CGRectMake(10, SCREEN_HEIGHT - keyBoardBounds.size.height - 10 - 190 - (SCREEN_WIDTH - 20)/6.0 , SCREEN_WIDTH - 20, 190 + (SCREEN_WIDTH - 20)/6.0);
//        }];
//    }
    
    
}
- (void)hideKeyBoard:(NSNotification *)info{
   
    [UIView animateWithDuration:0.5 animations:^{
//        self.viewBottomToSuperView.constant = SCREEN_HEIGHT/2.0 - (220 + self.viewHight.constant)/2.0;
       
        
    }];
    NSDictionary *userInfo = [info userInfo];
    CGRect keyBoardBound = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.3 animations:^{
//        self.subPayView.frame = CGRectMake(10, SCREEN_HEIGHT/2.0 - 110 - (SCREEN_WIDTH - 20)/12.0 , SCREEN_WIDTH - 20, 190 + (SCREEN_WIDTH - 20)/6.0);
        self.subPayView.frame = CGRectMake(10, SCREEN_HEIGHT - keyBoardBound.size.height - 10 - 190 - (SCREEN_WIDTH - 20)/6.0 , SCREEN_WIDTH - 20, 190 + (SCREEN_WIDTH - 20)/6.0);
//        self.viewBottomToSuperView.constant = 164;
        [self layoutSubviews];
        [self.subPayView layoutSubviews];

    }];
    [IQKeyboardManager sharedManager].enable = YES;

}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //清空输入框
    if ([string isEqualToString:@""]) {
        for (int i = 0  ; i < 6; i++) {
            UITextField *one = self.textArr[i];
            
            if (i == one.tag ) {
                one.text = @"";
            }
            
        }
        self.actStr = [NSMutableString stringWithString:@""];
        self.payWordField.text = @"";
        
    }else{
        self.actStr = (NSMutableString *)[self.actStr stringByAppendingString:string];
        for (int i = 0; i < self.actStr.length; i++) {
            if (i==0) {
                self.one.text = @"*";
            }
            if (i==1) {
                self.two.text = @"*";
            }
            if (i==2) {
                self.three.text = @"*";
            }
            if (i==3)
            {
                self.four.text = @"*";
            }
            if (i==4) {
                self.five.text = @"*";
            }
            if (i==5) {
                self.six.text = @"*";
            }
        }
    }
    if (self.actStr.length > 5) {
        
        [self.payWordField resignFirstResponder];
        if ([self.delegate respondsToSelector:@selector(textFieldHaveSixNumberForView)]) {
            [self.delegate textFieldHaveSixNumberForView];
        }

    }
    
    return  YES;
}


@end
