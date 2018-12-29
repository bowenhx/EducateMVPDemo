//
//  BTextKit.h
//  BTextKit
//
//  Created by Kevin Tung on 15/7/22.
//  Copyright (c) 2015年 BTextKit. All rights reserved.
//

#import "BTextKit.h"
#import "BKFaceManage.h"

@interface BTextKit ()

@property (nonatomic, strong) NSCache *cache;

@property (nonatomic) NSUInteger countOfCachedImage;
@property (nonatomic, readonly, getter=isCachedAllImage) BOOL isCachedAllImage;


@end


@implementation BTextKit

- (instancetype)init
{
    self = [super init];
    return self;
}


- (instancetype)initWithString:(NSString *)setStr shouldWidth:(CGFloat)shouldWith fontSize:(CGFloat)setFontSize;
{
    self = [super init];
    if (self) {
        self.fontSize = setFontSize;
        self.width = shouldWith;
        self.countOfCachedImage = 0;
        self.string = setStr;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:BTKCacheFolder isDirectory:nil]) {
            NSError *err = nil;
            if (![[NSFileManager defaultManager] createDirectoryAtPath:BTKCacheFolder
                                           withIntermediateDirectories:YES
                                                            attributes:nil error:&err]) {
                DLog(@"create cache path: %@, error: %@", BTKCacheFolder, err.localizedDescription);
            }
        }
    }
    return self;
}


- (void)setString:(NSString *)setString
{
    if ([setString isEqualToString:_string]) {
        return;
    }
    _string = setString;
    
    [self parseHTML];

    
}
- (void)setTag:(NSUInteger)tag
{
    _tag = tag;
}


- (CGSize)usedSize
{
    if (self.width == 0 || self.mAString.length < 1)
        return CGSizeZero;
    
    return [self usedRect].size;
}


- (BOOL)isCachedAllImage
{
    return self.imageInfo.count == self.countOfCachedImage;
}



#pragma mark String Parser

- (void)parseHTML
{
    self.imageInfo = [NSMutableArray array];
    self.smileyInfo = [NSMutableArray array];
    
    NSArray *styleSet = [self stylesWithParseText];
    UIFont *fontSize = [UIFont systemFontOfSize:_fontSize];
    
    
    ///表情bound
    CGRect smileBounds = CGRectMake(0, -13.0f, 28.0f, 28.0f);
    ///行间距范围
    CGFloat lineSpacing = _fontSize/2;
    
    //paragraphSpacing set
    NSMutableParagraphStyle *mutParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    mutParagraphStyle.lineSpacing = lineSpacing;
    mutParagraphStyle.paragraphSpacing = lineSpacing;
    [_mAString beginEditing];
    [_mAString addAttribute:NSFontAttributeName value:fontSize range:NSMakeRange(0, _mAString.length)];
    [_mAString addAttribute:NSParagraphStyleAttributeName value:mutParagraphStyle range:NSMakeRange(0, _mAString.length)];
    [_mAString endEditing];
    
    for (NSDictionary *element in styleSet) {
        
        NSString *name = element[@"name"];
        NSString *value = element[@"value"];
        NSRange range = NSRangeFromString(element[@"range"]);
        
        if ([name isEqualToString:@"smiley"]) {

            //smiley info
            NSTextAttachment *smileAttachment = [[NSTextAttachment alloc] initWithImageURL:value];
            smileAttachment.bounds = smileBounds;
            [_smileyInfo addObject:@{@"value" : value, @"range" : NSStringFromRange(range)}];
            if ([value isEqualToString:@"jinggaoicon"]) {
                smileAttachment.image = [UIImage imageNamed:@"warning"];
                smileAttachment.bounds = CGRectMake(0, -7.f, 28.0f, 28.0f);
            }
            
            NSAttributedString *smileString = [NSAttributedString attributedStringWithAttachment:smileAttachment];
            [_mAString replaceCharactersInRange:range withAttributedString:smileString];
            
        } else if ([name isEqualToString:@"img"]) {
            //image info
            NSTextAttachment *imgAttachment = [[NSTextAttachment alloc] initWithImageURL:value];
            UIImage *image = [self cachedImage:value];
            if (image) {
                [_imageInfo addObject:@{@"value" : value, @"range" : NSStringFromRange(range), @"cached" : @1}];
            } else {
                image = [UIImage imageNamed:kPlaceHolderThemeDetail];
                [_imageInfo addObject:@{@"value" : value, @"range" : NSStringFromRange(range), @"cached" : @0}];
            }
            imgAttachment.image = image;
            imgAttachment.bounds = CGRectMake(0, 0, imgAttachment.image.size.width , imgAttachment.image.size.height);
            
            NSAttributedString *imgAString = [NSAttributedString attributedStringWithAttachment:imgAttachment];
            [_mAString replaceCharactersInRange:range withAttributedString:imgAString];
            
            NSMutableParagraphStyle *mutParagraphStyle = [[NSMutableParagraphStyle alloc] init];
            mutParagraphStyle.alignment = NSTextAlignmentCenter;
            mutParagraphStyle.lineSpacing = 2.0f;
            [_mAString beginEditing];
            [_mAString addAttribute:NSParagraphStyleAttributeName value:mutParagraphStyle range:range];
            [_mAString endEditing];
            
        } else if ([name isEqualToString:@"link"]) {
            
            // http://www.canvasbeauty.com.hk/zh/%23/store-location/
            // [link]http://www.canvasbeauty.com.hk/zh/#/store-location/|^|按此查閱店舖地址及電話[/link]
            
            NSURL *linkURL = [NSURL URLWithString:value];
            
            //由于把value NSUTF8StringEncoding后，#变成了%23，网页地址打不开，所以去掉编码
            NSDictionary *linkDic = @{ NSLinkAttributeName :linkURL};
            [_mAString addAttributes:linkDic range:range];
            
        } else if ([name isEqualToString:@"bgcolor"]) {
            [_mAString addAttributes:@{NSBackgroundColorAttributeName : BTKRevertColor.color} range:range];
            
        }else if ([name isEqualToString:@"quote"]) {
            
            if (range.location + range.length + 1 <= _mAString.length) {
                NSString *nextString = [_mAString.string substringWithRange:NSMakeRange(range.location + range.length, 1)];
                if ([nextString isEqualToString:@"\n"]) {
                    range = NSMakeRange(range.location, range.length + 1);
                }
            }
            [_mAString beginEditing];
            mutParagraphStyle.lineSpacing = 0;
            mutParagraphStyle.paragraphSpacing = 0;

            UIFont *fontSize = [UIFont systemFontOfSize:_fontSize-3];
            [_mAString addAttribute:NSFontAttributeName value:fontSize range:range];
            [_mAString addAttribute:NSBackgroundColorAttributeName value:BTKRevertColor.color range:range];
            [_mAString addAttribute:NSForegroundColorAttributeName value:BTKRevertTextColor.color range:range];
            [_mAString endEditing];
            
        } else {
            DLog(@"element is not support !");
        }
    }
}

- (NSArray *)stylesWithParseText
{
    NSString *allElement = @"smiley|link|img|bgcolor|quote";
    NSString *regEx = @"\\[[^\\[](/){0,1}.*?( /){0,1}\\]";
    
    NSMutableString *processedString = [NSMutableString stringWithString:_string];
    
    //style set {element keys = @"name", @"value", @"range", @"discription"}
    NSMutableArray *styleOfElements = [NSMutableArray array];
    
    BOOL finished = NO;
    NSRange remainingRange = NSMakeRange(0, [processedString length]);
    NSString *beginTag = @"";
    NSUInteger quoteLoc = 0;
    NSUInteger linkLoc = 0;
    NSUInteger smileyLoc = 0;
    while (!finished)
    {
        NSRange tagRange = [processedString rangeOfString:regEx options:NSRegularExpressionSearch range:remainingRange];
        
        //no tag do stop
        if (tagRange.location == NSNotFound)
        {
            finished = YES;
            continue;
        }
        
        //parse element name
        NSString * fullTag = [processedString substringWithRange:tagRange];
        NSString * tagName = [fullTag stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[ /]"]];
        
        //check tag name is valid
        if ([fullTag rangeOfString:@"[/"].location == 0 && ([tagName isEqualToString:beginTag] || [tagName isEqualToString:@"quote"]))
        {
            /* Element Closed */
            
            //element content
            if ([tagName isEqualToString:@"quote"]) remainingRange.location = quoteLoc;
            
            if ([tagName isEqualToString:@"link"]) remainingRange.location = linkLoc;
            
            if ([tagName isEqualToString:@"smiley"]) remainingRange.location = smileyLoc;
            
            
            NSString *elementContent = elementContent = [processedString substringWithRange:NSMakeRange(remainingRange.location, tagRange.location - remainingRange.location)];
            
            NSString *newString = @"#";
            
            //check element
            if ([tagName isEqualToString:@"bgcolor"] || [tagName isEqualToString:@"quote"]) newString = elementContent;
            
            
            //check link
            if ([tagName isEqualToString:@"link"])
            {
                newString = elementContent;
                NSRange linkSeparateRange = [elementContent rangeOfString:@"|^|"];
                
                if (linkSeparateRange.location != NSNotFound)
                {
                    newString = [elementContent substringFromIndex:linkSeparateRange.location + linkSeparateRange.length];
                    elementContent = [elementContent substringToIndex:linkSeparateRange.location];
                }
            }
            
            //change valid string
            NSRange replaceRange = NSMakeRange(remainingRange.location, tagRange.location - remainingRange.location + tagRange.length);
            [processedString replaceCharactersInRange:replaceRange withString:newString];
            
            //add style
            [styleOfElements addObject:@{@"name" : tagName,
                                         @"value" : elementContent,
                                         @"range" : NSStringFromRange(NSMakeRange(remainingRange.location, newString.length))
                                         }];
            
            //reset remainingRange
            remainingRange.location = remainingRange.location + newString.length;
            remainingRange.length = [processedString length] - remainingRange.location;
            
        }
        else if ([fullTag rangeOfString:@"/]"].location == NSNotFound)
        {
            /* Element Open */
            
            //check tagName
            if ([allElement rangeOfString:tagName].location == NSNotFound)
            {
                remainingRange.location = tagRange.location + tagRange.length;
                remainingRange.length = [processedString length] - remainingRange.location;
                continue;
            }
            
            if ([tagName isEqualToString:@"quote"]) quoteLoc = tagRange.location;
            
            if ([tagName isEqualToString:@"link"]) linkLoc = tagRange.location;
            
            if ([tagName isEqualToString:@"smiley"]) smileyLoc = tagRange.location;
            
            
            //remain tagName
            beginTag = tagName;
            
            //clean this tag
            [processedString replaceCharactersInRange:tagRange withString:@""];
            
            
            //reset remainingRange
            remainingRange.location = tagRange.location;
            remainingRange.length = [processedString length] - remainingRange.location;
            
        } else {
            DLog(@"parse error!");
        }
        
    }
    
    self.mAString = [[NSMutableAttributedString alloc] initWithString:processedString];
    return styleOfElements;
}


- (CGRect)usedRect
{
    static NSTextStorage *textStorage;
    static NSTextContainer *textContainer;
    static NSLayoutManager *layoutManager;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        textStorage = [[NSTextStorage alloc] init];
        layoutManager = [[NSLayoutManager alloc] init];
        textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(_width, FLT_MAX)];
        
        [textStorage addLayoutManager:layoutManager];
        [layoutManager addTextContainer:textContainer];
    });
    
    if (_mAString.length > 0) [textStorage setAttributedString:_mAString];
    
    
    [layoutManager ensureLayoutForTextContainer:textContainer];
    
    
    //smiley info
    NSMutableArray *objs = [NSMutableArray array];
    for (NSDictionary *item in _smileyInfo)
    {
        NSRange range = NSRangeFromString(item[@"range"]);
        CGRect rect = [layoutManager boundingRectForGlyphRange:range inTextContainer:textContainer];
        [objs addObject:@{@"value" : item[@"value"], @"range" : item[@"range"], @"bounds" : NSStringFromCGRect(rect)}];
    }
    
    [_smileyInfo removeAllObjects];
    [_smileyInfo addObjectsFromArray:objs];
    
    return [layoutManager usedRectForTextContainer:textContainer];
}



#pragma mark Image part

- (void)downloadImages:(dImgBlock)completion {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    __block NSUInteger count = 0;
    
    for (NSDictionary *item in self.imageInfo)
    {
        NSString *imagePath = item[@"value"];
        NSRange range = NSRangeFromString(item[@"range"]);
        NSString *cached = item[@"cached"];
        
        if (cached.boolValue)
        {
            count ++;
            continue;
        }
        
        dispatch_group_async(group, queue, ^{
            [self getImage:imagePath result:^(UIImage *image)
             {
                 
                 if (image)
                 {
                     UIImage *newImg = [self scaleImage:image toScale:self.width  / image.size.width];
                     NSData *dataImg = UIImageJPEGRepresentation(newImg, 1);
                     
                     //save image
                     [self saveImage:dataImg path:imagePath];
                     
                     NSTextAttachment *iAttachment = [[NSTextAttachment alloc] initWithImageURL:imagePath];
                     iAttachment.image = newImg;
                     iAttachment.bounds = CGRectMake(0, 0, newImg.size.width, newImg.size.height);
                     NSAttributedString *iString = [NSAttributedString attributedStringWithAttachment:iAttachment];
                     
                     [self.mAString replaceCharactersInRange:range withAttributedString:iString];
                     
                     
                     //add center attribute
                     NSMutableParagraphStyle *mutParagraphStyle = [[NSMutableParagraphStyle alloc] init];
                     mutParagraphStyle.alignment = NSTextAlignmentCenter;
                     mutParagraphStyle.lineSpacing = 2.0f;
                     [_mAString beginEditing];
                     [_mAString addAttribute:NSParagraphStyleAttributeName value:mutParagraphStyle range:range];
                     [_mAString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:_fontSize] range:range];
                     [_mAString endEditing];
                     
                     //set newImg to NSCache
                     [self.cache setObject:newImg forKey:imagePath];
                     
                 }
                 count ++;
                 
                 if (self.imageInfo.count == count)
                 {
                     self.countOfCachedImage = count;
                     dispatch_async(dispatch_get_main_queue(), ^{
                        completion(self.mAString, self.usedSize, self.imageInfo, _tag);
                     });
                    
                 }
             }];
        });
    }
}


- (void)getImage:(NSString *)imageUrl result:(void(^)(UIImage *image))completion
{
    if (imageUrl)
    {
        //ek ver = 2.2增加https
        if (![imageUrl hasPrefix:@"https"]) {
            NSString *htStr = [imageUrl stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
            imageUrl = htStr;
        }
        
        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:imageUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
          {
              UIImage *image = [UIImage imageWithData:data];
              if (image){
                  completion (image);
              } else {
                  image = [UIImage imageNamed:BTKLoading];
                  completion (image);
                  DLog(@"getImage error= %@  检查url= %@", error.localizedDescription,imageUrl);
              }
          }] resume];
    }
    
}


- (NSData *)compressedData:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSUInteger dataLength = [data length];
    CGFloat quality;
    
    if(dataLength > MAX_IMAGEDATA_LEN)
        quality = 1.0 - MAX_IMAGEDATA_LEN / dataLength;
    else
        quality = 1.0;
    
    assert(quality <= 1.0 && quality >= 0);
    return UIImageJPEGRepresentation(image, quality);
    
}


- (UIImage *)scaleImage:(UIImage *)img toScale:(CGFloat)scale
{
    
    NSData *data = [self compressedData:img];
    img = [UIImage imageWithData:data];
    
    if (scale >= 1) return img;
    
    CGSize newSize = CGSizeMake(img.size.width * scale, img.size.height * scale);
    UIGraphicsBeginImageContext(newSize);
    [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *scaledImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImg;
}


- (BOOL)saveImage:(NSData *)imgData path:(NSString *)imagePath
{
    NSString *path = BTKCacheFolder;
    //如果不存在则创建临时存储目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if(![fileManager fileExistsAtPath:path])
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSString *filePath = [path stringByAppendingPathComponent:[self md5ForKey:imagePath]];
    BOOL succeed = [imgData writeToFile:filePath options:NSAtomicWrite error:&error];
    if (!succeed)
        DLog(@"write image false");
    return succeed;
    
}

+ (BOOL)cleanImageData {
    NSString *path = BTKCacheFolder;
    //如果不存在则创建临时存储目录
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    if([fileManager fileExistsAtPath:path]){
       return [fileManager removeItemAtPath:path error:&error];
    }
    return NO;
}

- (NSString *)md5ForKey:(NSString *)URLString
{
    const char *strs = [URLString UTF8String];
    unsigned char r[16];
    CC_MD5(strs, (CC_LONG)strlen(strs), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}


+ (void)appendGIF:(UIView *)view list:(NSArray *)gifList
{
    NSArray *subviews = [view subviews];
    for (UIView *view in subviews)
    {
        if (view.tag == 9876)
        {
            [view removeFromSuperview];
        }
    }
    
    for (NSDictionary *item in gifList)
    {
        NSString *value = item[@"value"];
        NSString *bounds = item[@"bounds"];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectFromString(bounds)];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        NSString *imgPath = [[BKFaceManage sharedInstance] mCoreImagePath:value];
        imgView.gifPath = imgPath;
        imgView.tag = 9876;
        [view addSubview:imgView];
        
        [imgView startGIF];
        //添加长按手势动作
        UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]
                                                        initWithTarget:self action:@selector(handleLongImg)];
        longPressReger.minimumPressDuration = 1.0;
        [imgView addGestureRecognizer:longPressReger];
    }
}


- (void)handleLongImg
{
    DLog(@"long Press Gesture Image");
}



#pragma mark NSCache Part

- (UIImage *)cachedImage:(NSString *)imageUrl
{
    
    NSString *imgKey = [self md5ForKey:imageUrl];
    UIImage *image = [self.cache objectForKey:imgKey];
    
    //not in memory cache
    if (nil == image)
    {
        //check smiley or image
        if ([imageUrl rangeOfString:@"http"].location == NSNotFound &&
            [imageUrl rangeOfString:@"/"].location == NSNotFound)
        {
            image = [[BKFaceManage sharedInstance] mCoreImageRuleMate:imageUrl];
        }
        else
        {
            
            NSString *path = [BTKCacheFolder stringByAppendingPathComponent:imgKey];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil])
            {
                image = [UIImage imageWithContentsOfFile:path];
            }
        }
        
        //add cache
        if (image)
        {
            [self.cache setObject:image forKey:imgKey];
        }
    }
    
    return image;
}


- (NSCache *)cache
{
    if (nil == _cache)
    {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = BTKCacheCountLimit;
        _cache.totalCostLimit = BTKCacheCostLimit;
        _cache.delegate = self;
    }
    return _cache;
}

@end



#pragma mark BTKAttachment Class
#import "objc/runtime.h"

@implementation NSTextAttachment(BTKAttachment)

@dynamic imageURL;

- (instancetype)initWithImageURL:(NSString *)url
{
    self = [self init];
    if (self) {
        self.imageURL = url;
    }
    
    return self;
}

- (NSString *)imageURL
{
    return objc_getAssociatedObject(self, @selector(imageURL));
}

- (void)setImageURL:(NSString *)imageURL
{
    objc_setAssociatedObject(self, @selector(imageURL), imageURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
