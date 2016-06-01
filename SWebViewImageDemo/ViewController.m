//
//  ViewController.m
//  SWebViewImageDownload
//
//  Created by shadow on 2016/5/31.
//  Copyright © 2016年 shadow. All rights reserved.
//

#import "ViewController.h"
#import "SWebViewImageDownload.h"
#import "IDMPhotoBrowser.h"

@interface ViewController ()
@property (nonatomic, strong) IDMPhotoBrowser *browser;
@property (nonatomic, strong) NSMutableArray *photos;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"html" withExtension:@"html"];
//    NSString *html = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];

    NSString *url = @"http://yao55.pixnet.net/blog/post/30432131";
    
    SWebViewImageDownload *webImageDownload = [[SWebViewImageDownload alloc] initWithHTMLString:url stringType:StringTypeWithURL];
    NSLog(@"%@",webImageDownload.webImageURLs);
    _photos = [NSMutableArray new];
    for (NSString *urlString in webImageDownload.webImageURLs) {
        NSURL *url = [NSURL URLWithString:urlString];
        IDMPhoto *photo = [IDMPhoto photoWithURL:url];
        [_photos addObject:photo];
    }
}

- (IBAction)showPhotos:(id)sender {
    _browser = [[IDMPhotoBrowser alloc] initWithPhotos:_photos];
    _browser.displayActionButton = NO;
    _browser.displayArrowButton = YES;
    _browser.displayCounterLabel = YES;
    _browser.usePopAnimation = YES;
    int index = arc4random() % [_photos count];
    [_browser setInitialPageIndex:index];
    IDMPhoto *IDMPhoto = [_photos objectAtIndex:index];
    NSURL *url = IDMPhoto.photoURL;
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    [downloader downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        _browser.scaleImage = image;
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:_browser animated:YES completion:nil];
    });
}
@end
