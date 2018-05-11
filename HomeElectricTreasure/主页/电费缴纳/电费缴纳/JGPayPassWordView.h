//
//  JGPayPassWordView.h
//  NDP_eHome
//
//  Created by zhuangtao on 16/3/22.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JGPayPassWordViewDelegate<NSObject>
-(void)textFieldHaveSixNumberForView;
@end

@interface JGPayPassWordView : UIView


@property (weak, nonatomic) IBOutlet UIView *subPayView;


@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *one;
@property (weak, nonatomic) IBOutlet UITextField *two;
@property (weak, nonatomic) IBOutlet UITextField *four;

@property (weak, nonatomic) IBOutlet UITextField *three;
@property (weak, nonatomic) IBOutlet UITextField *five;
@property (weak, nonatomic) IBOutlet UITextField *six;
@property (weak, nonatomic) IBOutlet UITextField *payWordField;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *payAllMoneyBtn;

@property (strong,nonatomic)NSMutableString *actStr;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwd;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHight;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *superViewHight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomToSuperView;

@property (nonatomic,assign) BOOL isFirstTime;

@property (nonatomic,assign) BOOL isPayed;

@property (nonatomic,weak)id<JGPayPassWordViewDelegate>delegate;

@end
