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
@property (strong, nonatomic) NSMutableArray *dataSourceList;
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
    
    NSMutableDictionary *dataDict = [[self.dataSourceList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    self.cell.labelValue = dataDict[@"name"];
    self.cell.textValue = dataDict[@"value"];
    [self.dataModel setValue:self.cell.textValue matchWithKey:self.cell.labelValue];
    // 添加textfield代理
    [self.cell setDelegate:self];
    // 添加Tag
    [self.cell addTag:((indexPath.section + 1) * 10 + indexPath.row)];
    
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
    self.dataSourceList = [[NSMutableArray alloc] initWithCapacity:2];
    // tag值见nib布局文件的定义
    UITableView *tableView = (id)[self.view viewWithTag: 999];
    [tableView registerClass:[FTPConfigTableViewCell class] forCellReuseIdentifier:cellTableIdentifier];
    
    // 从plist文件加载资源
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"FTPDefaultItems" ofType:@"plist"];
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    self.dataSourceList = dataArray;
}
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)doneAction:(UIBarButtonItem *)sender {
    // 添加逻辑保护
    if ([self.dataModel checkValues]) [[NSNotificationCenter defaultCenter] postNotificationName:@"addFTPServer" object:self.dataModel];
    [self.navigationController popViewControllerAnimated:true];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    // 返回TextField所属的cell
    NSInteger section = textField.tag / 10 - 1;
    NSInteger row = textField.tag % 10;
    self.dataSourceList[section][row][@"value"] = textField.text;
    // 更新数据源
    [self.ftpNewItemTableView reloadData];
}


@end
