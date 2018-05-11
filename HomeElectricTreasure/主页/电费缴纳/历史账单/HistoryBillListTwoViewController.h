//
//  HistoryBillListTwoViewController.h
//  copooo
//
//  Created by 夏明江 on 2017/1/22.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryBillListTwoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
- (IBAction)NextOrBeforeYearBtnClick:(id)sender;//tag = 10 上一年，tag =20 下一年
- (IBAction)backlBtnClick:(id)sender;
@property (nonatomic,strong)NSString *accountNo;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@end
