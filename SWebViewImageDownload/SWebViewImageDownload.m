//
//  SWebViewImageDownload.m
//  SWebViewImageDownload
//
//  Created by shadow on 2016/5/31.
//  Copyright © 2016年 shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWebViewImageDownload.h"
//MD5 Framework
#import <CommonCrypto/CommonDigest.h>

@interface SWebViewImageDownload ()

@property (nonatomic, copy) NSString *htmlString;

@end

@implementation SWebViewImageDownload

- (instancetype)initWithHTMLString:(NSString *)string stringType:(StringType)stringType {
    self = super.init;
    if (!self) return nil;
    
    if (stringType == StringTypeWithURL) {
        NSURL *url = [NSURL URLWithString:string];
        NSError *error;
        string = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    }
    if ([string length] == 0) {
        NSLog(@"未取得HTML Body");
        return nil;
    }
    _htmlString = string;
    [self getImagesFromHTML];
    return self;
}

- (void)getImagesFromHTML {
    NSString *pattern = @"<img.*?src=[^>]*/>";
    if ([_patternString length] > 0) {
        pattern = _patternString;
    }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:_htmlString options:NSMatchingReportCompletion range:NSMakeRange(0, _htmlString.length)];
    NSLog(@"%@",result);

    NSMutableDictionary *urlDicts = [[NSMutableDictionary alloc] init];
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    @autoreleasepool {
        for (NSTextCheckingResult *item in result) {
            NSString *imgHtml = [_htmlString substringWithRange:[item rangeAtIndex:0]];
            NSArray *tmpArray = nil;
            if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
                tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
            } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
                tmpArray = [imgHtml componentsSeparatedByString:@"src="];
            }
            
            if (tmpArray.count >= 2) {
                NSString *src = tmpArray[1];
                NSUInteger loc = [src rangeOfString:@"\""].location;
                if (loc != NSNotFound) {
                    src = [src substringToIndex:loc];
                    NSString *newSrc = nil;
                    if (![src hasPrefix:@"http"]) {
                        newSrc = [NSString stringWithFormat:@"https:%@",src];
                        NSRange range = [newSrc rangeOfString:@"?v="];
                        if (range.length > 0) {
                            NSMutableString *new = [NSMutableString stringWithString:newSrc];
                            [new deleteCharactersInRange:NSMakeRange((unsigned long)range.location, src.length - (unsigned long)range.location)];
                            src = new;
                        }
                    }else {
                        NSRange range = [src rangeOfString:@"?v="];
                        if (range.length > 0) {
                            NSMutableString *new = [NSMutableString stringWithString:src];
                            [new deleteCharactersInRange:NSMakeRange((unsigned long)range.location, src.length - (unsigned long)range.location)];
                            src = new;
                        }
                    }
                    
                    if (src.length > 0) {
                        NSString *localPath = [docPath stringByAppendingPathComponent:[self md5:src]];
                        // 把連結設定本地名稱，並取得完整路徑
                        [urlDicts setObject:localPath forKey:src];
                    }
                }
                
                // 檢查所有的URL，替換成本機的URL，並非同步下載儲存圖片
                for (NSString *src in urlDicts.allKeys) {
                    NSString *localPath = [urlDicts objectForKey:src];
                    // 如果已經Cache，就不會再重複下載儲存
                    if (![[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
                        [self downloadImageWithUrl:src];
                    }
                }
                
                if (!_webImageURLs) {
                    _webImageURLs = [NSMutableArray new];
                }
                [_webImageURLs addObject:src];
            }
        }
    }
}

- (void)downloadImageWithUrl:(NSString *)src {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:src]];
    NSString *requestPath = [[request URL] absoluteString];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:requestPath] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        UIImage *image = [[UIImage alloc] initWithData:data];
        if (!_webImages) {
            _webImages = [NSMutableArray new];
        }
        [_webImages addObject:image];
        NSData *imageData = UIImagePNGRepresentation(image);
        NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *localPath = [docPath stringByAppendingPathComponent:[self md5:src]];
        if (![imageData writeToFile:localPath atomically:NO]) {
            NSLog(@"寫入本地失敗：%@", src);
        }
    }] resume];
}

- (NSString *)md5:(NSString *)sourceContent {
    if (self == nil || [sourceContent length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([sourceContent UTF8String], (int)[sourceContent lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

@end
