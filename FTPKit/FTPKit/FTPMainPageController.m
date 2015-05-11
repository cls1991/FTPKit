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
#import "FTPServerModel.h"


@interface FTPMainPageController ()
@property (weak, nonatomic) IBOutlet UITableView *serverTableItems;
@property (strong, nonatomic) NSMutableArray *myFTPServers;
@end

@implementation FTPMainPageController
@synthesize myFTPServers;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myFTPServers = [[NSMutableArray alloc] initWithCapacity:10];
    [self.myFTPServers addObject:@"hello"];
    
    NSLog(@"%@", self.myFTPServers);
    // 添加消息监控
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"addFTPServer" object:nil];
}

- (void) reloadTableView: (NSNotification *) aNotification{
    // 测试消息通知功能是否正常
    FTPServerModel *model = [aNotification object];
//    [model logObject];
    [self.myFTPServers addObject:model.loginUsername];
    // 刷新tableview的数据
    [self.serverTableItems reloadData];
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
    static NSString *myViewIndentifier = @"FTPShowFilesViewController";
    FTPShowFilesViewController *showFilesViewController = [self.storyboard instantiateViewControllerWithIdentifier:myViewIndentifier];
    [showFilesViewController initWithString:[self.myFTPServers objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:showFilesViewController animated:true];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
