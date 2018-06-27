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

static NSString *const kFileManagerTableViewCell = @"com.copticomm.cell.filemanager";

@interface FileManagerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView        *tableView;
@property (weak, nonatomic) IBOutlet UILabel            *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBackgroundHeight;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteTopConstraint;


@end

@implementation FileManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurationNavigation];
    [self prepareTableView];
    
    [self.deleteButton setBackgroundImage:[UIColor colorWithHex:0x9c9c9c].toImage forState:UIControlStateDisabled];
    [self.deleteButton setBackgroundImage:[UIColor colorWithHex:0x00a7ff].toImage forState:UIControlStateNormal];
    
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
        cell.textLabel.textColor = RGBCOLOR(48, 48, 48);
        cell.detailTextLabel.textColor = RGBCOLOR(156, 156, 156);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = @"文件名称.pdf";
    cell.detailTextLabel.text = @"2018-06-26    09:20:50";
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
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!tableView.allowsMultipleSelection) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
}

@end
