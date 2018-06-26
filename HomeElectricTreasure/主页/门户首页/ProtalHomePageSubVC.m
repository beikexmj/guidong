//
//  ProtalHomePageSubVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/6/26.
//  Copyright © 2018年 夏明江. All rights reserved.
//

#import "ProtalHomePageSubVC.h"
#import "ProtalHomePageDataModel.h"
#import "MJRefresh.h"
#import "UITableView+WFEmpty.h"
#import "ProtalHomePageTableViewCell.h"
#import "PortalHomePageDetailViewController.h"
@interface ProtalHomePageSubVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger myPage;

}
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)NSMutableArray <ProtalHomePageDataList *>*myArr;

@end

@implementation ProtalHomePageSubVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVHEIGHT - 44 - TABBARHEIGHT) style:UITableViewStylePlain];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    myPage = 0;
    _myArr = [NSMutableArray array];
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        myPage = 0;
        [self fetchData:myPage];
    }];
    _myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        myPage++;
        [self fetchData:myPage];
    }];
    [self fetchData:myPage];

    // Do any additional setup after loading the view.
}
- (void)fetchData:(NSInteger)integer{
    NSString * str = @"news/getnews";
    [ZTHttpTool postWithUrl:str param:@{@"newsType":[NSString stringWithFormat:@"%ld",_newsType],@"page":[NSString stringWithFormat:@"%ld",integer],@"pagesize":@"10"} success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        ProtalHomePageDataModel *protalData = [ProtalHomePageDataModel mj_objectWithKeyValues:str];
        if (protalData.rcode == 0) {
            if (integer == 0) {
                if (protalData.form.list.count == 0) {
                    
                    [_myTableView addEmptyViewWithImageName:@"暂无积分" title:@"暂无新闻"];
                    
                    _myTableView.emptyView.hidden = NO;
                }else{
                    _myTableView.emptyView.hidden = YES;
                }
                [_myArr removeAllObjects];
                [_myArr addObjectsFromArray:protalData.form.list];
                [_myTableView reloadData];
            }else{
                [_myArr addObjectsFromArray:protalData.form.list];
                if (_myArr.count == 0) {
                    [_myTableView addEmptyViewWithImageName:@"暂无积分" title:@"暂无新闻"];
                    [_myTableView.emptyView setHidden:NO];
                }else{
                    [_myTableView.emptyView setHidden:YES];
                }
                if(protalData.form.list.count == 0){
                    [MBProgressHUD showError:@"没有更多数据"];
                    myPage--;
                }else{
                    [_myTableView reloadData];
                }
            }
        }else{
            [_myTableView addEmptyViewWithImageName:@"该时段暂无历史记录" title:@"该时段暂无历史记录"];
            [_myTableView.emptyView setHidden:NO];
            if(integer>0){
                myPage--;
            }
        }
        if (integer != 0) {
            [_myTableView.mj_footer endRefreshing];
        }else{
            [_myTableView.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        [_myTableView addEmptyViewWithImageName:@"暂无网络连接" title:@"网络不给力，请检测您的网络设置"];
        _myTableView.emptyView.hidden = NO;
        if (integer != 0) {
            [_myTableView.mj_footer endRefreshing];
        }else{
            [_myTableView.mj_header endRefreshing];
        }
        if(integer>0){
            myPage--;
        }
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cell4 = @"ProtalHomePageTableViewCell";
    ProtalHomePageTableViewCell *mycell = [tableView dequeueReusableCellWithIdentifier:cell4];
    if (!mycell) {
        mycell = [[[NSBundle mainBundle] loadNibNamed:@"ProtalHomePageTableViewCell" owner:self options:nil] lastObject];
    }
    ProtalHomePageDataList * onceList = _myArr[indexPath.row];
  
    if(onceList){
        mycell.contentHeight.constant = 0;
        mycell.content.hidden = YES;
        if (onceList.up) {
            mycell.topicsMark.hidden = NO;
            mycell.topicsMark2.hidden = NO;
            
        }else{
            mycell.topicsMark.hidden = YES;
            mycell.topicsMark2.hidden = YES;
        }
        if (onceList.layout == 0) {
            mycell.nomalView.hidden = YES;
            mycell.topicsView.hidden = NO;
            mycell.topicsImg.hidden  = NO;
            mycell.topicsImgHeight.constant = (SCREEN_WIDTH - 30)*172/345;
            [mycell.topicsImg sd_setImageWithURL:[NSURL URLWithString:onceList.thumb] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates];
            mycell.time1.text = [StorageUserInfromation timeStrFromDateString:onceList.updateTime];
            mycell.title1.text = onceList.titlePrimary;
        }else if (onceList.layout == 1){
            mycell.nomalView.hidden = NO;
            mycell.topicsView.hidden = YES;
            mycell.nomalImg.hidden = NO;
            mycell.nomalImgWidth.constant = 110;
            mycell.nomalImgToLeft.constant = 15;
            [mycell.nomalImg sd_setImageWithURL:[NSURL URLWithString:onceList.thumb] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates];
            mycell.time2.text = [StorageUserInfromation timeStrFromDateString:onceList.updateTime];
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineSpacing = 3; //设置行间距
            paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0], NSParagraphStyleAttributeName:paraStyle, NSForegroundColorAttributeName:RGBCOLOR(48, 48, 48)};
            NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:onceList.titlePrimary attributes:dic];
            mycell.title2.attributedText = attributeStr;
            
        }else if (onceList.layout == 2){
            mycell.nomalView.hidden = NO;
            mycell.topicsView.hidden = YES;
            mycell.nomalImg.hidden = YES;
            mycell.nomalImgWidth.constant = 0;
            mycell.nomalImgToLeft.constant = 7;
            mycell.time2.text = [StorageUserInfromation timeStrFromDateString:onceList.updateTime];
            
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineSpacing = 3; //设置行间距
            paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0], NSParagraphStyleAttributeName:paraStyle, NSForegroundColorAttributeName:RGBCOLOR(48, 48, 48)};
            NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:onceList.titlePrimary attributes:dic];
            mycell.title2.attributedText = attributeStr;
        }
    }
    
    mycell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return mycell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    ProtalHomePageDataList * onceList =_myArr[indexPath.row];
    
    if(onceList){
        switch (onceList.layout) {
            case 0:
            {
                ;
                return 307-42 - 172 + (SCREEN_WIDTH - 30)*172/345;
            }
                break;
            case 1:
            {
                return 105;
            }
                break;
            case 2:
            {
                if ([StorageUserInfromation getStringSizeWith:onceList.titlePrimary withStringFont:17.0 withWidthOrHeight:SCREEN_WIDTH-30].height<30) {
                    return 105 -21;
                }
                
                return 105;
            }
                break;
                
            default:
                return 105;
                break;
        }
    }else{
        return 105;
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    ProtalHomePageDataList * onceList= _myArr[indexPath.row];
   
    PortalHomePageDetailViewController * page = [[PortalHomePageDetailViewController alloc]init];
    page.onceList = onceList;
    [self.navigationController pushViewController:page animated:YES];
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

@end
