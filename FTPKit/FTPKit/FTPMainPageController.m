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
#import "FTPServersListViewCell.h"


@interface FTPMainPageController ()

@property (weak, nonatomic) IBOutlet UITableView *serverTableItems;
@property (strong, nonatomic) NSMutableArray *myFTPServers;
@end

static NSString *cellTableIdentifier = @"cellTableIdentifier";
@implementation FTPMainPageController
@synthesize myFTPServers;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myFTPServers = [[NSMutableArray alloc] initWithCapacity:10];
    // 加载自定义cell
    UITableView *tableView = (id)[self.view viewWithTag: 666];
    [tableView registerClass:[FTPServersListViewCell class] forCellReuseIdentifier:cellTableIdentifier];
    
    // 添加消息监控
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"addFTPServer" object:nil];
}

- (void) reloadTableView: (NSNotification *) aNotification{
    // 测试消息通知功能是否正常
    FTPServerModel *model = [aNotification object];
//    [model logObject];
    [self.myFTPServers addObject:model];
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
    FTPServersListViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellTableIdentifier];
    if (!myCell) myCell = [[FTPServersListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTableIdentifier];
    FTPServerModel *modelData = [self.myFTPServers objectAtIndex:indexPath.row];
    myCell.labelValue1 = modelData.serverAddress;
    myCell.labelValue2 = modelData.serverName;

    return myCell;
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
