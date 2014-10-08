//
//  XHMessageBubbleView.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageBubbleView.h"

#import "XHMessageBubbleHelper.h"
#import "RegExCategories.h"
#import "UIImageView+WebCache.h"
#import "SEPhotoView.h"
#import "XHEmotion.h"
#import "SKIMServiceDefs.h"

#define kMarginTop 8.0f
#define kMarginRight 9.0f
#define kMarginBottom 2.0f
#define kPaddingTop 12.0f
#define kBubblePaddingRight 14.0f

#define kVoiceMargin 20.0f

#define kXHArrowMarginWidth 14

@interface XHMessageBubbleView ()

@property (nonatomic, weak, readwrite) SETextView *displayTextView;

@property (nonatomic, weak, readwrite) UIImageView *bubbleImageView;

@property (nonatomic, weak, readwrite) FLAnimatedImageView *emotionImageView;

@property (nonatomic, weak, readwrite) UIImageView *animationVoiceImageView;

@property (nonatomic, weak, readwrite) XHBubblePhotoImageView *bubblePhotoImageView;

@property (nonatomic, weak, readwrite) UIImageView *videoPlayImageView;

@property (nonatomic, weak, readwrite) UILabel *geolocationsLabel;

@property (nonatomic, strong, readwrite) id <XHMessageModel> message;

@property (nonatomic, weak, readwrite) UIActivityIndicatorView * deliveryIndicatorView;

@property (nonatomic, weak, readwrite) UIImageView *deliveryFailedImageView;

@end

@implementation XHMessageBubbleView

#pragma mark - Bubble view

+ (CGFloat)neededWidthForText:(NSString *)text {
    CGSize stringSize;
    stringSize = [text sizeWithFont:[[XHMessageBubbleView appearance] font] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return roundf(stringSize.width);
    
//    NSDictionary *dic = [[XHMessageBubbleView appearance] font].fontDescriptor.fontAttributes;
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    [dic setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
//    // 计算文本的大小
//    CGFloat maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) * (kIsiPad ? 0.8 : 0.55);
//    CGSize textSize = [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
//                                                  options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
//                                               attributes:dic        // 文字的属性
//                                                  context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
//    NSLog(@"w = %f", textSize.width);
//    NSLog(@"h = %f", textSize.height);
//    return roundf(textSize.width);
}

+ (CGSize)neededSizeForText:(NSString *)text {
    CGFloat maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) * (kIsiPad ? 0.8 : 0.6);
    
    CGFloat dyWidth = [XHMessageBubbleView neededWidthForText:text];
    
    CGSize textSize = [SETextView frameRectWithAttributtedString:[[XHMessageBubbleHelper sharedMessageBubbleHelper] bubbleAttributtedStringWithText:text] constraintSize:CGSizeMake(maxWidth, MAXFLOAT) lineSpacing:kXHTextLineSpacing font:[[XHMessageBubbleView appearance] font]].size;
    textSize.width = dyWidth > textSize.width ? textSize.width : dyWidth;
    
    return CGSizeMake(textSize.width + kBubblePaddingRight * 2 + kXHArrowMarginWidth, textSize.height + kMarginTop * 2);
}

+ (CGSize)neededSizeForPhoto:(UIImage *)photo {
    // 这里需要缩放后的size
    CGSize photoSize = CGSizeMake(120, 120);
    return photoSize;
}

+ (CGSize)neededSizeForEmotion {
    CGSize emotionSize = CGSizeMake(kXHEmotionImageViewSize + kBubblePaddingRight * 2 + kXHArrowMarginWidth, kXHEmotionImageViewSize + kMarginTop * 2);
    return emotionSize;
}

+ (CGSize)neededSizeForVoicePath:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration {
    // 这里的100只是暂时固定，到时候会根据一个函数来计算
    float gapDuration = (!voiceDuration || voiceDuration.length == 0 ? -1 : [voiceDuration floatValue] - 1.0f);
    CGSize voiceSize = CGSizeMake(100 + (gapDuration > 0 ? (120.0 / (60 - 1) * gapDuration) : 0), 30);
    return voiceSize;
}

+ (CGSize)neededSizeForMixContent:(NSString *)text {
    NSString *pictureRegexStr = PICTURE_REGX;
    NSString *emoticonNameRegexStr = EMOTION_NAME_REGX;
    CGSize textSize = CGSizeZero;
    
    //计算不包含图片的文本宽度
    NSString *textWithoutPic = [text replace:RX(pictureRegexStr) with:@"\n"];
    textSize = [XHMessageBubbleView neededSizeForText:[textWithoutPic replace:RX(emoticonNameRegexStr) with:@"[情]"]];
    
    //计算表情高度
    NSString *textWithoutPicAndEmo = [[text replace:RX(pictureRegexStr) with:@""] replace:RX(emoticonNameRegexStr) with:@""];
    if ([RX(emoticonNameRegexStr) isMatch:textWithoutPic]) {
        if (textSize.height < 28 + kPaddingTop + kMarginBottom * 2) {
            textSize.height = 28 + kPaddingTop + kMarginBottom * 2 + (textWithoutPicAndEmo.length ? kMarginBottom : 0);
            if (!textWithoutPicAndEmo.length) {
                NSUInteger allMatchs = [textWithoutPic matches:RX(emoticonNameRegexStr)].count;
                CGFloat width = kBubblePaddingRight * 2 + kXHArrowMarginWidth + 28 * allMatchs;
                textSize.width = textSize.width < width ? width : textSize.width;
            }
        } else {
            //匹配表情的行数
            NSUInteger lineMatchs = 0;
            //所有行中匹配的表情数，不包含折行时的匹配。
            NSUInteger matchsInLines = 0;
            //所有的表情数
            NSUInteger allMatchs = [textWithoutPic matches:RX(emoticonNameRegexStr)].count;
            
            NSUInteger lines = round((textSize.height - kMarginTop * 2) / ([[XHMessageBubbleView appearance] font].lineHeight + kXHTextLineSpacing));
            for (int i = 0; i < lines; i++) {
                NSUInteger lineLength = textWithoutPic.length / lines;
                NSString *lineText = [textWithoutPic substringWithRange:NSMakeRange(i * lineLength, i < lines - 1 ? lineLength : textWithoutPic.length - i * lineLength)];
                NSArray *emoticonMatchsInLine = [lineText matches:RX(emoticonNameRegexStr)];
                lineMatchs += emoticonMatchsInLine.count ? 1 : 0;
                matchsInLines += emoticonMatchsInLine.count;
            }
            lineMatchs += allMatchs - matchsInLines;
            
            CGFloat height = 0;
            if (textWithoutPicAndEmo.length) {
                height = textSize.height + (29 - [[XHMessageBubbleView appearance] font].lineHeight) * lineMatchs;
            } else {
                height = textSize.height + 13 * lines;
            }
            
            textSize.height = height;
        }
    }
    
    //计算图片宽度
    NSArray *pictureMatchs = [text matches:RX(pictureRegexStr)];
    CGSize picSize = [XHMessageBubbleView neededSizeForPhoto:nil];
    CGFloat picWidth = pictureMatchs.count ? picSize.width : 0.0;
    
    CGFloat dyWidth = textSize.width > picWidth ? textSize.width : picWidth + kBubblePaddingRight * 3;

    return CGSizeMake(dyWidth, textSize.height + picSize.height * pictureMatchs.count);
}

+ (CGFloat)calculateCellHeightWithMessage:(id <XHMessageModel>)message {
    CGSize size = [XHMessageBubbleView getBubbleFrameWithMessage:message];
    return size.height + kMarginTop + kMarginBottom;
}

+ (CGSize)getBubbleFrameWithMessage:(id <XHMessageModel>)message {
    CGSize bubbleSize;
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeText: {
            bubbleSize = [XHMessageBubbleView neededSizeForText:message.text];
            break;
        }
        case XHBubbleMessageMediaTypePhoto: {
            bubbleSize = [XHMessageBubbleView neededSizeForPhoto:message.photo];
            break;
        }
        case XHBubbleMessageMediaTypeVideo: {
            bubbleSize = [XHMessageBubbleView neededSizeForPhoto:message.videoConverPhoto];
            break;
        }
        case XHBubbleMessageMediaTypeVoice: {
            // 这里的宽度是不定的，高度是固定的，根据需要根据语音长短来定制啦
            bubbleSize = [XHMessageBubbleView neededSizeForVoicePath:message.voicePath voiceDuration:message.voiceDuration];
            break;
        }
        case XHBubbleMessageMediaTypeEmotion:
            // 是否固定大小呢？
            bubbleSize = [XHMessageBubbleView neededSizeForEmotion];
            break;
        case XHBubbleMessageMediaTypeLocalPosition:
            // 固定大小，必须的
            bubbleSize = CGSizeMake(119, 119);
            break;
        case XHBubbleMessageMediaTypeMix:
            bubbleSize = [XHMessageBubbleView neededSizeForMixContent:message.text];
            break;
        default:
            break;
    }
    //NSLog(@"bubbleSize=%f,%f", bubbleSize.width, bubbleSize.height);
    return bubbleSize;
}

#pragma mark - UIAppearance Getters

- (UIFont *)font {
    if (_font == nil) {
        _font = [[[self class] appearance] font];
    }
    
    if (_font != nil) {
        return _font;
    }
    
    return [UIFont systemFontOfSize:16.0f];
}

#pragma mark - Getters


- (CGRect)bubbleFrame {
    CGSize bubbleSize = [XHMessageBubbleView getBubbleFrameWithMessage:self.message];
    
    return CGRectIntegral(CGRectMake((self.message.bubbleMessageType == XHBubbleMessageTypeSending ? CGRectGetWidth(self.bounds) - bubbleSize.width : 0.0f),
                                     kMarginTop,
                                     bubbleSize.width,
                                     bubbleSize.height + kMarginTop + kMarginBottom));
}

#pragma mark - Life cycle

- (void)configureCellWithMessage:(id <XHMessageModel>)message {
    _message = message;
    
    [self configureBubbleImageView:message];
    
    [self configureMessageDisplayMediaWithMessage:message];
}

- (void)configureBubbleImageView:(id <XHMessageModel>)message {
    XHBubbleMessageMediaType currentType = message.messageMediaType;
    
    _voiceDurationLabel.hidden = YES;
    switch (currentType) {
        case XHBubbleMessageMediaTypeVoice: {
            _voiceDurationLabel.hidden = NO;
        }
        case XHBubbleMessageMediaTypeText:
        case XHBubbleMessageMediaTypeEmotion: {
            _bubbleImageView.image = [XHMessageBubbleFactory bubbleImageViewForType:message.bubbleMessageType style:XHBubbleImageViewStyleWeChat meidaType:message.messageMediaType];
            // 只要是文本、语音、第三方表情，背景的气泡都不能隐藏
            _bubbleImageView.hidden = NO;
            
            // 只要是文本、语音、第三方表情，都需要把显示尖嘴图片的控件隐藏了
            _bubblePhotoImageView.hidden = YES;
            
            
            if (currentType == XHBubbleMessageMediaTypeText) {
                // 如果是文本消息，那文本消息的控件需要显示
                _displayTextView.hidden = NO;
                // 那语言的gif动画imageView就需要隐藏了
                _animationVoiceImageView.hidden = YES;
                _emotionImageView.hidden = YES;
            } else {
                // 那如果不文本消息，必须把文本消息的控件隐藏了啊
                _displayTextView.hidden = YES;
                
                // 对语音消息的进行特殊处理，第三方表情可以直接利用背景气泡的ImageView控件
                if (currentType == XHBubbleMessageMediaTypeVoice) {
                    [_animationVoiceImageView removeFromSuperview];
                    _animationVoiceImageView = nil;
                    
                    UIImageView *animationVoiceImageView = [XHMessageVoiceFactory messageVoiceAnimationImageViewWithBubbleMessageType:message.bubbleMessageType];
                    [self addSubview:animationVoiceImageView];
                    _animationVoiceImageView = animationVoiceImageView;
                    _animationVoiceImageView.hidden = NO;
                } else {
                    _emotionImageView.hidden = NO;
                    
                    _bubbleImageView.hidden = NO;
                    _animationVoiceImageView.hidden = YES;
                }
            }
            break;
        }
        case XHBubbleMessageMediaTypePhoto:
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypeLocalPosition: {
            // 只要是图片和视频消息，必须把尖嘴显示控件显示出来
            _bubblePhotoImageView.hidden = NO;
            
            _videoPlayImageView.hidden = (currentType != XHBubbleMessageMediaTypeVideo);
            
            _geolocationsLabel.hidden = (currentType != XHBubbleMessageMediaTypeLocalPosition);
            
            // 那其他的控件都必须隐藏
            _displayTextView.hidden = YES;
            _bubbleImageView.hidden = YES;
            _animationVoiceImageView.hidden = YES;
            _emotionImageView.hidden = YES;
            break;
        }
        case XHBubbleMessageMediaTypeMix: {
            _bubbleImageView.image = [XHMessageBubbleFactory bubbleImageViewForType:message.bubbleMessageType style:XHBubbleImageViewStyleWeChat meidaType:message.messageMediaType];
            _bubbleImageView.hidden = NO;
            _displayTextView.hidden = NO;
            
            _bubblePhotoImageView.hidden = YES;
            _animationVoiceImageView.hidden = YES;
            _emotionImageView.hidden = YES;
            
            break;
        }
        
        default:
            break;
    }
}

- (void)configureMessageDisplayMediaWithMessage:(id <XHMessageModel>)message {
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeText:
            _displayTextView.attributedText = [[XHMessageBubbleHelper sharedMessageBubbleHelper] bubbleAttributtedStringWithText:[message text]];
            break;
        case XHBubbleMessageMediaTypePhoto:
            [_bubblePhotoImageView configureMessagePhoto:message.photo thumbnailUrl:message.thumbnailUrl originPhotoUrl:message.originPhotoUrl onBubbleMessageType:self.message.bubbleMessageType];
            break;
        case XHBubbleMessageMediaTypeVideo:
            [_bubblePhotoImageView configureMessagePhoto:message.videoConverPhoto thumbnailUrl:message.thumbnailUrl originPhotoUrl:message.originPhotoUrl onBubbleMessageType:self.message.bubbleMessageType];
            break;
        case XHBubbleMessageMediaTypeVoice:
            break;
        case XHBubbleMessageMediaTypeEmotion:
            // 直接设置GIF
            if (message.emotionPath) {
                NSData *animatedData = [NSData dataWithContentsOfFile:message.emotionPath];
                FLAnimatedImage *animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedData];
                _emotionImageView.animatedImage = animatedImage;
            }
            break;
        case XHBubbleMessageMediaTypeLocalPosition:
            [_bubblePhotoImageView configureMessagePhoto:message.localPositionPhoto thumbnailUrl:nil originPhotoUrl:nil onBubbleMessageType:self.message.bubbleMessageType];
            
            _geolocationsLabel.text = message.geolocations;
            break;
        case XHBubbleMessageMediaTypeMix: {
            NSString *fixContent = [message.text copy];
            NSString *emoticonNameRegexStr = EMOTION_NAME_REGX;
            NSString *pictureRegexStr = PICTURE_REGX;
            
            NSArray *picMatchs = [message.text matchesWithDetails:RX(pictureRegexStr)];
            
            for (RxMatch *picMatch in picMatchs) {
                NSRange range = NSMakeRange(picMatch.range.location + (fixContent.length - message.text.length), picMatch.range.length);
                if (picMatch.range.location == 0) {
                    fixContent = [fixContent stringByReplacingCharactersInRange:range withString:[picMatch.value stringByAppendingString:@"\n"]];
                } else if (picMatch.range.location + picMatch.range.length == message.text.length) {
                    fixContent = [fixContent stringByReplacingCharactersInRange:range withString:[@"\n" stringByAppendingString:picMatch.value]];
                } else {
                    fixContent = [fixContent stringByReplacingCharactersInRange:range withString:[@"\n" stringByAppendingString:[picMatch.value stringByAppendingString:@"\n"]]];
                }
            }
            _displayTextView.attributedText = [[XHMessageBubbleHelper sharedMessageBubbleHelper] bubbleAttributtedStringWithText:fixContent];
            picMatchs = [fixContent matchesWithDetails:RX(pictureRegexStr)];
            for (RxMatch *picMatch in picMatchs) {
                UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avator"]];
                [_displayTextView addObject:img size:[XHMessageBubbleView neededSizeForPhoto:img.image] replaceRange:picMatch.range];
            }
            
            NSArray *emoticonMatchs = [fixContent matchesWithDetails:RX(emoticonNameRegexStr)];
            for (RxMatch *emoticonMatch in emoticonMatchs) {
                NSUInteger index = [EMOTION_NAME indexOfObject:emoticonMatch.value];
                if (index != NSNotFound) {
                    NSData *animatedData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%03ld@2x.gif", (long)index] ofType:@""]];
                    FLAnimatedImage *animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedData];
                    FLAnimatedImageView *emotionView = [[FLAnimatedImageView alloc] initWithFrame:CGRectZero];
                    emotionView.animatedImage = animatedImage;
                    [_displayTextView addObject:emotionView size:CGSizeMake(28, 28) replaceRange:emoticonMatch.range];
                }
            }
            
            break;
        }
        default:
            break;
    }
    
    [self setNeedsLayout];
}

- (instancetype)initWithFrame:(CGRect)frame
                      message:(id <XHMessageModel>)message {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _message = message;
        
        // 1、初始化气泡的背景
        if (!_bubbleImageView) {
            //bubble image
            FLAnimatedImageView *bubbleImageView = [[FLAnimatedImageView alloc] init];
            bubbleImageView.frame = self.bounds;
            bubbleImageView.userInteractionEnabled = YES;
            [self addSubview:bubbleImageView];
            _bubbleImageView = bubbleImageView;
        }
        
        // 2、初始化显示文本消息的TextView
        if (!_displayTextView) {
            SETextView *displayTextView = [[SETextView alloc] initWithFrame:CGRectZero];
            displayTextView.backgroundColor = [UIColor clearColor];
            displayTextView.selectable = NO;
            displayTextView.lineSpacing = kXHTextLineSpacing;
            displayTextView.font = [[XHMessageBubbleView appearance] font];
            displayTextView.showsEditingMenuAutomatically = NO;
            displayTextView.highlighted = NO;
            [self addSubview:displayTextView];
            _displayTextView = displayTextView;
        }
        
        // 3、初始化显示图片的控件
        if (!_bubblePhotoImageView) {
            XHBubblePhotoImageView *bubblePhotoImageView = [[XHBubblePhotoImageView alloc] initWithFrame:CGRectZero];
            [self addSubview:bubblePhotoImageView];
            _bubblePhotoImageView = bubblePhotoImageView;
            
            if (!_videoPlayImageView) {
                UIImageView *videoPlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageVideoPlay"]];
                [bubblePhotoImageView addSubview:videoPlayImageView];
                _videoPlayImageView = videoPlayImageView;
            }
            
            if (!_geolocationsLabel) {
                UILabel *geolocationsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                geolocationsLabel.numberOfLines = 0;
                geolocationsLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                geolocationsLabel.textColor = [UIColor whiteColor];
                geolocationsLabel.backgroundColor = [UIColor clearColor];
                geolocationsLabel.font = [UIFont systemFontOfSize:12];
                [bubblePhotoImageView addSubview:geolocationsLabel];
                _geolocationsLabel = geolocationsLabel;
            }
        }
        
        // 4、初始化显示语音时长的label
        if (!_voiceDurationLabel) {
            UILabel *voiceDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 30, 30)];
            voiceDurationLabel.textColor = [UIColor lightGrayColor];
            voiceDurationLabel.backgroundColor = [UIColor clearColor];
            voiceDurationLabel.font = [UIFont systemFontOfSize:13.f];
            voiceDurationLabel.textAlignment = NSTextAlignmentRight;
            voiceDurationLabel.hidden = YES;
            [self addSubview:voiceDurationLabel];
            _voiceDurationLabel = voiceDurationLabel;
        }
        
        // 5、初始化显示gif表情的控件
        if (!_emotionImageView) {
            FLAnimatedImageView *emotionImageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectZero];
            [self addSubview:emotionImageView];
            _emotionImageView = emotionImageView;
        }
        
        // 初始化显示发送状态的控件
        if (!_deliveryIndicatorView) {
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicatorView.backgroundColor = [UIColor clearColor];
            [self addSubview:indicatorView];
            _deliveryIndicatorView = indicatorView;
            
            UIImageView *deliveryFailedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_send_failed@2x"]];
            deliveryFailedImageView.hidden = YES;
            [self addSubview:deliveryFailedImageView];
            _deliveryFailedImageView = deliveryFailedImageView;
        }
    }
    return self;
}

- (void)dealloc {
    _message = nil;
    
    _displayTextView = nil;
    
    _bubbleImageView = nil;
    
    _bubblePhotoImageView = nil;
    
    _animationVoiceImageView = nil;
    
    _voiceDurationLabel = nil;
    
    _emotionImageView = nil;
    
    _videoPlayImageView = nil;
    
    _geolocationsLabel = nil;
    
    _font = nil;
    
    _deliveryIndicatorView = nil;
    
    _deliveryFailedImageView = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    XHBubbleMessageMediaType currentType = self.message.messageMediaType;
    CGRect bubbleFrame = [self bubbleFrame];
    
    switch (currentType) {
        case XHBubbleMessageMediaTypeText:
        case XHBubbleMessageMediaTypeVoice:
        case XHBubbleMessageMediaTypeEmotion: {
            self.bubbleImageView.frame = bubbleFrame;
            
            CGFloat textX = CGRectGetMinX(bubbleFrame) + kBubblePaddingRight;
            
            if (self.message.bubbleMessageType == XHBubbleMessageTypeReceiving) {
                textX += kXHArrowMarginWidth / 2.0;
            }
            
            CGRect textFrame = CGRectMake(textX,
                                          CGRectGetMinY(bubbleFrame) + kPaddingTop,
                                          CGRectGetWidth(bubbleFrame) - kBubblePaddingRight * 2 - kMarginRight,
                                          bubbleFrame.size.height - kMarginTop * 2);
            
            self.displayTextView.frame = CGRectIntegral(textFrame);
            
            CGRect animationVoiceImageViewFrame = self.animationVoiceImageView.frame;
            animationVoiceImageViewFrame.origin = CGPointMake((self.message.bubbleMessageType == XHBubbleMessageTypeReceiving ? (bubbleFrame.origin.x + kVoiceMargin) : (bubbleFrame.origin.x + CGRectGetWidth(bubbleFrame) - kVoiceMargin - CGRectGetWidth(animationVoiceImageViewFrame))), 17);
            self.animationVoiceImageView.frame = animationVoiceImageViewFrame;
            
            [self resetVoiceDurationLabelFrameWithBubbleFrame:bubbleFrame];
            
            self.emotionImageView.frame = CGRectMake(textX, CGRectGetMinY(bubbleFrame) + kPaddingTop, kXHEmotionImageViewSize, kXHEmotionImageViewSize);
            break;
        }
        case XHBubbleMessageMediaTypePhoto:
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypeLocalPosition: {
            CGRect photoImageViewFrame = CGRectMake(bubbleFrame.origin.x - 2, 0, bubbleFrame.size.width, bubbleFrame.size.height);
            self.bubblePhotoImageView.frame = photoImageViewFrame;
            
            self.videoPlayImageView.center = CGPointMake(CGRectGetWidth(photoImageViewFrame) / 2.0, CGRectGetHeight(photoImageViewFrame) / 2.0);
            
            CGRect geolocationsLabelFrame = CGRectMake(11, CGRectGetHeight(photoImageViewFrame) - 47, CGRectGetWidth(photoImageViewFrame) - 20, 40);
            self.geolocationsLabel.frame = geolocationsLabelFrame;
            
            break;
        }
        case XHBubbleMessageMediaTypeMix: {
            self.bubbleImageView.frame = bubbleFrame;
            
            CGFloat mixX = CGRectGetMinX(bubbleFrame) + kBubblePaddingRight;
            if (self.message.bubbleMessageType == XHBubbleMessageTypeReceiving) {
                mixX += kXHArrowMarginWidth / 2.0;
            }
            CGRect mixFrame = CGRectMake(mixX,
                                          CGRectGetMinY(bubbleFrame) + kPaddingTop,
                                          CGRectGetWidth(bubbleFrame) - kBubblePaddingRight * 2,
                                          bubbleFrame.size.height - kMarginTop - kMarginBottom);
            self.displayTextView.frame = CGRectIntegral(mixFrame);
            //self.displayTextView.backgroundColor = [UIColor blueColor];
            
//            NSLog(@"-------------------------");
//            NSLog(@"bubbleFrame=%f,%f,%f,%f", bubbleFrame.origin.x, bubbleFrame.origin.y, bubbleFrame.size.width, bubbleFrame.size.height);
//            NSLog(@"mixFrame=%f,%f,%f,%f", mixFrame.origin.x, mixFrame.origin.y, mixFrame.size.width, mixFrame.size.height);
//            NSLog(@"-------------------------");
            
            break;
        }
        default:
            break;
    }
    [self resetdeliveryViewFrameWithBubbleFrame];
}

- (void)resetVoiceDurationLabelFrameWithBubbleFrame:(CGRect)bubbleFrame {
    CGRect voiceFrame = _voiceDurationLabel.frame;
    voiceFrame.origin.x = (self.message.bubbleMessageType == XHBubbleMessageTypeSending ? bubbleFrame.origin.x - _voiceDurationLabel.frame.size.width : bubbleFrame.origin.x + bubbleFrame.size.width);
    _voiceDurationLabel.frame = voiceFrame;
    
    _voiceDurationLabel.textAlignment = (self.message.bubbleMessageType == XHBubbleMessageTypeSending ? NSTextAlignmentRight : NSTextAlignmentLeft);
}

- (void)resetdeliveryViewFrameWithBubbleFrame {
    CGPoint deliveryIndicatorCenter = CGPointZero;
    CGRect deliveryFailedFrame = CGRectMake(0, 0, 20, 20);
    CGRect bubbleFrame = CGRectZero;
    XHBubbleMessageMediaType currentType = self.message.messageMediaType;
    switch (currentType) {
        case XHBubbleMessageMediaTypeText:
        case XHBubbleMessageMediaTypeMix:
            bubbleFrame = self.bubbleImageView.frame;
            break;
        case XHBubbleMessageMediaTypeVoice:
            bubbleFrame = self.voiceDurationLabel.frame;
            break;
        case XHBubbleMessageMediaTypeEmotion:
            bubbleFrame = self.emotionImageView.frame;
            break;
        case XHBubbleMessageMediaTypePhoto:
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypeLocalPosition:
            bubbleFrame = self.bubblePhotoImageView.frame;
            break;
        default:
            break;
    }
    deliveryIndicatorCenter.x = (self.message.bubbleMessageType == XHBubbleMessageTypeSending ? bubbleFrame.origin.x - _deliveryIndicatorView.frame.size.width : bubbleFrame.origin.x + bubbleFrame.size.width + _deliveryIndicatorView.frame.size.width);
    deliveryIndicatorCenter.y = (bubbleFrame.origin.y + _deliveryIndicatorView.frame.size.height);
    _deliveryIndicatorView.center = deliveryIndicatorCenter;
    
    deliveryFailedFrame.origin.x = (self.message.bubbleMessageType == XHBubbleMessageTypeSending ? bubbleFrame.origin.x - deliveryFailedFrame.size.width : bubbleFrame.origin.x + bubbleFrame.size.width);
    deliveryFailedFrame.origin.y = bubbleFrame.origin.y + deliveryFailedFrame.size.height/2;
    _deliveryFailedImageView.frame = deliveryFailedFrame;
}

@end
