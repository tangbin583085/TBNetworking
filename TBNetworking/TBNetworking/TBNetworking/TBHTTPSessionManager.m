//
//  TBHTTPSessionManager.m
//  TBNSUrlSession
//
//  Created by hanchuangkeji on 2017/11/21.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "TBHTTPSessionManager.h"


static NSURLSessionConfiguration *_sessionConfig;

@interface TBHTTPSessionManager()<NSURLSessionDataDelegate>

@property (nonatomic, strong)NSURLSession *session;

@property (nonatomic, strong)NSMutableDictionary *taskCacheDic;

@end


@implementation TBHTTPSessionManager

+ (void)initialize {
    [super initialize];
    _sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
}

- (NSMutableDictionary *)taskCacheDic {
    if (_taskCacheDic == nil) {
        _taskCacheDic = [NSMutableDictionary dictionary];
    }
    return _taskCacheDic;
}

+ (instancetype)manager{
    TBHTTPSessionManager *manager = [TBHTTPSessionManager initWithSessonConfig:_sessionConfig];
    return manager;
}

+ (instancetype)initWithSessonConfig:(NSURLSessionConfiguration *)SessonConfig {
    
    TBHTTPSessionManager *manager = [[TBHTTPSessionManager alloc] init];
    // 初始化session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:SessonConfig delegate:manager delegateQueue:nil];
    manager.session = session;
    return manager;
}

#pragma mark 拼接参数 格式如: ?username=zhangsan&password=123456
- (NSString *)parseParam:(NSDictionary *)dicParam {
    __block NSString *stringParam = @"";
    [dicParam enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        // 首次添加问号
        stringParam = [stringParam hasPrefix:@"?"]? stringParam : @"?";
        
        NSString *stringKeyValue = [NSString stringWithFormat:@"%@=%@&", key, obj];
        stringParam = [NSString stringWithFormat:@"%@%@", stringParam, stringKeyValue];
    }];
    
    // 减去最后一个字符&
    if ([stringParam hasSuffix:@"&"]) {
        stringParam = [stringParam substringToIndex:stringParam.length - 1];
    }
    return stringParam;
}

#pragma mark GET
- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull))downloadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    // 拼接参数
    NSDictionary *dicParam = parameters;
    NSString * stringParam = [self parseParam:dicParam];
    
    // url拼接参数
    URLString = [NSString stringWithFormat:@"%@%@", URLString, stringParam];
    NSURL *url = [NSURL URLWithString:URLString];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url];
    [dataTask resume];
    
    // 创建实例TBTask
    TBTask *tbTask = [[TBTask alloc] init];
    tbTask.downloadProgress = downloadProgress;
    tbTask.success = success;
    tbTask.failure = failure;
    tbTask.task = dataTask;
    [self.taskCacheDic setValue:tbTask forKey:[NSString stringWithFormat:@"%ld", dataTask.taskIdentifier]];
    return dataTask;
}

#pragma mark POST
- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    
    
    // url
    NSURL *url = [NSURL URLWithString:URLString];
    
    // request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    // 参数
    NSString *stringParams = [self parseParam:parameters];
    if ([stringParams hasPrefix:@"?"]) {
        stringParams = [stringParams substringFromIndex:1];
        request.HTTPBody = [stringParams dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request];
    [dataTask resume];
    
    // 创建实例TBTask
    TBTask *tbTask = [[TBTask alloc] init];
    tbTask.downloadProgress = uploadProgress;
    tbTask.success = success;
    tbTask.failure = failure;
    tbTask.task = dataTask;
    [self.taskCacheDic setValue:tbTask forKey:[NSString stringWithFormat:@"%ld", dataTask.taskIdentifier]];
    
    return dataTask;
}

#pragma mark post upload
- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id formData))block
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    
    // url
    NSURL *url = [NSURL URLWithString:URLString];
    
    // 2.创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 文件上传使用post
    request.HTTPMethod = @"POST";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",@"boundary"];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    // 3.拼接表单，大小受MAX_FILE_SIZE限制(2MB)  FilePath:要上传的本地文件路径  formName:表单控件名称，应于服务器一致
    NSData* data = [self getHttpBodyWithFilePath:@"/Users/userName/Desktop/IMG_0359.jpg" formName:@"file" reName:@"newName.png"];
    request.HTTPBody = data;
    // 根据需要是否提供，非必须,如果不提供，session会自动计算
    [request setValue:[NSString stringWithFormat:@"%lu",data.length] forHTTPHeaderField:@"Content-Length"];
    
    NSURLSessionDataTask *dataTask = [self.session uploadTaskWithRequest:request fromData:[NSData data]];
    
    // 创建实例TBTask
    TBTask *tbTask = [[TBTask alloc] init];
    tbTask.downloadProgress = uploadProgress;
    tbTask.success = success;
    tbTask.failure = failure;
    tbTask.task = dataTask;
    [self.taskCacheDic setValue:tbTask forKey:[NSString stringWithFormat:@"%ld", dataTask.taskIdentifier]];
    
    return dataTask;
}

#pragma mark 下载
- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                             progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                          destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                    completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler {
    
    NSURLSessionDownloadTask *downTask = [self.session downloadTaskWithRequest:request];
    [downTask resume];
    
    // 创建实例TBTask
    TBTask *tbTask = [[TBTask alloc] init];
    tbTask.downloadProgress = downloadProgressBlock;
    tbTask.completionHandler = completionHandler;
    tbTask.destination = destination;
    [self.taskCacheDic setValue:tbTask forKey:[NSString stringWithFormat:@"%ld", downTask.taskIdentifier]];
    return downTask;
}

#pragma mark 断点下载
// PS:后来找了很久都没找到NSURLSessionDownloadTask回调的NSData方法，实现resumeData断点下载，后来网络查了一下
// 很多人都是使用NSURLSessionDataTask 代理中接收NSData不断写入硬盘实现
- (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData
                                                progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                             destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                       completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler {
    
    NSURLSessionDownloadTask *downTask = [self.session downloadTaskWithResumeData:resumeData];
    [downTask resume];
    
    // 创建实例TBTask
    TBTask *tbTask = [[TBTask alloc] init];
    tbTask.downloadProgress = downloadProgressBlock;
    tbTask.completionHandler = completionHandler;
    tbTask.destination = destination;
    [self.taskCacheDic setValue:tbTask forKey:[NSString stringWithFormat:@"%ld", downTask.taskIdentifier]];
    return downTask;
}



#pragma mark <NSURLSessionDataDelegate>
// 接受到服务器响应
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    NSLog(@"开始加载...");
    
    // 允许服务器回传数据
    completionHandler(NSURLSessionResponseAllow);
    
    TBTask *tbTask = [self.taskCacheDic valueForKey:[NSString stringWithFormat:@"%ld", dataTask.taskIdentifier]];
    tbTask.data = nil;
}

//接受服务器回传的数据可能执行多次
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    NSLog(@"加载中...");
    
    TBTask *tbTask = [self.taskCacheDic valueForKey:[NSString stringWithFormat:@"%ld", dataTask.taskIdentifier]];
    [tbTask.data appendData:data];
    NSProgress *progress = [NSProgress progressWithTotalUnitCount:100];
    !tbTask.downloadProgress? : tbTask.downloadProgress(progress);
}


// 请求完成
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler {
    NSLog(@"请求完成");
    
    TBTask *tbTask = [self.taskCacheDic valueForKey:[NSString stringWithFormat:@"%ld", dataTask.taskIdentifier]];
    id responese = [NSJSONSerialization JSONObjectWithData:tbTask.data options:NSJSONReadingAllowFragments error:nil];
    !tbTask.success? : tbTask.success(dataTask, responese);
    tbTask.data = nil;
    [self.taskCacheDic removeObjectForKey:[NSString stringWithFormat:@"%ld", dataTask.taskIdentifier]];
    
}

//请求成功或者失败
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    if (error) {
        NSLog(@"请求成功或者失败1");
        NSLog(@"%@", error.localizedDescription);
        TBTask *tbTask = [self.taskCacheDic valueForKey:[NSString stringWithFormat:@"%ld", task.taskIdentifier]];
        tbTask.data = nil;
        !tbTask.failure? : tbTask.failure((NSURLSessionDataTask *)task, error);
        [self.taskCacheDic removeObjectForKey:[NSString stringWithFormat:@"%ld", task.taskIdentifier]];
    }
}

//请求成功或者失败
-(void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error{
    if (error) {
        NSLog(@"请求成功或者失败2");
    }
}



#pragma mark - NSURLSessionDownloadDelegate
// 1. 下载完成被调用的方法  iOS 7 & iOS 8都必须实现
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"下载完成..");
    
    //1 拼接文件全路径
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    //2 剪切文件
    [[NSFileManager defaultManager]moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
    NSLog(@"%@",fullPath);
    
    TBTask *tbTask = [self.taskCacheDic valueForKey:[NSString stringWithFormat:@"%ld", downloadTask.taskIdentifier]];
    tbTask.data = nil;
    [self.taskCacheDic removeObjectForKey:[NSString stringWithFormat:@"%ld", downloadTask.taskIdentifier]];
}

// 2. 下载进度变化的时候被调用的。 iOS 8可以不实现
/**
 bytesWritten：     本次写入的字节数
 totalBytesWritten：已经写入的字节数（目前下载的字节数）
 totalBytesExpectedToWrite： 总的下载字节数(文件的总大小)
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    TBTask *tbTask = [self.taskCacheDic valueForKey:[NSString stringWithFormat:@"%ld", downloadTask.taskIdentifier]];
    tbTask.progress.totalUnitCount = totalBytesExpectedToWrite;
    tbTask.progress.completedUnitCount = totalBytesWritten;
    !tbTask.downloadProgress? : tbTask.downloadProgress(tbTask.progress);
    float progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
    
    if (progress > 0.5) {
        [downloadTask cancel];
    }
    
    NSLog(@"%f---%@", progress, [NSThread currentThread]);
}

// 3. 短点续传的时候，被调用的。一般什么都不用写 iOS 8可以不实现
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

#pragma mark file
/// filePath:要上传的文件路径   formName：表单控件名称  reName：上传后文件名
- (NSData *)getHttpBodyWithFilePath:(NSString *)filePath formName:(NSString *)formName reName:(NSString *)reName
{
    NSMutableData *data = [NSMutableData data];
    NSURLResponse *response = [self getLocalFileResponse:filePath];
    // 文件类型：MIMEType  文件的大小：expectedContentLength  文件名字：suggestedFilename
    NSString *fileType = response.MIMEType;
    
    // 如果没有传入上传后文件名称,采用本地文件名!
    if (reName == nil) {
        reName = response.suggestedFilename;
    }
    
    // 表单拼接
    NSMutableString *headerStrM =[NSMutableString string];
    [headerStrM appendFormat:@"--%@\r\n",@"boundary"];
    // name：表单控件名称  filename：上传文件名
    [headerStrM appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",formName,reName];
    [headerStrM appendFormat:@"Content-Type: %@\r\n\r\n",fileType];
    [data appendData:[headerStrM dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 文件内容
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    [data appendData:fileData];
    
    NSMutableString *footerStrM = [NSMutableString stringWithFormat:@"\r\n--%@--\r\n",@"boundary"];
    [data appendData:[footerStrM  dataUsingEncoding:NSUTF8StringEncoding]];
    //    NSLog(@"dataStr=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    return data;
}
/// 获取响应，主要是文件类型和文件名
- (NSURLResponse *)getLocalFileResponse:(NSString *)urlString
{
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    // 本地文件请求
    NSURL *url = [NSURL fileURLWithPath:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    __block NSURLResponse *localResponse = nil;
    // 使用信号量实现NSURLSession同步请求
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        localResponse = response;
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return  localResponse;
}

@end
