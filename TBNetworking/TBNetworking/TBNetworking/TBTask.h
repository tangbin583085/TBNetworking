//
//  TBSession.h
//  TBNSUrlSession
//
//  Created by hanchuangkeji on 2017/11/21.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^DownloadProgress)(NSProgress * _Nonnull);

typedef  void (^Success)(NSURLSessionDataTask * _Nonnull, id _Nullable);

typedef void (^Failure)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull);

typedef void (^CompletionHandler)(NSURLResponse * _Nullable response, NSURL * _Nullable filePath, NSError * _Nullable error);

typedef NSURL *_Nullable(^Destination)(NSURL * _Nullable request, NSURLResponse * _Nullable response);

@interface TBTask : NSObject

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, copy)DownloadProgress downloadProgress;

@property (nonatomic, copy)Success success;

@property (nonatomic, copy)Failure failure;

@property (nonatomic, copy)Destination destination;

@property (nonatomic, copy)CompletionHandler completionHandler;

@property (nonatomic, strong)NSURLSessionDataTask *task;

@property (nonatomic, nullable, strong)NSMutableData *data;

@property (nonatomic, strong)NSURLSessionDownloadTask *downTask;

@property (nonatomic, strong)NSProgress *progress;


NS_ASSUME_NONNULL_END

@end
