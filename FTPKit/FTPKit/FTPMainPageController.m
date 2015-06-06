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
#import "FTPModifyViewController.h"


@interface FTPMainPageController ()

@property (weak, nonatomic) IBOutlet UITableView *serverTableItems;
@property (strong, nonatomic) NSMutableArray *myFTPServers;
@end

static NSString *cellTableIdentifier = @"cellTableIdentifier";
static NSString *dataPlist = @"FTPServerData.plist";
@implementation FTPMainPageController
@synthesize myFTPServers;

- (void)viewWillAppear:(BOOL)animated {
    [self.serverTableItems deselectRowAtIndexPath:[self.serverTableItems indexPathForSelectedRow] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myFTPServers = [[NSMutableArray alloc] initWithCapacity:10];
//    if ([self isFileExist:dataPlist]) {
//        // 测试文件是否存在
//        NSLog(@"kkk:::");
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
//        NSString *plistPath = [paths objectAtIndex:0];
//        NSString *fileName = [plistPath stringByAppendingPathComponent:dataPlist];
//        self.myFTPServers = [[NSMutableArray alloc] initWithContentsOfFile:fileName];
//    }
    // TODO : write to plist file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *fileName = [plistPath stringByAppendingPathComponent:dataPlist];
    // 解析modelData
    //        NSMutableArray *data = [modelData wrapData];
    NSLog(@"zzz:::");
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:fileName];
    [data setObject:@"sssasa" forKey:@"taozhengkai"];
    [data writeToFile:fileName atomically:YES];
    NSLog(@"%@----%@", fileName, [[NSMutableDictionary alloc] initWithContentsOfFile:fileName]);
    // 加载自定义cell
    UITableView *tableView = (id)[self.view viewWithTag: 666];
    [tableView registerClass:[FTPServersListViewCell class] forCellReuseIdentifier:cellTableIdentifier];
    
    // 添加消息监控
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"addFTPServer" object:nil];
}

- (BOOL) isFileExist: (NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    return [manager fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:dataPlist]];
}
- (void) customeAddObject: (FTPServerModel *)modelData {
    NSString *serverName = modelData.serverName;
    NSInteger index = -1;
    for (FTPServerModel *model in self.myFTPServers) {
        if ([serverName isEqualToString:model.serverName]) {
            index = [self.myFTPServers indexOfObject:model];
            break;
        }
    }
    // 替换当前的数据, 写入文件保存
    if (index > -1) {
        [self.myFTPServers removeObjectAtIndex:index];
        
    }
    [self.myFTPServers addObject:modelData];
}

- (void) reloadTableView: (NSNotification *) aNotification{
    // 测试消息通知功能是否正常
    FTPServerModel *model = [aNotification object];
//    [model logObject];
    [self customeAddObject:model];
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
    myCell.imageName2 = @"modify.png";
    [myCell addTag:indexPath.row];
    UITapGestureRecognizer *guesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [myCell addTapGuestureRecongnizer:guesture];
    
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myViewIndentifier = @"FTPShowFilesViewController";
    FTPShowFilesViewController *showFilesViewController = [self.storyboard instantiateViewControllerWithIdentifier:myViewIndentifier];
    FTPServerModel *model = [self.myFTPServers objectAtIndex:indexPath.row];
    [showFilesViewController initWithString:model.serverName];
    [self.navigationController pushViewController:showFilesViewController animated:true];
}

- (void)imageTapped:(UIGestureRecognizer *)guesture {
    CGPoint location = [guesture locationInView:self.serverTableItems];
    NSIndexPath *indexPath = [self.serverTableItems indexPathForRowAtPoint:location];
    if (!indexPath) return;
    FTPServerModel *model = [self.myFTPServers objectAtIndex:indexPath.row];
    static NSString *myViewIndentifier = @"FTPModifyViewController";
    FTPModifyViewController *modifyViewController = [self.storyboard instantiateViewControllerWithIdentifier:myViewIndentifier];
    [modifyViewController initWithModelData:model];
    [self.navigationController pushViewController:modifyViewController animated:true];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
