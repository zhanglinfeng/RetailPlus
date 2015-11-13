//
//  RPNetModule.m
//  RetailPlus
//
//  Created by lin dong on 13-11-26.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "AFXMLRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "Reachability.h"
#import "RPSDKError.h"
#import "RPNetModule.h"
#import "SVProgressHUD.h"
#import "GTMBase64.h"
#import "NSData+AES.h"
#import <zlib.h>

@implementation RPNetModule

SecKeyRef _privateKey = nil;
SecKeyRef _publicKey = nil;
NSString * _strRSAPublicKey = nil;
NSString * _strAESPrivateKey = nil;
NSString * _strSid = nil;

extern NSBundle * g_bundleResorce;
extern NSString * g_strLangCode;

+ (NSString *)GetSid
{
    return _strSid;
}

+ (void)ClearSid
{
    _strSid = nil;
}

+ (OSStatus)extractEveryThingFromPKCS12File:(NSString *)pkcsPath passphrase:(NSString *)pkcsPassword {
    SecIdentityRef identity;
    SecTrustRef trust;
    OSStatus status = -1;
    if (_privateKey == nil) {
        NSData *p12Data = [NSData dataWithContentsOfFile:pkcsPath];
        if (p12Data) {
            CFStringRef password = (__bridge CFStringRef)pkcsPassword;
            const void *keys[] = {
                kSecImportExportPassphrase
            };
            const void *values[] = {
                password
            };
            CFDictionaryRef options = CFDictionaryCreate(kCFAllocatorDefault, keys, values, 1, NULL, NULL);
            CFArrayRef items = CFArrayCreate(kCFAllocatorDefault, NULL, 0, NULL);
            status = SecPKCS12Import((__bridge CFDataRef)p12Data, options, &items);
            if (status == errSecSuccess) {
                CFDictionaryRef identity_trust_dic = CFArrayGetValueAtIndex(items, 0);
                identity = (SecIdentityRef)CFDictionaryGetValue(identity_trust_dic, kSecImportItemIdentity);
                trust = (SecTrustRef)CFDictionaryGetValue(identity_trust_dic, kSecImportItemTrust);
                // certs数组中包含了所有的证书
                CFArrayRef certs = (CFArrayRef)CFDictionaryGetValue(identity_trust_dic, kSecImportItemCertChain);
                if ([(__bridge NSArray *)certs count] && trust && identity) {
                    // 如果没有下面一句，自签名证书的评估信任结果永远是kSecTrustResultRecoverableTrustFailure
                    status = SecTrustSetAnchorCertificates(trust, certs);
                    if (status == errSecSuccess) {
                        SecTrustResultType trustResultType;
                        // 通常, 返回的trust result type应为kSecTrustResultUnspecified，如果是，就可以说明签名证书是可信的
                        status = SecTrustEvaluate(trust, &trustResultType);
                        if ((trustResultType == kSecTrustResultUnspecified || trustResultType == kSecTrustResultProceed) && status == errSecSuccess) {
                            // 证书可信，可以提取私钥与公钥，然后可以使用公私钥进行加解密操作
                            status = SecIdentityCopyPrivateKey(identity, &_privateKey);
                            if (status == errSecSuccess && _privateKey) {
                                // 成功提取私钥
                                NSLog(@"Get private key successfully~ %@", _privateKey);
                            }
                            
                            _publicKey = SecTrustCopyPublicKey(trust);
                            if (_publicKey) {
                                // 成功提取公钥
                            }
                            /*
                             // 这里，不提取公钥，提取公钥的任务放在extractPublicKeyFromCertificateFile方法中
                             _publicKey = SecTrustCopyPublicKey(trust);
                             if (_publicKey) {
                             // 成功提取公钥
                             }
                             */
                        }
                    }
                }
            }
            if (options) {
                CFRelease(options);
            }
        }
    }
    return status;
}


+(NSData*) gzipData: (NSData*)pUncompressedData
{
    /*
     Special thanks to Robbie Hanson of Deusty Designs for sharing sample code
     showing how deflateInit2() can be used to make zlib generate a compressed
     file with gzip headers:
     
     http://deusty.blogspot.com/2007/07/gzip-compressiondecompression.html
     
     */
    
    if (!pUncompressedData || [pUncompressedData length] == 0)
    {
        NSLog(@"%s: Error: Can't compress an empty or null NSData object.", __func__);
        return nil;
    }
    
    /* Before we can begin compressing (aka "deflating") data using the zlib
     functions, we must initialize zlib. Normally this is done by calling the
     deflateInit() function; in this case, however, we'll use deflateInit2() so
     that the compressed data will have gzip headers. This will make it easy to
     decompress the data later using a tool like gunzip, WinZip, etc.
     
     deflateInit2() accepts many parameters, the first of which is a C struct of
     type "z_stream" defined in zlib.h. The properties of this struct are used to
     control how the compression algorithms work. z_stream is also used to
     maintain pointers to the "input" and "output" byte buffers (next_in/out) as
     well as information about how many bytes have been processed, how many are
     left to process, etc. */
    z_stream zlibStreamStruct;
    zlibStreamStruct.zalloc    = Z_NULL; // Set zalloc, zfree, and opaque to Z_NULL so
    zlibStreamStruct.zfree     = Z_NULL; // that when we call deflateInit2 they will be
    zlibStreamStruct.opaque    = Z_NULL; // updated to use default allocation functions.
    zlibStreamStruct.total_out = 0; // Total number of output bytes produced so far
    zlibStreamStruct.next_in   = (Bytef*)[pUncompressedData bytes]; // Pointer to input bytes
    zlibStreamStruct.avail_in  = [pUncompressedData length]; // Number of input bytes left to process
    
    /* Initialize the zlib deflation (i.e. compression) internals with deflateInit2().
     The parameters are as follows:
     
     z_streamp strm - Pointer to a zstream struct
     int level      - Compression level. Must be Z_DEFAULT_COMPRESSION, or between
     0 and 9: 1 gives best speed, 9 gives best compression, 0 gives
     no compression.
     int method     - Compression method. Only method supported is "Z_DEFLATED".
     int windowBits - Base two logarithm of the maximum window size (the size of
     the history buffer). It should be in the range 8..15. Add
     16 to windowBits to write a simple gzip header and trailer
     around the compressed data instead of a zlib wrapper. The
     gzip header will have no file name, no extra data, no comment,
     no modification time (set to zero), no header crc, and the
     operating system will be set to 255 (unknown).
     int memLevel   - Amount of memory allocated for internal compression state.
     1 uses minimum memory but is slow and reduces compression
     ratio; 9 uses maximum memory for optimal speed. Default value
     is 8.
     int strategy   - Used to tune the compression algorithm. Use the value
     Z_DEFAULT_STRATEGY for normal data, Z_FILTERED for data
     produced by a filter (or predictor), or Z_HUFFMAN_ONLY to
     force Huffman encoding only (no string match) */
    int initError = deflateInit2(&zlibStreamStruct, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY);
    if (initError != Z_OK)
    {
        NSString *errorMsg = nil;
        switch (initError)
        {
            case Z_STREAM_ERROR:
                errorMsg = @"Invalid parameter passed in to function.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Insufficient memory.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        NSLog(@"%s: deflateInit2() Error: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        return nil;
    }
    
    // Create output memory buffer for compressed data. The zlib documentation states that
    // destination buffer size must be at least 0.1% larger than avail_in plus 12 bytes.
    NSMutableData *compressedData = [NSMutableData dataWithLength:[pUncompressedData length] * 2 + 12];
    
    int deflateStatus;
    do
    {
        // Store location where next byte should be put in next_out
        zlibStreamStruct.next_out = [compressedData mutableBytes] + zlibStreamStruct.total_out;
        
        // Calculate the amount of remaining free space in the output buffer
        // by subtracting the number of bytes that have been written so far
        // from the buffer's total capacity
        zlibStreamStruct.avail_out = [compressedData length] - zlibStreamStruct.total_out;
        
        /* deflate() compresses as much data as possible, and stops/returns when
         the input buffer becomes empty or the output buffer becomes full. If
         deflate() returns Z_OK, it means that there are more bytes left to
         compress in the input buffer but the output buffer is full; the output
         buffer should be expanded and deflate should be called again (i.e., the
         loop should continue to rune). If deflate() returns Z_STREAM_END, the
         end of the input stream was reached (i.e.g, all of the data has been
         compressed) and the loop should stop. */
        deflateStatus = deflate(&zlibStreamStruct, Z_FINISH);
        
    } while ( deflateStatus == Z_OK );
    
    // Check for zlib error and convert code to usable error message if appropriate
    if (deflateStatus != Z_STREAM_END)
    {
        NSString *errorMsg = nil;
        switch (deflateStatus)
        {
            case Z_ERRNO:
                errorMsg = @"Error occured while reading file.";
                break;
            case Z_STREAM_ERROR:
                errorMsg = @"The stream state was inconsistent (e.g., next_in or next_out was NULL).";
                break;
            case Z_DATA_ERROR:
                errorMsg = @"The deflate data was invalid or incomplete.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Memory could not be allocated for processing.";
                break;
            case Z_BUF_ERROR:
                errorMsg = @"Ran out of output buffer for writing compressed bytes.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        NSLog(@"%s: zlib error while attempting compression: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        
        // Free data structures that were dynamically created for the stream.
        deflateEnd(&zlibStreamStruct);
        
        return nil;
    }
    // Free data structures that were dynamically created for the stream.
    deflateEnd(&zlibStreamStruct);
    [compressedData setLength: zlibStreamStruct.total_out];
  //  NSLog(@"%s: Compressed file from %d KB to %d KB", __func__, [pUncompressedData length]/1024, [compressedData length]/1024);
    
    return compressedData;
}

+(NSData *)uncompressZippedData:(NSData *)compressedData
{
    
    if ([compressedData length] == 0) return compressedData;
    
    unsigned full_length = [compressedData length];
    
    unsigned half_length = [compressedData length] / 2;
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    z_stream strm;
    strm.next_in = (Bytef *)[compressedData bytes];
    strm.avail_in = [compressedData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy: half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
        
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    // Set real length.
    if (done) {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    } else {
        return nil;
    }  
}

+ (NSString *)encrypt:(NSString *)plainText
{
    if (_publicKey == nil) {
        NSData *certificateData = [GTMBase64 decodeString:_strRSAPublicKey];
        
        SecCertificateRef myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
        SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
        SecTrustRef myTrust;
        OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
        SecTrustResultType trustResult;
        if (status == noErr) {
            status = SecTrustEvaluate(myTrust, &trustResult);
        }
        _publicKey = SecTrustCopyPublicKey(myTrust);
        
        
    }
    
    size_t cipherBufferSize = SecKeyGetBlockSize(_publicKey);
    uint8_t *cipherBuffer = NULL;
    cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer,0, cipherBufferSize);
    NSData *plainTextBytes = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    int blockSize = cipherBufferSize - 11;
    int numBlock = (int)ceil([plainTextBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    for (int i=0; i<numBlock; i++) {
        int bufferSize = MIN(blockSize,[plainTextBytes length] - i * blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(_publicKey, kSecPaddingPKCS1,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length], cipherBuffer,
                                        &cipherBufferSize);
        if (status == noErr)
        {
            NSData *encryptedBytes = [[NSData alloc]
                                       initWithBytes:(const void *)cipherBuffer
                                       length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }
        else
        {
//            *err = [NSError errorWithDomain:@"errorDomain" code:status userInfo:nil];
//            NSLog(@"encrypt:usingKey: Error: %d", status);
            return nil;
        }
    }
    if (cipherBuffer)
    {
        free(cipherBuffer);
    }
    
    return [GTMBase64 stringByEncodingData:encryptedData];
}


+ (NSData *)decryptWithPrivateKey:(NSString *)strData {
    // 分配内存块，用于存放解密后的数据段
    NSData * cipherData = [GTMBase64 decodeString:strData];
    
    size_t plainBufferSize = SecKeyGetBlockSize(_privateKey);
    NSLog(@"plainBufferSize = %zd", plainBufferSize);
    uint8_t *plainBuffer = malloc(plainBufferSize * sizeof(uint8_t));
    // 计算数据段最大长度及数据段的个数
    double totalLength = [cipherData length];
    size_t blockSize = plainBufferSize;
    size_t blockCount = (size_t)ceil(totalLength / blockSize);
    NSMutableData *decryptedData = [NSMutableData data];
    // 分段解密
    for (int i = 0; i < blockCount; i++) {
        NSUInteger loc = i * blockSize;
        // 数据段的实际大小。最后一段可能比blockSize小。
        int dataSegmentRealSize = MIN(blockSize, totalLength - loc);
        // 截取需要解密的数据段
        NSData *dataSegment = [cipherData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
        OSStatus status = SecKeyDecrypt(_privateKey, kSecPaddingPKCS1, (const uint8_t *)[dataSegment bytes], dataSegmentRealSize, plainBuffer, &plainBufferSize);
        if (status == errSecSuccess) {
            NSData *decryptedDataSegment = [[NSData alloc] initWithBytes:(const void *)plainBuffer length:plainBufferSize];
            [decryptedData appendData:decryptedDataSegment];
         //   [decryptedDataSegment release];
        } else {
            if (plainBuffer) {
                free(plainBuffer);
            }
            return nil;
        }
    }
    if (plainBuffer) {
        free(plainBuffer);
    }
    return decryptedData;
}

+(NSString *)createMD5:(NSString *)signString
{
    const char*cStr =[signString UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return[NSString stringWithFormat:
           @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
           result[0], result[1], result[2], result[3],
           result[4], result[5], result[6], result[7],
           result[8], result[9], result[10], result[11],
           result[12], result[13], result[14], result[15]
           ];
}

+(NSString *)createSign:(NSMutableDictionary *)dictParam
{
    return @"";
    
    NSArray *keys=[dictParam allKeys];
    keys=[keys sortedArrayUsingSelector:@selector(compare:)];
    
    NSString *signData=[[NSString alloc] init];
    signData=[signData stringByAppendingFormat:APP_SECRET];
    for(NSString *key in keys)
    {
        signData=[signData stringByAppendingFormat:@"%@%@",key,[dictParam objectForKey:key]];
    }
    signData=[signData stringByAppendingFormat:APP_SECRET];
    return [self createMD5:signData];
}

+(NSString *)genTimeStamp
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+(NetworkStatus)GetConnectionStatus
{
    struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	Reachability *hostReachability = [Reachability reachabilityWithAddress: &zeroAddress];
    [hostReachability startNotifier];
    
    BOOL bConnectionRequired = [hostReachability connectionRequired];
    if  (bConnectionRequired) return NotReachable;
    
    return [hostReachability currentReachabilityStatus];
}

+(BOOL)doNetworkConnect
{
    if (_strSid != nil && _strAESPrivateKey != nil) return YES;
    
    NSError * error;
    NSString * strURL = [NSString stringWithFormat:@"%@/Encrypt/GetPublicKey",[RPSDK defaultInstance].strApiBaseUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-type"];
    [request addValue:@"json" forHTTPHeaderField:@"Data-Type"];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (!data) return NO;
    
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:&error];
    if (!dict) return NO;
    
    _strSid = [dict objectForKey:@"Sid"];
    _strRSAPublicKey = [dict objectForKey:@"Value"];
    if (_strSid == nil || _strRSAPublicKey == nil) {
        return NO;
    }
    
    if (_strAESPrivateKey == nil) {
        _strAESPrivateKey = [RPNetModule genUUID];
        _strAESPrivateKey = [_strAESPrivateKey stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    strURL = [NSString stringWithFormat:@"%@/Encrypt/GetEncryptKey",[RPSDK defaultInstance].strApiBaseUrl];
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-type"];
    [request addValue:@"json" forHTTPHeaderField:@"Data-Type"];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSNumber numberWithInteger:NO] forKey:@"IsEncrypt"];
    [dict setValue:_strSid forKey:@"Sid"];
    [dict setValue:[RPNetModule encrypt:_strAESPrivateKey] forKey:@"Value"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString * strBody = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [request setHTTPBody:[strBody dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:[NSString stringWithFormat:@"%d",strBody.length] forHTTPHeaderField:@"Content-Length"];
    
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (data)
    {
        dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:&error];
        if (dict)
        {
            if (((NSNumber *)[dict objectForKey:@"Code"]).intValue == 0) {
                NSString * strValue = [dict objectForKey:@"Value"];
                if (strValue) {
                    dict = [NSJSONSerialization JSONObjectWithData:[strValue dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:&error];
                    if (dict) {
                        NSInteger nRetCode = ((NSNumber *)[dict objectForKey:@"Code"]).intValue;
                        if (nRetCode == 0) return YES;
                    }
                }
            }
        }
    }
    
    _strSid = nil;
    _strAESPrivateKey = nil;
    _strRSAPublicKey = nil;
    return NO;
}

+(NSString *)genUUID
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef str_ref = CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)str_ref];
    
    CFRelease(str_ref);
    return uuid;
}

+(NSString *)encryptSendString:(NSString *)plainText
{
    NSError * error = nil;
    NSData * dataToZip = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSData * dataToEnc = [RPNetModule gzipData:dataToZip];
    NSData * dataEnc = [dataToEnc AES256EncryptWithKey:_strAESPrivateKey];
    NSString * strEnc = [GTMBase64 stringByEncodingData:dataEnc];
    
    NSMutableDictionary * dictEnc = [[NSMutableDictionary alloc] init];
    [dictEnc setObject:_strSid forKey:@"Sid"];
    [dictEnc setObject:strEnc forKey:@"Value"];
    [dictEnc setValue:[NSNumber numberWithInteger:YES] forKey:@"IsEncrypt"];
    NSData * jsonDataEnc = [NSJSONSerialization dataWithJSONObject:dictEnc options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonDataEnc encoding:NSUTF8StringEncoding];
}

+(void)doRequest:(NSString *)strURL isCheckWifi:(BOOL)bCheckWifi withData:(NSMutableDictionary *)dictParam success:(RPSDKSuccess)successBlock failed:(RPSDKFailed)failedBlock
{
    [RPNetModule doRequest:strURL isCheckWifi:bCheckWifi withData:dictParam success:successBlock failed:failedBlock DownloadProgress:nil UploadProgress:nil];
}

+(void)doRequest:(NSString *)strURL isCheckWifi:(BOOL)bCheckWifi withData:(NSMutableDictionary *)dictParam success:(RPSDKSuccess)successBlock failed:(RPSDKFailed)failedBlock DownloadProgress:(RPSDKProgress)progressDownload UploadProgress:(RPSDKProgress)progressUpload
{
    if ([RPSDK defaultInstance].bDemoMode) {
        NSString * strFileName = [strURL stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        
        NSString * strDocPath = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path];
        NSString * strPath = [NSString stringWithFormat:@"%@/%@.txt",strDocPath,strFileName];
        NSString * strJson = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
       if (strJson == nil)
       {
           NSString * path = [[NSBundle mainBundle] pathForResource:strFileName ofType:@"txt"];
           if (path != nil)
               strJson = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
       }
        
        if (strJson) {
            NSData *JSONData = [strJson dataUsingEncoding:NSUTF8StringEncoding];
            NSError * error;
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
            if (dict)
            {
                NSInteger nRetCode = ((NSNumber *)[dict objectForKey:@"Code"]).intValue;
                if (nRetCode == 0) {
                    id idObj = [dict objectForKey:@"Data"];
                    if (idObj == [NSNull null]) {
                        idObj = nil;
                    }
                    successBlock(idObj);
                }
                else
                {
                    NSString * strDesc =[dict objectForKey:@"Desc"];
                    if (strDesc == nil || strDesc.length == 0)
                        [SVProgressHUD showErrorWithStatus:@"Unknown Error"];
                    else
                        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Desc"]];
                    
                    [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Desc"]];
                    
                    failedBlock(((NSNumber *)[dict objectForKey:@"Code"]).intValue,[RPSDKError GetErrorDesc:(RPSDKErrorCode)[dict objectForKey:@"Code"]]);
                }
            }
        }
        else
             failedBlock(RPSDKError_Server,[RPSDKError GetErrorDesc:RPSDKError_Server]);
        
        return;
    }
    
    if  (!dictParam)
    {
        failedBlock(RPSDKError_Param,[RPSDKError GetErrorDesc:RPSDKError_Param]);
        return;
    }

    NetworkStatus status = [self GetConnectionStatus];
    switch (status) {
        case NotReachable:
            [self ReportNetworkError:strURL];
            failedBlock(RPSDKError_NoConnection,[RPSDKError GetErrorDesc:RPSDKError_NoConnection]);
            return;
            break;
        case ReachableViaWWAN:
            if (bCheckWifi) {
                [self ReportNetworkError:strURL];
                failedBlock(RPSDKError_NoConnection,[RPSDKError GetErrorDesc:RPSDKError_NoWifiConnection]);
                return;
            }
            break;
        case ReachableViaWiFi:
            break;
        default:
            break;
    }

//Check Connection / private key
    if (![RPNetModule doNetworkConnect])
    {
        [self ReportNetworkError:strURL];
        failedBlock(RPSDKError_NoConnection,[RPSDKError GetErrorDesc:RPSDKError_NoConnection]);
        return;
    }
    
//Complete Param
    [dictParam setObject:[RPNetModule genTimeStamp] forKey:@"TimeStamp"];
    [dictParam setObject:APP_KEY forKey:@"AppKey"];
    [dictParam setObject:SDK_VERSION forKey:@"V"];
    [dictParam setObject:[RPNetModule createSign:dictParam] forKey:@"Sign"];
    if ([g_strLangCode isEqualToString:@"zh-Hans"]) {
         [dictParam setObject:@"CHS" forKey:@"Lang"];
    }
    else
    {
        [dictParam setObject:@"ENG" forKey:@"Lang"];
    }
    
//Gen Body
    NSError *error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictParam options:NSJSONWritingPrettyPrinted error:&error];
    NSString * strBody = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
//Encrypt
    NSString * strBodyEnc = [RPNetModule encryptSendString:strBody];
    
//Gen Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:SDK_TIMEOUTINTERVAL];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-type"];
    [request addValue:@"json" forHTTPHeaderField:@"Data-Type"];
    [request setHTTPBody:[strBodyEnc dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:[NSString stringWithFormat:@"%d",strBodyEnc.length] forHTTPHeaderField:@"Content-Length"];
    
//Do Request
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary * dict) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kApplicationServerStatusNotify object:[NSNumber numberWithBool:YES]];
        
        if (((NSNumber *)[dict objectForKey:@"Code"]).integerValue != 0)
        {
            [self ClearSid];
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Desc"]];
            failedBlock(RPSDKError_Server,[RPSDKError GetErrorDesc:RPSDKError_Server]);
        }
        else
        {
            NSError * error = nil;
            NSData * data2 = [GTMBase64 decodeString:[dict objectForKey:@"Value"]];
            if (data2) {
                NSData * data3 = [data2 AES256DecryptWithKey:_strAESPrivateKey];
                if (data3) {
                    NSData * data4 = [RPNetModule uncompressZippedData:data3];
                    if (data4) {
                        NSDictionary * dictDecode = [NSJSONSerialization JSONObjectWithData:data4 options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:&error];
                        if (dictDecode && ![dictDecode isKindOfClass:[NSNull class]])
                        {
                            NSNumber * num = (NSNumber *)[dictDecode objectForKey:@"Code"];
                            if (num) {
                                NSInteger nRetCode = ((NSNumber *)[dictDecode objectForKey:@"Code"]).intValue;
                                if (nRetCode == 0) {
                                    id idObj = [dictDecode objectForKey:@"Data"];
                                    if (idObj == [NSNull null]) {
                                        idObj = nil;
                                    }
                                    successBlock(idObj);
                                    return;
                                }
                                else
                                {
                                    NSString * strDesc =[dictDecode objectForKey:@"Desc"];
                                    if ( (id)strDesc == [NSNull null] || strDesc == nil || strDesc.length == 0)
                                        [SVProgressHUD showErrorWithStatus:@"Unknown Error"];
                                    else
                                        [SVProgressHUD showErrorWithStatus:[dictDecode objectForKey:@"Desc"]];
                                    
                                    NSString * strCode = NSLocalizedStringFromTableInBundle(@"ErrorCode",@"RPString", g_bundleResorce,nil);
                                    NSString * str = [NSString stringWithFormat:@"%@:%d\r\n%@",strCode,nRetCode,[dictDecode objectForKey:@"Desc"]];
                                    [SVProgressHUD showErrorWithStatus:str];
                                    
                                    failedBlock(((NSNumber *)[dictDecode objectForKey:@"Code"]).intValue,[RPSDKError GetErrorDesc:(RPSDKErrorCode)[dictDecode objectForKey:@"Code"]]);
                                    return;
                                }
                            }
                        }
                    }
                }
            }
            failedBlock(RPSDKError_Server,[RPSDKError GetErrorDesc:RPSDKError_Server]);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self ClearSid];
        [RPNetModule ReportNetworkError:strURL];
        failedBlock(RPSDKError_NoConnection,[RPSDKError GetErrorDesc:RPSDKError_NoConnection]);
        
    }];
    
    if (progressDownload) {
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            progressDownload(bytesRead,totalBytesRead,totalBytesExpectedToRead);
        }];
    }
    
    if (progressUpload) {
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            progressUpload(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
        }];
    }
    
    [operation start];
}

+(id)DoSyncRequest:(NSString *)strURL isCheckWifi:(BOOL)bCheckWifi withData:(NSMutableDictionary *)dictParam timeoutInterval:(NSInteger)nInterval
{
    if  (!dictParam)
    {
        return nil;
    }
    
    NetworkStatus status = [self GetConnectionStatus];
    switch (status) {
        case NotReachable:
            return nil;
            break;
        case ReachableViaWWAN:
            if (bCheckWifi) {
                return nil;
            }
            break;
        case ReachableViaWiFi:
            break;
        default:
            break;
    }
    
    if (![RPNetModule doNetworkConnect])
        return nil;
    
    //Complete Param
    [dictParam setObject:[RPNetModule genTimeStamp] forKey:@"TimeStamp"];
    [dictParam setObject:APP_KEY forKey:@"AppKey"];
    [dictParam setObject:SDK_VERSION forKey:@"V"];
    [dictParam setObject:[RPNetModule createSign:dictParam] forKey:@"Sign"];
    
    //Gen Body
    NSError *error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictParam options:NSJSONWritingPrettyPrinted error:&error];
    NSString * strBody = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //Encrypt
    NSString * strBodyEnc = [RPNetModule encryptSendString:strBody];
    
    //Gen Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:nInterval];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-type"];
    [request addValue:@"json" forHTTPHeaderField:@"Data-Type"];
    [request setHTTPBody:[strBodyEnc dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:[NSString stringWithFormat:@"%d",strBodyEnc.length] forHTTPHeaderField:@"Content-Length"];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (data)
    {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:&error];

        if (((NSNumber *)[dict objectForKey:@"Code"]).integerValue != 0)
        {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Desc"]];
            return nil;
        }
        else
        {
            NSError * error = nil;
            NSData * data2 = [GTMBase64 decodeString:[dict objectForKey:@"Value"]];
            if (data2) {
                NSData * data3 = [data2 AES256DecryptWithKey:_strAESPrivateKey];
                if (data3) {
                    NSData * data4 = [RPNetModule uncompressZippedData:data3];
                    if (data4) {
                        return [NSJSONSerialization JSONObjectWithData:data4 options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:&error];
                    }
                }
            }
        }
    }
    return nil;
}

+(void)GetWeatherInfo:(NSString *)strCityID success:(RPSDKSuccess)successBlock failed:(RPSDKFailed)failedBlock
{
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html",strCityID]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@",JSON);
        NSDictionary *data = [JSON objectForKey:@"weatherinfo"];
        successBlock(data);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //NSLog(@"%@",[error userInfo]);
        failedBlock(RPSDKError_Server,[RPSDKError GetErrorDesc:RPSDKError_Server]);
    }];
    
    [operation start];
}

+(void)ReportNetworkError:(NSString *)strUrl
{
    NetworkStatus sta = [RPSDK GetConnectionStatus];
    if ((![[NSString stringWithFormat:@"%@/%@",[RPSDK defaultInstance].strApiBaseUrl,@"User/HeartBeat"] isEqualToString:strUrl]) &&
        (![[NSString stringWithFormat:@"%@/%@",[RPSDK defaultInstance].strApiBaseUrl,@"Message/GetICUnreadCount"] isEqualToString:strUrl])){
        if (sta == NotReachable) {
            NSString * str = NSLocalizedStringFromTableInBundle(@"Network Unavailable\rPlease check your network",@"RPString", g_bundleResorce,nil);
            [SVProgressHUD showErrorWithStatus:str];
        }
        else
        {
            NSString * str = NSLocalizedStringFromTableInBundle(@"Network Unavailable\rPlease check your network",@"RPString", g_bundleResorce,nil);
            [SVProgressHUD showErrorWithStatus:str];
        }
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kApplicationServerStatusNotify object:[NSNumber numberWithBool:NO]];
}
@end
