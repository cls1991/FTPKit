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
@property NSInteger index;
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
    
    self.index = -1;
    self.myFTPServers = [[NSMutableArray alloc] initWithCapacity:10];
    if ([self isFileExist:dataPlist]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *plistPath = [paths objectAtIndex:0];
        NSString *fileName = [plistPath stringByAppendingPathComponent:dataPlist];
        NSMutableArray *data = [[NSMutableArray alloc] initWithContentsOfFile:fileName];
        FTPServerModel *model = nil;
        for (NSMutableArray *array in data) {
            model = [[FTPServerModel alloc] init];
            for (NSMutableArray *item in array) {
                for (NSMutableDictionary *dict in item) {
                    [model setValue:dict[@"value"] matchWithKey:dict[@"name"]];
                }
            }
            [self.myFTPServers addObject:model];
        }
    }
    // 加载自定义cell
    UITableView *tableView = (id)[self.view viewWithTag: 666];
    [tableView registerClass:[FTPServersListViewCell class] forCellReuseIdentifier:cellTableIdentifier];
    
    // 添加消息监控
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addServer:) name:@"addFTPServer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyServer:) name:@"modifyFTPServer" object:nil];
}

- (BOOL) isFileExist: (NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL flag = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    NSString *fileName = [documentDirectory stringByAppendingPathComponent:filePath];
    flag = [manager fileExistsAtPath:fileName];
    
    return flag;
}
/*
 将全部的数据同步到文件
 */
- (void) saveDataToFile {
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [dir stringByAppendingPathComponent:dataPlist];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:[self.myFTPServers count]];
    for (FTPServerModel *serverModel in self.myFTPServers) {
        NSArray *data = [serverModel wrapData];
        [mutableArray addObject:data];
    }
    [[mutableArray copy] writeToFile:filePath atomically:YES];
}
- (void) customeAddObject: (FTPServerModel *)modelData {
    [self.myFTPServers addObject:modelData];
    [self saveDataToFile];
}
-(void) modifyObject: (FTPServerModel *)modelData {
    if (self.index != -1) {
        [self.myFTPServers replaceObjectAtIndex:self.index withObject:modelData];
        [self saveDataToFile];
    }
}

- (void) addServer: (NSNotification *) aNotification{
    // 测试消息通知功能是否正常
    FTPServerModel *model = [aNotification object];
    //    [model logObject];
    [self customeAddObject:model];
    [self reloadTableView];
}

- (void) modifyServer: (NSNotification *) aNotification{
    // 测试消息通知功能是否正常
    FTPServerModel *model = [aNotification object];
//    [model logObject];
    [self modifyObject:model];
    [self reloadTableView];
}

- (void) reloadTableView {
    // 刷新tableview的数据
    [self.serverTableItems reloadData];
}

- (NSArray *) getServerNames{
    // 获取当前所有服务器的名称列表, 用于校验FTPNewViewController的名称是否重复
        NSMutableArray *nameData = [[NSMutableArray alloc] initWithCapacity:20];
        for (FTPServerModel *serverModel in self.myFTPServers) {
            [nameData addObject:serverModel.serverName];
        }
    
    return [nameData copy];
}

- (IBAction)clickTest:(UIBarButtonItem *)sender {
    static NSString *myViewIndentifier = @"FTPNewViewController";
    FTPNewViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:myViewIndentifier];
    [newViewController initWithData:[self getServerNames]];
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
    [showFilesViewController initTitleWith:@"/data" ServerDataWith:model];
    [self.navigationController pushViewController:showFilesViewController animated:true];
}

- (void)imageTapped:(UIGestureRecognizer *)guesture {
    CGPoint location = [guesture locationInView:self.serverTableItems];
    NSIndexPath *indexPath = [self.serverTableItems indexPathForRowAtPoint:location];
    if (!indexPath) return;
    self.index = indexPath.row;
    FTPServerModel *model = [self.myFTPServers objectAtIndex:indexPath.row];
    static NSString *myViewIndentifier = @"FTPModifyViewController";
    FTPModifyViewController *modifyViewController = [self.storyboard instantiateViewControllerWithIdentifier:myViewIndentifier];
    [modifyViewController initWithModelData:model];
    [modifyViewController setTitle:model.serverName];
    [self.navigationController pushViewController:modifyViewController animated:true];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
