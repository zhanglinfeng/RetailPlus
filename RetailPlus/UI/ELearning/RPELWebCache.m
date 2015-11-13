//
//  RPELWebCache.m
//  RetailPlus
//
//  Created by lin dong on 14-7-21.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPELWebCache.h"
#import "ZipArchive.h"

@implementation RPELWebCache

-(NSString *)genUUID
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef str_ref = CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)str_ref];
    
    CFRelease(str_ref);
    return uuid;
}

+(NSString *)GetCacheURL:(NSString *)strUrl PathSave:(NSString *)strPathSave
{
    if (!strUrl || strUrl.length < 3) return nil;
    
    NSString * strFileType = [strUrl pathExtension];
    
    //NSRange range = [strUrl rangeOfString:@"."];
    //NSString * strFileType = [strUrl substringFromIndex:range.location + 1];
    
    NSString * strFileName;
    if ([strFileType compare:@"zip" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        strFileName = [NSString stringWithFormat:@"%@index.html",strPathSave];
    else
        strFileName = [NSString stringWithFormat:@"%@index.%@",strPathSave,strFileType];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager isReadableFileAtPath:strFileName])
        return strFileName;
    return nil;
}

-(id)init:(NSString *)strUrl PathSave:(NSString *)strPathSave
{
    self = [super init];
    if (self) {
        if (strUrl && strUrl.length > 3)
        {
            _strFileType = [strUrl pathExtension];
            _strFileNameTemp = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[self genUUID],_strFileType]];
            _strPathSave = strPathSave;
            
            NSURL * url = [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            _httpRequest = [ASIHTTPRequest requestWithURL:url];
            [_httpRequest setDownloadCache:[RPSDK defaultInstance].cacheElearning];
            [_httpRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [_httpRequest setTemporaryFileDownloadPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"offline"]];
            [_httpRequest setDownloadDestinationPath:_strFileNameTemp];
            [_httpRequest setAllowResumeForFileDownloads:NO];
            _bBeginDownload = YES;
        }
        else
        {
            strUrl = @"";
            _bBeginDownload = NO;
        }
    }
    return self;
}

-(void)SetCompleteBlock:(RPELWebCacheSuccessBlock)aCompletionBlock
{
    __block RPELWebCache * webcache = self;
    
    [_httpRequest setCompletionBlock:^{
        if ([webcache.strFileType compare:@"zip" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            BOOL bFailed = YES;
            ZipArchive * zip = [[ZipArchive alloc] init];
            if ([zip UnzipOpenFile:[webcache.httpRequest downloadDestinationPath]])
            {
                if ([zip UnzipFileTo:webcache.strPathSave overWrite:YES])
                {
                    NSString * strFileNameSave = [webcache.strPathSave stringByAppendingString:@"index.html"];
                    [zip UnzipCloseFile];
                    aCompletionBlock(strFileNameSave);
                    bFailed = NO;
                }
            }
            if (bFailed)
                webcache.failBlock();
        }
        else
        {
            NSFileManager * fileManager = [NSFileManager defaultManager];
            NSError * error;
            NSString * strFileNameSave = [webcache.strPathSave stringByAppendingString:[NSString stringWithFormat:@"index.%@",webcache.strFileType]];
            
            [fileManager createDirectoryAtPath:webcache.strPathSave withIntermediateDirectories:NO attributes:nil error:nil];
            [fileManager removeItemAtPath:strFileNameSave error:nil];
            
            [fileManager copyItemAtPath:[webcache.httpRequest downloadDestinationPath] toPath:strFileNameSave error:&error];
            aCompletionBlock(strFileNameSave);
        }
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:webcache.strFileNameTemp error:nil];
        [fileManager removeItemAtPath:[webcache.httpRequest downloadDestinationPath] error:nil];
    }];
}

-(void)SetFailedBlock:(RPELWebCacheFailedBlock)aFailedBlock
{
    __block RPELWebCache * webcache = self;
    _failBlock = aFailedBlock;
    
    [_httpRequest setFailedBlock:^{
        webcache.failBlock();
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:webcache.strFileNameTemp error:nil];
    }];
}

-(void)SetProgressBlock:(RPELWebCacheProgressBlock)aProgressBlock
{
    [_httpRequest setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        aProgressBlock(size,total);
    }];
}

-(void)StartAsynchronous
{
    [_httpRequest startAsynchronous];
    if (_bBeginDownload == NO) _failBlock();
}

-(void)CancelDownload
{
    [_httpRequest cancel];
}
@end
