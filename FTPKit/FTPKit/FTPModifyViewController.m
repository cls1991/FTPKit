//
//  FTPModifyViewController.m
//  FTPKit
//
//  Created by 陶正凯 on 15/5/10.
//  Copyright (c) 2015年 陶正凯. All rights reserved.
//

#import "FTPModifyViewController.h"
#import "FTPConfigTableViewCell.h"
#import "FTPServerModel.h"

@interface FTPModifyViewController()
@property (strong, nonatomic) NSMutableArray *dataSourceList;
@property (strong, nonatomic) FTPConfigTableViewCell *cell;
@property (weak, nonatomic) IBOutlet UITableView *ftpModifyItemTableView;
@property (strong, nonatomic) FTPServerModel *modelData;

@end

static NSString *tableCellIdentifier = @"tableCellIdentifier";
@implementation FTPModifyViewController
@synthesize dataSourceList;
@synthesize modelData = _modelData;

- (FTPServerModel *)modelData {
    if (!_modelData) _modelData = [[FTPServerModel alloc] init];
    return _modelData;
}

- (void)initWithModelData:(FTPServerModel *)modelData {
    // TODO 解析传递的模型数据
    self.dataSourceList = [[NSMutableArray alloc] initWithCapacity:2];
    // 从plist文件加载资源
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"FTPDefaultItems" ofType:@"plist"];
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    for (NSMutableArray *array in dataArray) {
        for (NSMutableDictionary *dict in array) {
            [dict setValue:[modelData getValue:dict[@"name"]] forKey:@"value"];
        }
    }
    self.dataSourceList = dataArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSourceList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataSourceList objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    if (!self.cell) self.cell = [[FTPConfigTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
    
    NSMutableDictionary *dataDict = [[self.dataSourceList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    self.cell.labelValue = dataDict[@"name"];
    self.cell.textValue = dataDict[@"value"];
    [self.modelData setValue:self.cell.textValue matchWithKey:self.cell.labelValue];
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
    // tag值见nib布局文件的定义
    UITableView *tableView = (id)[self.view viewWithTag: 9999];
    [tableView registerClass:[FTPConfigTableViewCell class] forCellReuseIdentifier:tableCellIdentifier];
}
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)doneAction:(UIBarButtonItem *)sender {
    // 添加逻辑保护
    if ([self.modelData checkValues]) [[NSNotificationCenter defaultCenter] postNotificationName:@"addFTPServer" object:self.modelData];
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
    [self.ftpModifyItemTableView reloadData];
}


@end

