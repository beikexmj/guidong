//
//  ServiceAndNoticeDetailViewController.m
//  copooo
//
//  Created by 夏明江 on 16/9/14.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "ServiceAndNoticeDetailViewController.h"
#import "ServiceAndNoticeDetailView.h"
@interface ServiceAndNoticeDetailViewController ()

@end

@implementation ServiceAndNoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    self.myScrollView.backgroundColor = [UIColor whiteColor];
    self.myScrollView.layer.cornerRadius = 5;
    self.myScrollView.layer.masksToBounds = YES;
    ServiceAndNoticeDetailView * serView = [[[NSBundle mainBundle] loadNibNamed:@"ServiceAndNoticeDetailView" owner:self options:nil] lastObject];
    serView.typeTitle.text = _myDict.title;
    serView.content.text = _myDict.content;
    
    if ([_myDict.type integerValue]== 1) {
        serView.type.text = @"告警通知";
    }else if ([_myDict.type integerValue]== 2){
        serView.type.text = @"停电通知";
    }else if ([_myDict.type integerValue]== 3){
        serView.type.text = @"复电通知";
    }else if ([_myDict.type integerValue]== 4){
        serView.type.text = @"缴费通知";
    }else if ([_myDict.type integerValue]== 5){
        serView.type.text = @"服务通知";
    }
    serView.time.text = [StorageUserInfromation minuteDescription:_myDict.createTime];

    CGSize typeTitleSize = [serView.typeTitle sizeThatFits:CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT)];
    CGSize contentSize = [serView.content sizeThatFits:CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT)];
    serView.titleHight.constant = typeTitleSize.height;
    serView.contentHight.constant = contentSize.height;
    serView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 51+8+serView.titleHight.constant +serView.contentHight.constant+10);
    [self.myScrollView addSubview:serView];
    self.myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 51+8+serView.titleHight.constant +serView.contentHight.constant+10);

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
