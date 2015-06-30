//
//  FTPFileContentViewController.m
//  FTPKit
//
//  Created by 陶正凯 on 15/6/30.
//  Copyright (c) 2015年 陶正凯. All rights reserved.
//

#import "FTPFileContentViewController.h"

@interface FTPFileContentViewController ()
@property (weak, nonatomic) IBOutlet UITextView *fileContentTextView;
@property (strong, nonatomic) NSString *tmpDirectory;
@end

@implementation FTPFileContentViewController
@synthesize tmpDirectory = _tmpDirectory;

- (NSString *)tmpDirectory {
    if (!_tmpDirectory) _tmpDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return _tmpDirectory;
}
- (void)backAction {
    NSLog(@"back!!!");
    NSString *file = [self.tmpDirectory stringByAppendingPathComponent:self.title];
    [[NSFileManager defaultManager] removeItemAtPath:[file copy] error:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)downLoadFileAction{
    NSLog(@"download!!!");
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 自定义左右导航栏
    UIBarButtonItem *myLeftButtonItem = [[UIBarButtonItem alloc] init];
    myLeftButtonItem.title = @"关闭";
    myLeftButtonItem.target = self;
    myLeftButtonItem.action = @selector(backAction);
    self.navigationItem.leftBarButtonItem = myLeftButtonItem;
    
    UIBarButtonItem *myRightButtonItem = [[UIBarButtonItem alloc] init];
    myRightButtonItem.title = @"下载";
    myRightButtonItem.target = self;
    myRightButtonItem.action = @selector(downLoadFileAction);
    self.navigationItem.rightBarButtonItem = myRightButtonItem;
    
    NSString *file = [self.tmpDirectory stringByAppendingPathComponent:self.title];
    [self.fileContentTextView setText:[NSString stringWithContentsOfFile:[file copy] encoding:NSUTF8StringEncoding error:nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
