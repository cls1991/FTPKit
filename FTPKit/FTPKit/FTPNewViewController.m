//
//  FTPNewViewController.m
//  FTPKit
//
//  Created by 陶正凯 on 15/5/10.
//  Copyright (c) 2015年 陶正凯. All rights reserved.
//

#import "FTPNewViewController.h"

@interface FTPNewViewController()
@property (copy, nonatomic) NSArray *dataSourceList;
@end

@implementation FTPNewViewController
@synthesize dataSourceList;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentifier = @"configItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    cell.textLabel.text = [self.dataSourceList objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.dataSourceList = @[@"hello", @"开源中国"];
}
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)doneAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:true];
}




@end
