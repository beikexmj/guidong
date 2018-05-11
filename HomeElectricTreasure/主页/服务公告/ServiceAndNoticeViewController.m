//
//  ServiceAndNoticeViewController.m
//  copooo
//
//  Created by 夏明江 on 16/9/13.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "ServiceAndNoticeViewController.h"
#import "ServiceAndNoticeTableViewCell.h"
#import "ServiceAndNoticeDetailViewController.h"
#import "ServiceAndNoticeDataModle.h"
#import "MJRefresh.h"
#import "HomePageViewController.h"
#import "AppDelegate.h"
#import "UITableView+WFEmpty.h"

@class ServiceAndNoticeDataModle;
@interface ServiceAndNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger page;
    NSInteger unreadCount;
    NSMutableArray *deleteArr;
    NSMutableArray<NSIndexPath *> *deleteIndexPathArr;
}
@property (nonatomic,strong)NSMutableArray<List *> *myArray;
@end

@implementation ServiceAndNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    page = 0;
    _cancelBtn.hidden = YES;
    _deleteBtn.hidden = YES;
    _myArray = [NSMutableArray array];
    deleteArr = [NSMutableArray array];
    deleteIndexPathArr = [NSMutableArray array];
    self.myTableView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    [self fetchData:NO];//NO 下拉刷新，首次初始化 ； YES 上拉刷新
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_myArray removeAllObjects];
        page = 0;
        [self fetchData:NO];
        //Call this Block When enter the refresh status automatically
    }];
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self fetchData:YES];
        //Call this Block When enter the refresh status automatically
    }];
//    self.myTableView.editing = YES;

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)fetchData:(BOOL)flag{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"pagesize":@"10",@"position":[NSString stringWithFormat:@"%ld",flag?_myArray.count:0]};

    [ZTHttpTool postWithUrl:@"user/electricNotice/getNotices" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        ServiceAndNoticeDataModle *serviceAndNotice = [ServiceAndNoticeDataModle mj_objectWithKeyValues:str];
        if (serviceAndNotice.rcode == 0) {
            if (serviceAndNotice.form.list.count == 0) {
                if (flag == YES) {
                    page--;
                    [MBProgressHUD showError:@"没有更多数据"];

                }
            }
            [_myArray addObjectsFromArray:serviceAndNotice.form.list];
            if (_myArray.count ==0) {
                _deleteBtn.hidden = YES;
//                if (flag == NO) {
//                    [MBProgressHUD showError:@"无公告信息"];
//                    for (UIView * myView in self.myTableView.subviews) {
//                        if ([myView isEqual:self.myTableView.emptyView]) {
//                            [myView removeFromSuperview];
//                        }
//                    }
                    [self.myTableView addEmptyViewWithImageName:@"暂无公告" title:@"暂无公告"];
                    self.myTableView.emptyView.hidden = NO;
//                }else{

//                }

            }else{
                _deleteBtn.hidden = NO;
                self.myTableView.emptyView.hidden = YES;

            }
            [deleteArr removeAllObjects];
            [deleteIndexPathArr removeAllObjects];
            AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            HomePageViewController *vc = [delegate.window.rootViewController childViewControllers][0];
            unreadCount = serviceAndNotice.form.unreadCount;
            if (serviceAndNotice.form.unreadCount <= 0) {
//                _myTitle.text = @"服务公告";
                if ([vc isKindOfClass:[HomePageViewController class]]) {
                    [vc.myTabBar items][1].badgeValue = nil;
                }

            }else{
//                _myTitle.text = [NSString stringWithFormat:@"服务公告(%ld)",serviceAndNotice.form.unreadCount];
                if (unreadCount<=99) {
//                    [vc.myTabBar items][1].badgeValue = [NSString stringWithFormat:@"%ld",unreadCount];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"fetchDataWithNotice2" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",unreadCount], @"num",nil]];

                }else{
//                    [vc.myTabBar items][1].badgeValue = @"99+";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"fetchDataWithNotice2" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"99+", @"num",nil]];

                }
                
            }
            unreadCount = serviceAndNotice.form.unreadCount;
            [self.myTableView reloadData];
        }else{
            [self.myTableView addEmptyViewWithImageName:@"暂无公告" title:@"暂无公告"];
            self.myTableView.emptyView.hidden = NO;
        }
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [self.myTableView addEmptyViewWithImageName:@"暂无网络连接" title:@"网络不给力，请检测您的网络设置"];
        self.myTableView.emptyView.hidden = NO;

    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableView 代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myCell = @"ServiceAndNoticeTableViewCell";
    ServiceAndNoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:myCell owner:self options:nil] lastObject];
    }
    cell.editing = NO;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_myArray.count>0) {
       List *list = (List*)_myArray[indexPath.row];
        cell.typeTitle.text = list.title;
        cell.content.text = list.content;//[NSString stringWithFormat:@"计划停电时间：%@\n计划送电时间：%@\n影响范围：%@",list.createTime,list.endTime,list.position];
        cell.time.text = [StorageUserInfromation minuteDescription:list.createTime];
        if ([list.type integerValue]== 1) {
            cell.type.text = @"告警通知";
        }else if ([list.type integerValue]== 2){
            cell.type.text = @"停电通知";
        }else if ([list.type integerValue]== 3){
            cell.type.text = @"复电通知";
        }else if ([list.type integerValue]== 4){
            cell.type.text = @"缴费通知";
        }else if ([list.type integerValue]== 5){
            cell.type.text = @"服务通知";
        }
        if ([list.status integerValue]== 0) {// 0未读 1已读
            cell.isReadFlag.hidden = NO;
        }else{
            cell.isReadFlag.hidden = YES;
        }
    }
    
  
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _myArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 10;
//}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
//    view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
//    return view;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.myTableView.editing) {
        [deleteArr addObject:_myArray[indexPath.row]];
        [deleteIndexPathArr addObject:indexPath];
        if (deleteArr.count!=0) {
            [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            [_deleteBtn setTitleColor:[UIColor colorWithRed:226/255.0 green:23.0/255 blue:23/255.0 alpha:1] forState:UIControlStateNormal];
        }
    }else{
        if ([_myArray[indexPath.row].status integerValue]==0) {
            [self isReadIndexPath:indexPath.row];
        }
        ServiceAndNoticeDetailViewController * pages = [[ServiceAndNoticeDetailViewController alloc]init];
        List * list  = (List*)_myArray[indexPath.row];
        pages.myDict = list;
        [self.myTableView reloadData];
        [self.navigationController pushViewController:pages animated:YES];
    }
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [deleteArr removeObject:_myArray[indexPath.row]];
    [deleteIndexPathArr removeObject:indexPath];
    if (deleteArr.count == 0) {
        [_deleteBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor colorWithRed:128/255.0 green:128.0/255 blue:128/255.0 alpha:1] forState:UIControlStateNormal];
    }
    
}

//选择你要对表进行处理的方式  默认是删除方式

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (flag) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;

    }
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;

}
//进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [deleteArr addObject:_myArray[indexPath.row]];
        [deleteIndexPathArr addObject:indexPath];
        // Delete the row from the data source.
        [self deleteNotice];

    }
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
//-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    self.myTableView.editing = YES;
////    [self.myTableView reloadData];
//    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        [deleteArr addObject:_myArray[indexPath.row]];
//        [deleteIndexPathArr addObject:indexPath];
//        // Delete the row from the data source.
//        [self deleteNotice];
//    };
//
//    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:rowActionHandler];
//    action1.backgroundColor = [UIColor redColor];
//
//
//    return @[action1];
//}


- (void)isReadIndexPath:(NSInteger)indexPathSec{
    List *onceList = _myArray[indexPathSec];
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"noticeId":onceList.ids,@"device":@"1"};
    [ZTHttpTool postWithUrl:@"user/electricNotice/setRead" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue]==0) {
            _myArray[indexPathSec].status = @"1";
            unreadCount--;
//            AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            HomePageViewController *vc = [delegate.window.rootViewController childViewControllers][0];
            if (unreadCount <= 0) {
//                _myTitle.text = @"服务公告";
//                [vc.myTabBar items][1].badgeValue = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"fetchDataWithNotice2" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"", @"num",nil]];

                
            }else{
//                _myTitle.text = [NSString stringWithFormat:@"服务公告(%ld)",unreadCount];
                if (unreadCount<=99) {
//                    [vc.myTabBar items][1].badgeValue = [NSString stringWithFormat:@"%ld",unreadCount];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"fetchDataWithNotice2" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",unreadCount], @"num",nil]];

                }else{
//                    [vc.myTabBar items][1].badgeValue = @"99+";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"fetchDataWithNotice2" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"99+", @"num",nil]];

                }
            }
            
            [self.myTableView reloadData];
        }else{
            [MBProgressHUD showError:[DictToJson dictionaryWithJsonString:str][@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

static BOOL flag = YES;

- (IBAction)deleteBtnClick:(id)sender {
    
    if (flag) {
        [_deleteBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:RGBCOLOR(128, 128, 128) forState:UIControlStateNormal];
        self.myTableView.editing = YES;
        _cancelBtn.hidden = NO;
        flag = !flag;
        [self.myTableView reloadData];
        
    }else{
        flag = !flag;
        [_deleteBtn setTitle:@"管理" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:RGBCOLOR(128, 128, 128) forState:UIControlStateNormal];
        self.myTableView.editing = NO;
        if (deleteArr.count != 0) {
            [self deleteNotice];
        }
        _cancelBtn.hidden = YES;
//        [self.myTableView reloadData];

    }
    
    
}
- (void)deleteNotice{
    NSMutableArray * onceArray = [NSMutableArray array];
    for (List * list in deleteArr) {
        [onceArray addObject:list.ids];
    }
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"noticeId":onceArray,@"device":@"1"};
    [MBProgressHUD showMessage:@"删除中..."];
    [ZTHttpTool postWithUrl:@"user/electricNotice/delete" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        [MBProgressHUD hideHUD];
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue]==0) {
            for (List * list in deleteArr) {
                if ([list.status integerValue] == 0) {
                    unreadCount--;
                }
            }
            
            AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            HomePageViewController *vc = [delegate.window.rootViewController childViewControllers][0];
            if (unreadCount <= 0) {
//                _myTitle.text = @"服务公告";
                [vc.myTabBar items][1].badgeValue = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"fetchDataWithNotice2" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"", @"num",nil]];

                
            }else{
//                _myTitle.text = [NSString stringWithFormat:@"服务公告(%ld)",unreadCount];
                if (unreadCount<=99) {
//                    [vc.myTabBar items][1].badgeValue = [NSString stringWithFormat:@"%ld",unreadCount];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"fetchDataWithNotice2" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",unreadCount], @"num",nil]];

                }else{
//                    [vc.myTabBar items][1].badgeValue = @"99+";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"fetchDataWithNotice2" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"99+", @"num",nil]];

                }
            }
            
            [_myArray removeObjectsInArray:deleteArr];
            [deleteArr removeAllObjects];
            if (_myArray.count ==0) {
                _deleteBtn.hidden = YES;
//                for (UIView * myView in self.myTableView.subviews) {
//                    if ([myView isEqual:self.myTableView.emptyView]) {
//                        [myView removeFromSuperview];
//                    }
//                }
                [self.myTableView addEmptyViewWithImageName:@"暂无公告" title:@"暂无公告"];
                self.myTableView.emptyView.hidden = NO;

            }else{
                _deleteBtn.hidden = NO;
                self.myTableView.emptyView.hidden = YES;
            }
            [self.myTableView deleteRowsAtIndexPaths:deleteIndexPathArr withRowAnimation:UITableViewRowAnimationRight];
            if(_myArray.count>=1){
                ServiceAndNoticeTableViewCell * cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [cell endEditing:YES];
//                [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
           
            [deleteIndexPathArr removeAllObjects];
        }else{
            [self.myTableView addEmptyViewWithImageName:@"暂无公告" title:@"暂无公告"];
            self.myTableView.emptyView.hidden = NO;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",error);
        [self.myTableView addEmptyViewWithImageName:@"暂无网络连接" title:@"网络不给力，请检测您的网络设置"];
        self.myTableView.emptyView.hidden = NO;
    }];
    
    

}
- (IBAction)cancelBtnClick:(id)sender {
    [deleteArr removeAllObjects];
    self.myTableView.editing = NO;
    _cancelBtn.hidden = YES;
    flag = !flag;
    [_deleteBtn setTitle:@"管理" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:RGBCOLOR(128, 128, 128) forState:UIControlStateNormal];
    [self.myTableView reloadData];
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!_cancelBtn.hidden) {
        [self cancelBtnClick:nil];
    }
}

@end
