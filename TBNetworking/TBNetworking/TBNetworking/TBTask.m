//
//  TBSession.m
//  TBNSUrlSession
//
//  Created by hanchuangkeji on 2017/11/21.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "TBTask.h"

@interface TBTask()



@end

@implementation TBTask

- (NSMutableData *)datablock:(int(^)(int aaaa))aaBlock {
    if (_data == nil) {
        _data = [NSMutableData data];
    }
    return _data;
}

- (NSProgress *)progress {
    if (_progress == nil) {
        _progress = [[NSProgress alloc] init];
    }
    return _progress;
}


@end
