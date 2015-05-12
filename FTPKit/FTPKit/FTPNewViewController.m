//
//  FTPNewViewController.m
//  FTPKit
//
//  Created by 陶正凯 on 15/5/10.
//  Copyright (c) 2015年 陶正凯. All rights reserved.
//

#import "FTPNewViewController.h"
#import "FTPConfigTableViewCell.h"
#import "FTPServerModel.h"

@interface FTPNewViewController()
@property (copy, nonatomic) NSMutableArray *dataSourceList;
@property (strong, nonatomic) FTPConfigTableViewCell *cell;
@property (weak, nonatomic) IBOutlet UITableView *ftpNewItemTableView;
@property (strong, nonatomic) FTPServerModel *dataModel;
@end

static NSString *cellTableIdentifier = @"cellTableIdentifier";
@implementation FTPNewViewController
@synthesize dataSourceList;
@synthesize dataModel = _dataModel;

- (FTPServerModel *)dataModel {
    if (!_dataModel) _dataModel = [[FTPServerModel alloc] init];
    return _dataModel;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSourceList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataSourceList objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.cell = [tableView dequeueReusableCellWithIdentifier:cellTableIdentifier];
    if (!self.cell) self.cell = [[FTPConfigTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTableIdentifier];
    
    NSDictionary *dataDict = [[self.dataSourceList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

//    NSLog(@"%ld, %ld", indexPath.section, indexPath.row);
    self.cell.labelValue = dataDict[@"name"];
    self.cell.textValue = dataDict[@"value"];
    [self.dataModel setValue:self.cell.textValue matchWithKey:self.cell.labelValue];
    // 测试数据是否刷新
    [self.cell setDelegate:self];
    [self.dataModel logObject];
    
    return self.cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"FTP Connection";
            break;
        case 1:
            return @"Login Info";
            break;
        default:
            return @"";
            break;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
            if (0 == indexPath.row || 1 == indexPath.row) {
                return nil;
            }
            break;
        case 1:
            return nil;
            break;
        default:
            break;
    }
    
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
            NSLog(@"%@", [[self.dataSourceList objectAtIndex:section] objectAtIndex:indexPath.row]);
            break;
        default:
            break;
    }
}


- (void) viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[@[@{@"name": @"Display Name", @"value": @"FTPServer"}, @{@"name": @"IP Address", @"value": @"192.168.1.100"}], @[@{@"name": @"UserName", @"value": @"tzk"}, @{@"name": @"Password", @"value": @"asd123"}]];
    self.dataSourceList = [[NSMutableArray alloc] initWithArray:array];
    // tag值见nib布局文件的定义
    UITableView *tableView = (id)[self.view viewWithTag: 999];
    [tableView registerClass:[FTPConfigTableViewCell class] forCellReuseIdentifier:cellTableIdentifier];
}
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)doneAction:(UIBarButtonItem *)sender {
//    FTPServerModel *model = [[FTPServerModel alloc] init];
//    model.serverName = @"86 Server";
//    model.serverAddress = @"192.168.1.100";
//    model.loginUsername = @"tzk";
//    model.loginPasswd = @"asd123";
    // 强制刷新tableview的datasource
    [self.ftpNewItemTableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addFTPServer" object:self.dataModel];
    [self.navigationController popViewControllerAnimated:true];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%@", textField.text);
//    [self.dataSourceList addObject:@{@"name": @"Just Test", @"value": @"Just Test!!!"}];
}


@end
