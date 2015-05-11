//
//  FTPServerModel.h
//  FTPKit
//
//  Created by 陶正凯 on 15/5/10.
//  Copyright (c) 2015年 陶正凯. All rights reserved.
//

#ifndef FTPKit_FTPServerModel_h
#define FTPKit_FTPServerModel_h

#import <Foundation/Foundation.h>

@interface FTPServerModel : NSObject 
@property (copy, nonatomic) NSString *serverName;
@property (copy, nonatomic) NSString *serverAddress;
@property (copy, nonatomic) NSString *loginUsername;
@property (copy, nonatomic) NSString *loginPasswd;

- (void) logObject;
- (void) setValue: (NSString *)value matchWithKey: (NSString *)key;
@end

#endif
