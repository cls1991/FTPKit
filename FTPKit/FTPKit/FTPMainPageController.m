//
//  SecondViewController.m
//  FTPKit
//
//  Created by 陶正凯 on 15/5/8.
//  Copyright (c) 2015年 陶正凯. All rights reserved.
//

#import "FTPMainPageController.h"
#import "FTPShowFilesViewController.h"
#import "FTPNewViewController.h"

@interface FTPMainPageController ()
@property (strong, nonatomic) NSArray *myFTPServers;
@end

@implementation FTPMainPageController
@synthesize myFTPServers;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myFTPServers = [NSArray arrayWithObjects:@"asd", @"hello", nil];
}
- (IBAction)clickTest:(UIBarButtonItem *)sender {
    static NSString *myViewIndentifier = @"FTPNewViewController";
    FTPNewViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:myViewIndentifier];
    [self.navigationController pushViewController:newViewController animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myFTPServers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ftpServersItem = @"serversItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ftpServersItem];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ftpServersItem];
    cell.textLabel.text = [self.myFTPServers objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: 切换到选中的server页面
    static NSString *myViewIndentifier = @"FTPShowFilesViewController";
    FTPShowFilesViewController *showFilesViewController = [self.storyboard instantiateViewControllerWithIdentifier:myViewIndentifier];
    [showFilesViewController initWithString:[self.myFTPServers objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:showFilesViewController animated:true];
}


@end
