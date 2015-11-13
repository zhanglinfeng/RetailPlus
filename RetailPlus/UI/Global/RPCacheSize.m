//
//  RPCacheSize.m
//  RetailPlus
//
//  Created by lin dong on 14-4-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCacheSize.h"
#import "SDWebImageManager.h"

@implementation RPCacheSize

+(unsigned long long)GetSystemCacheSize
{
    return [[SDWebImageManager sharedManager].imageCache getSize];
}

+(unsigned long long)GetDocumentLiveCacheSize
{
    return [RPCacheSize folderSize:[RPSDK defaultInstance].cacheDocumentLive.storagePath];
}

+(unsigned long long)GetTrainingCacheSize
{
    return [RPCacheSize folderSize:[RPSDK defaultInstance].cacheTraining.storagePath];
}

+ (unsigned long long int)folderSize:(NSString *)folderPath {
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
    
    while (fileName = [filesEnumerator nextObject]) {
        NSError * error;
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:&error];
        fileSize += [fileDictionary fileSize];
    }
    
    return fileSize;
}

+(NSString *)GetCacheSizeString:(unsigned long long)nSize
{
    NSString * strSizeType = @"";
    
    double dSize = nSize;
    
    if(dSize < 1){
        return @"0 B";
    }
    else if (dSize < 1024)
    {
        dSize = dSize;
        strSizeType = @" B";
        return [NSString stringWithFormat:@"%0.0f %@",dSize,strSizeType];
    }
    else if (dSize < 1024 * 1024)
    {
        dSize = dSize / 1024;
        strSizeType = @" KB";
    }
    else if (dSize < 1024 * 1024 * 1024)
    {
        dSize = dSize / (1024 * 1024);
        strSizeType = @" MB";
    }
    else
    {
        dSize = dSize / (1024 * 1024 * 1024);
        strSizeType = @" GB";
    }
    
    return [NSString stringWithFormat:@"%0.2f %@",dSize,strSizeType];
}

+(void)ClearSystemCache
{
    [[SDWebImageManager sharedManager].imageCache clearDisk];
}

+(void)ClearDocumentLiveCache
{
    [[RPSDK defaultInstance].cacheDocumentLive clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
}

+(void)ClearTrainingCache
{
    [[RPSDK defaultInstance].cacheTraining clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
}
@end
