//
//  FTPFileChooserViewController.m
//  FTPKit
//
//  Created by 陶正凯 on 15/7/6.
//  Copyright (c) 2015年 陶正凯. All rights reserved.
//

#import "FTPFileChooserViewController.h"

@interface FTPFileChooserViewController ()
@property (strong, nonatomic)NSArray *fileLists;
@property (strong, nonatomic)NSString *tmpDirectory;
@end

static NSString *cellIdentifier = @"fileChooserTableViewCell";
@implementation FTPFileChooserViewController
@synthesize tmpDirectory = _tmpDirectory;
- (NSString *)tmpDirectory {
    if (!_tmpDirectory) _tmpDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return _tmpDirectory;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.fileLists count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setText:[self.fileLists objectAtIndex:indexPath.row]];
    return cell;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSError *error = nil;
    self.fileLists = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.tmpDirectory error:(&error)];
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
