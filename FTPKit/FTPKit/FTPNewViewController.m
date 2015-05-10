//
//  FTPNewViewController.m
//  FTPKit
//
//  Created by 陶正凯 on 15/5/10.
//  Copyright (c) 2015年 陶正凯. All rights reserved.
//

#import "FTPNewViewController.h"
#import "FTPConfigTableViewCell.h"

@interface FTPNewViewController()
@property (copy, nonatomic) NSArray *dataSourceList;
@end

static NSString *cellTableIdentifier = @"cellTableIdentifier";
@implementation FTPNewViewController
@synthesize dataSourceList;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSourceList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataSourceList objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FTPConfigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTableIdentifier];
    if (!cell) cell = [[FTPConfigTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTableIdentifier];
    
    NSDictionary *dataDict = [[self.dataSourceList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

//    NSLog(@"%ld, %ld", indexPath.section, indexPath.row);
    cell.labelValue = dataDict[@"name"];
    cell.textValue = dataDict[@"value"];
    
    return cell;
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
    self.dataSourceList = @[@[@{@"name": @"Display Name", @"value": @"FTPServer"}, @{@"name": @"IP Address", @"value": @"192.168.1.100"}], @[@{@"name": @"IP Address", @"value": @"192.168.1.100"}]];
    // tag值见nib布局文件的定义
    UITableView *tableView = (id)[self.view viewWithTag: 999];
    [tableView registerClass:[FTPConfigTableViewCell class] forCellReuseIdentifier:cellTableIdentifier];
    
}
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)doneAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

@end
