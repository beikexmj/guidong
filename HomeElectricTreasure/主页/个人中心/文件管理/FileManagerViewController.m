//
//  FileManagerViewController.m
//  copooo
//
//  Created by kerwin on 2018/6/26.
//  Copyright © 2018年 夏明江. All rights reserved.
//

#import "FileManagerViewController.h"

static NSString *const kFileManagerTableViewCell = @"com.copticomm.cell.filemanager";

@interface FileManagerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView        *tableView;
@property (weak, nonatomic) IBOutlet UILabel            *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBackgroundHeight;

@end

@implementation FileManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareTableView];
}

- (void)configurationNavigation
{
    if (kDevice_Is_iPhoneX) {
        self.navigationBackgroundHeight.constant = 86;
        self.titleLabel.font = [UIFont systemFontOfSize:18.0];
    }
}

- (void)prepareTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFileManagerTableViewCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:kFileManagerTableViewCell];
    }
    cell.textLabel.text = @"文件名称.pdf";
    cell.detailTextLabel.text = @"2018-06-26    09:20:50";
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

#pragma mark - ACTION

- (IBAction)onBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onManagePressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.tableView.allowsMultipleSelection = sender.selected;
    [self.tableView setEditing:sender.selected animated:YES];
}

@end
