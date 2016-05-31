//
//  SWebViewImageDownload.h
//  SWebViewImageDownload
//
//  Created by shadow on 2016/5/31.
//  Copyright © 2016年 shadow. All rights reserved.
//

typedef NS_ENUM(NSInteger, StringType){
    /**
     *  一般網址，如（http://xxxx.com）
     */
    StringTypeWithURL = 0,
    /**
     *  HTML文字格式
     */
    StringTypeWithHTML = 1,
};

#import <Foundation/Foundation.h>

@interface SWebViewImageDownload : NSObject
/**
 *  從網頁內文取得的所有ImageURL
 */
@property (nonatomic, strong, readonly) NSMutableArray *webImageURLs;
/**
 *  從網頁內文取得的所有Image
 */
@property (nonatomic, strong, readonly) NSMutableArray *webImages;
/**
 *  陣規表示式的判斷，如果預設的(<img.*?src=[^>]* />)無法取得請自行添加
 */
@property (nonatomic, copy) NSString *patternString;

/**
 *  初始化物件
 *
 *  @param string Web的HTML字串
 *  @param stringType 傳入的格式，網址或是HTML文字
 *
 *  @return 返回一個初始化後的SWebViewImageDownload物件，如為nil則會產生error
 */
- (instancetype)initWithHTMLString:(NSString *)string stringType:(StringType)stringType;

@end
