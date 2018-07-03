//
//  FileManagerViewController.m
//  copooo
//
//  Created by kerwin on 2018/6/26.
//  Copyright © 2018年 夏明江. All rights reserved.
//

#import "FileManagerViewController.h"
#import "UIColor+WB.h"
#import "UIView+Frame.h"
#import "CopoooDBManager.h"
#import "FileBrowserViewController.h"
#import "UITableView+WFEmpty.h"

static NSString *const kFileManagerTableViewCell = @"com.copticomm.cell.filemanager";

@interface FileManagerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView        *tableView;
@property (weak, nonatomic) IBOutlet UILabel            *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBackgroundHeight;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteTopConstraint;

@property (nonatomic, strong) NSMutableArray<CopoooDBDataModel *> *dataSource;

@property (weak, nonatomic) IBOutlet UIButton *manageButton;
@end

@implementation FileManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurationNavigation];
    [self prepareTableView];
    
    [self.deleteButton setBackgroundImage:[UIColor colorWithHex:0x9c9c9c].toImage forState:UIControlStateDisabled];
    [self.deleteButton setBackgroundImage:[UIColor colorWithHex:0x00a7ff].toImage forState:UIControlStateNormal];
    
    NSArray<CopoooDBDataModel *> *models = [CopoooDBManager fetchDB:FileTypePDF];
    if (models) {
        [self.dataSource addObjectsFromArray:models];
        [self.tableView reloadData];
    }
    [self showEmptyView:self.dataSource.count == 0];
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
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
}

- (void)showMutipleEditing
{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.deleteButton.frame.size.height, 0);
    [UIView animateWithDuration:0.25 animations:^{
        self.deleteTopConstraint.constant = -49;
        [self.view layoutIfNeeded];
    }];
}

- (void)hideMutipleEditing
{
    self.deleteButton.enabled = NO;
    self.tableView.contentInset = UIEdgeInsetsZero;
    [UIView animateWithDuration:0.25 animations:^{
        self.deleteTopConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

- (void)removeFileWithIndexPath:(NSIndexPath *)indexPath
{
    CopoooDBDataModel *model = self.dataSource[indexPath.row];
    [CopoooDBManager deleteDB:model.name contactId:model.type];
    NSString *filePath = [self filePathWithName:model.name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

- (NSString *)filePathWithName:(NSString *)name {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [documentPath stringByAppendingPathComponent:name];
}

- (void)showEmptyView:(BOOL)isEmpty
{
    if (isEmpty) {
        [self.tableView addEmptyViewWithImageName:@"暂无文件下载记录" title:@"暂无文件"];
    } else {
        [self.tableView.emptyView removeFromSuperview];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFileManagerTableViewCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:kFileManagerTableViewCell];
        cell.textLabel.textColor = RGBCOLOR(48, 48, 48);
        cell.detailTextLabel.textColor = RGBCOLOR(156, 156, 156);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    CopoooDBDataModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.name;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd    HH:mm:ss";
    cell.detailTextLabel.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.time]];
    cell.imageView.image = [UIImage imageNamed:@"my_pdf"];
    return cell;
}

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.allowsMultipleSelection ? (UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert) : UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeFileWithIndexPath:indexPath];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        [self showEmptyView:self.dataSource.count == 0];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!tableView.allowsMultipleSelection) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        FileBrowserViewController *browserViewController = [[FileBrowserViewController alloc] init];
        browserViewController.fileURL = [NSURL fileURLWithPath:[self filePathWithName:self.dataSource[indexPath.row].name]];
        [self.navigationController pushViewController:browserViewController animated:YES];
    } else {
        self.deleteButton.enabled = tableView.indexPathsForSelectedRows.count != 0;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.allowsMultipleSelection) {
        self.deleteButton.enabled = tableView.indexPathsForSelectedRows.count != 0;
    }
}

#pragma mark - ACTION

- (IBAction)onBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onManagePressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.tableView.allowsMultipleSelection = sender.selected;
    [self.tableView setEditing:sender.selected animated:YES];
    if (sender.selected) {
        [self showMutipleEditing];
    } else {
        [self hideMutipleEditing];
    }
}

- (IBAction)onMultipleDeletePressed:(UIButton *)sender {
    NSMutableArray *removeItems = @[].mutableCopy;
    __weak typeof(self) weakSelf = self;
    [self.tableView.indexPathsForSelectedRows enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf removeFileWithIndexPath:obj];
        [removeItems addObject:strongSelf.dataSource[obj.row]];
    }];
    [self.dataSource removeObjectsInArray:removeItems];
    [self.tableView deleteRowsAtIndexPaths:self.tableView.indexPathsForSelectedRows
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [self onManagePressed:self.manageButton];
    [self showEmptyView:self.dataSource.count == 0];
}

#pragma mark - getter

- (NSMutableArray<CopoooDBDataModel *> *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

@end
