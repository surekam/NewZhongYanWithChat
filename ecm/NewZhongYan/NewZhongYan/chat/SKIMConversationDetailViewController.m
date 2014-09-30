//
//  SKIMConversationDetailViewController.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-15.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMConversationDetailViewController.h"
#import "XHDisplayTextViewController.h"
#import "XHDisplayMediaViewController.h"
#import "XHDisplayLocationViewController.h"
#import "XHContactDetailTableViewController.h"
#import "XHAudioPlayerHelper.h"
#import "SKIMUser.h"
#import "SKIMMessageDataManager.h"
#import "SKIMServiceDefs.h"
#import "RegExCategories.h"

@interface SKIMConversationDetailViewController () <XHAudioPlayerHelperDelegate>

@property (nonatomic, strong) NSArray *emotionManagers;
@property (nonatomic, strong) XHMessageTableViewCell *currentSelectedCell;
@property (nonatomic, strong) SKIMMessageDataManager *messageDataManager;
//@property (nonatomic, weak) UIView *MessageDetailView;

@end

@implementation SKIMConversationDetailViewController
@synthesize conversation = _conversation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[XHAudioPlayerHelper shareInstance] stopAudio];
    self.conversation.messages = self.messages;
    if (self.messages.count && !_conversation.isEnable) {
        _conversation.isEnable = YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置导航栏
    if (System_Version_Small_Than_(7)) {
        UIButton* backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backbtn setFrame:CGRectMake(0, 0, 50, 30)];
        [backbtn setBackgroundImage:Image(@"back") forState:UIControlStateNormal];
        [backbtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
        self.navigationItem.leftBarButtonItem = backItem;
    }else{
        UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] init];
        barBtn.title = @"返回";
        self.navigationItem.backBarButtonItem = barBtn;
    }
    
    //设置title
    if (_conversation) {
        self.title = [_conversation conversationName];
    }
    
    // 设置自身用户名
    self.messageSender = [SKIMUser currentUser].rid;
    self.messageSenderName = [SKIMUser currentUser].cname;
    
    // 添加第三方接入数据
    NSMutableArray *shareMenuItems = [NSMutableArray array];
    NSArray *plugIcons = @[@"sharemore_pic", @"sharemore_video", @"sharemore_location"];
    NSArray *plugTitle = @[@"照片", @"拍摄", @"位置"];
    for (NSString *plugIcon in plugIcons) {
        XHShareMenuItem *shareMenuItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:plugIcon] title:[plugTitle objectAtIndex:[plugIcons indexOfObject:plugIcon]]];
        [shareMenuItems addObject:shareMenuItem];
    }
    
    NSMutableArray *emotionManagers = [NSMutableArray array];

    XHEmotionManager *emotionManager = [[XHEmotionManager alloc] init];
    emotionManager.emotionName = @"经典";
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSInteger i = 0; i < 91; i++) {
        XHEmotion *emotion = [[XHEmotion alloc] init];
        NSString *imageName = [NSString stringWithFormat:@"%03ld", (long)i];
        emotion.emotionPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%03ld@2x.gif", (long)i] ofType:@""];
        emotion.emotionId = EMOTION_ID[i];
        emotion.emotionName = EMOTION_NAME[i];
        emotion.emotionConverPhoto = [UIImage imageNamed:imageName];
        [emotions addObject:emotion];
    }
    emotionManager.emotions = emotions;
    
    [emotionManagers addObject:emotionManager];
    
    
    self.emotionManagers = emotionManagers;
    [self.emotionManagerView reloadData];
    
    self.shareMenuItems = shareMenuItems;
    [self.shareMenuView reloadData];
    
    [self loadDataSource];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageReceived:) name:kNotiMessageReceived object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.emotionManagers = nil;
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotiMessageReceived object:nil];
}


- (void)loadDataSource {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *messages = weakSelf.conversation.messages;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.messages = messages;
            [weakSelf.messageTableView reloadData];
            
            [weakSelf scrollToBottomAnimated:NO];
        });
    });
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - XHMessageTableViewCell delegate

- (void)multiMediaMessageDidSelectedOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    UIViewController *disPlayViewController;
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypePhoto: {
            DLog(@"message : %@", message.photo);
            DLog(@"message : %@", message.videoConverPhoto);
            XHDisplayMediaViewController *messageDisplayTextView = [[XHDisplayMediaViewController alloc] init];
            messageDisplayTextView.message = message;
            disPlayViewController = messageDisplayTextView;
            break;
        }
            break;
        case XHBubbleMessageMediaTypeVoice: {
            DLog(@"message : %@", message.voicePath);
            [[XHAudioPlayerHelper shareInstance] setDelegate:self];
            if (_currentSelectedCell) {
                [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
            }
            if (_currentSelectedCell == messageTableViewCell) {
                [messageTableViewCell.messageBubbleView.animationVoiceImageView stopAnimating];
                [[XHAudioPlayerHelper shareInstance] stopAudio];
                self.currentSelectedCell = nil;
            } else {
                self.currentSelectedCell = messageTableViewCell;
                [messageTableViewCell.messageBubbleView.animationVoiceImageView startAnimating];
                [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:message.voicePath toPlay:YES];
            }
            break;
        }
        case XHBubbleMessageMediaTypeEmotion:
            DLog(@"facePath : %@", message.emotionPath);
            break;
        case XHBubbleMessageMediaTypeLocalPosition: {
            DLog(@"facePath : %@", message.localPositionPhoto);
            XHDisplayLocationViewController *displayLocationViewController = [[XHDisplayLocationViewController alloc] init];
            displayLocationViewController.message = message;
            disPlayViewController = displayLocationViewController;
            break;
        }
        default:
            break;
    }
    if (disPlayViewController) {
        [self.navigationController pushViewController:disPlayViewController animated:YES];
    }
}

- (void)didDoubleSelectedOnTextMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    DLog(@"text : %@", message.text);
    XHDisplayTextViewController *displayTextViewController = [[XHDisplayTextViewController alloc] init];
    displayTextViewController.message = message;
    [self.navigationController pushViewController:displayTextViewController animated:YES];
//    UIView *newView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    newView.backgroundColor = [UIColor lightGrayColor];
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMessageDetail)];
//    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
//    tapGestureRecognizer.cancelsTouchesInView = NO;
//    //将触摸事件添加到当前view
//    [newView addGestureRecognizer:tapGestureRecognizer];
//    [self.navigationController.view addSubview:newView];
//    _MessageDetailView = newView;
}

//- (void)hideMessageDetail {
//    if (_MessageDetailView) {
//        [_MessageDetailView removeFromSuperview];
//    }
//}

- (void)didSelectedAvatorOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    DLog(@"indexPath : %@", indexPath);
    XHContact *contact = [[XHContact alloc] init];
    contact.contactName = [message sender];
    contact.contactIntroduction = @"自定义描述，这个需要和业务逻辑挂钩";
    XHContactDetailTableViewController *contactDetailTableViewController = [[XHContactDetailTableViewController alloc] initWithContact:contact];
    [self.navigationController pushViewController:contactDetailTableViewController animated:YES];
}

- (void)menuDidSelectedAtBubbleMessageMenuSelecteType:(XHBubbleMessageMenuSelecteType)bubbleMessageMenuSelecteType onMessage:(id <XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    switch (bubbleMessageMenuSelecteType) {
        case XHBubbleMessageMenuSelecteTypeDelete:{

            [self.messages removeObjectAtIndex:indexPath.row];
            [self.messageTableView beginUpdates];
            [self.messageTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            NSLog(@"%d, %d", indexPath.row, self.messages.count);
            if (indexPath.row < self.messages.count) {
                [self.messageTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
            }
            [self.messageTableView endUpdates];
            
            [[SKIMMessageDataManager sharedMessageDataManager] deleteMessageFromDataBaseWithId:[message rid]];
            break;
        }
        default:
            break;
    }
}

- (void)reloadCellAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >=0 && indexPath.row < self.messages.count) {
        //[self.messageTableView beginUpdates];
        [self.messageTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
        //[self.messageTableView endUpdates];
    }
}

#pragma mark - XHMessageInputView Delegate

- (void)didKeybordDeleteButtonClicked {
    self.messageInputView.inputTextView.text = [self deleteTextAtInputTextViewWithText:self.messageInputView.inputTextView.text];
}

- (NSString *)deleteTextAtInputTextViewWithText:(NSString *)textOrigin {
    NSString *text = [textOrigin copy];
    if (text.length) {
        NSMutableArray *emotionMatchs = [[text matchesWithDetails:RX(EMOTION_NAME_REGX)] copy];
        for (RxMatch *emotionMatch in emotionMatchs) {
            BOOL isInclude = [EMOTION_NAME containsObject:emotionMatch.value];
            if (!isInclude) {
                [emotionMatchs removeObject:emotionMatch];
            }
        }
        RxMatch *lastMatch = [emotionMatchs lastObject];
        if (lastMatch.range.location + lastMatch.range.length == text.length) {
            text = [text substringToIndex:lastMatch.range.location];
        } else {
            text = [text substringToIndex:text.length - 1];
        }
    }
    return text;
}

#pragma mark - XHAudioPlayerHelper Delegate

- (void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer {
    if (!_currentSelectedCell) {
        return;
    }
    [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
    self.currentSelectedCell = nil;
}

#pragma mark - XHEmotionManagerView Delegate

- (void)didSendEmotion {
    NSString *text = self.messageInputView.inputTextView.text;
    if (text.length) {
        [self didSendMixContentAction:text];
    }
}

- (void)didDeleteEmotionButtonClicked {
    self.messageInputView.inputTextView.text = [self deleteTextAtInputTextViewWithText:self.messageInputView.inputTextView.text];
}


#pragma mark - XHEmotionManagerView DataSource

- (NSInteger)numberOfEmotionManagers {
    return self.emotionManagers.count;
}

- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column {
    return [self.emotionManagers objectAtIndex:column];
}

- (NSArray *)emotionManagersAtManager {
    return self.emotionManagers;
}

#pragma mark - XHMessageTableViewController Delegate

- (BOOL)shouldLoadMoreMessagesScrollToTop {
    return YES;
}

- (void)loadMoreMessagesScrollTotop {
    if (!self.loadingMoreMessage) {
        self.loadingMoreMessage = YES;
        self.conversation.messages = self.messages;
        
        WEAKSELF
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *messages = [weakSelf.conversation loadNumbersOfMessages:DEFAULT_LOAD_MSG_NUM];
            sleep(2);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf insertOldMessages:messages];
                weakSelf.loadingMoreMessage = NO;
            });
        });
    }
}

- (void)didSendMixContent:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *mixMessage = [[XHMessage alloc] initWithMixContent:text sender:sender timestamp:date];
    mixMessage.avator = [UIImage imageNamed:@"avator"];
    mixMessage.avatorUrl = [SKIMUser currentUser].avatarUri;
    mixMessage.receiver = self.conversation.chatterId;
    mixMessage.isGroup = self.conversation.isGroup;
    mixMessage.isRead = YES;
    mixMessage.deliveryState = MessageDeliveryState_Delivering;
    mixMessage.messageMediaType = XHBubbleMessageMediaTypeMix;
    [self addMessage:mixMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeMix];
    [[SKIMMessageDataManager sharedMessageDataManager] sendAndSaveMessage:mixMessage];
}

/**
 *  发送文本消息的回调方法
 *
 *  @param text   目标文本字符串
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *textMessage = [[XHMessage alloc] initWithText:text sender:sender timestamp:date];
    textMessage.avator = [UIImage imageNamed:@"avator"];
    textMessage.avatorUrl = [SKIMUser currentUser].avatarUri;
    textMessage.receiver = self.conversation.chatterId;
    textMessage.isGroup = self.conversation.isGroup;
    textMessage.isRead = YES;
    textMessage.deliveryState = MessageDeliveryState_Delivering;
    textMessage.messageMediaType = XHBubbleMessageMediaTypeText;
    [self addMessage:textMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
    [[SKIMMessageDataManager sharedMessageDataManager] sendAndSaveMessage:textMessage];
}

/**
 *  发送图片消息的回调方法
 *
 *  @param photo  目标图片对象，后续有可能会换
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *photoMessage = [[XHMessage alloc] initWithPhoto:photo thumbnailUrl:nil originPhotoUrl:nil sender:sender timestamp:date];
    photoMessage.avator = [UIImage imageNamed:@"avator"];
    photoMessage.avatorUrl = [SKIMUser currentUser].avatarUri;
    [self addMessage:photoMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypePhoto];
}

/**
 *  发送视频消息的回调方法
 *
 *  @param videoPath 目标视频本地路径
 *  @param sender    发送者的名字
 *  @param date      发送时间
 */
- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *videoMessage = [[XHMessage alloc] initWithVideoConverPhoto:videoConverPhoto videoPath:videoPath videoUrl:nil sender:sender timestamp:date];
    videoMessage.avator = [UIImage imageNamed:@"avator"];
    videoMessage.avatorUrl = [SKIMUser currentUser].avatarUri;
    [self addMessage:videoMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVideo];
}

/**
 *  发送语音消息的回调方法
 *
 *  @param voicePath        目标语音本地路径
 *  @param voiceDuration    目标语音时长
 *  @param sender           发送者的名字
 *  @param date             发送时间
 */
- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *voiceMessage = [[XHMessage alloc] initWithVoicePath:voicePath voiceUrl:nil voiceDuration:voiceDuration sender:sender timestamp:date];
    voiceMessage.avator = [UIImage imageNamed:@"avator"];
    voiceMessage.avatorUrl = [SKIMUser currentUser].avatarUri;
    [self addMessage:voiceMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVoice];
}

/**
 *  发送第三方表情消息的回调方法
 *
 *  @param facePath 目标第三方表情的本地路径
 *  @param sender   发送者的名字
 *  @param date     发送时间
 */
- (void)didSendEmotion:(NSString *)emotionPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *emotionMessage = [[XHMessage alloc] initWithEmotionPath:emotionPath sender:sender timestamp:date];
    emotionMessage.avator = [UIImage imageNamed:@"avator"];
    emotionMessage.avatorUrl = [SKIMUser currentUser].avatarUri;
    [self addMessage:emotionMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeEmotion];
}

/**
 *  有些网友说需要发送地理位置，这个我暂时放一放
 */
- (void)didSendGeoLocationsPhoto:(UIImage *)geoLocationsPhoto geolocations:(NSString *)geolocations location:(CLLocation *)location fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *geoLocationsMessage = [[XHMessage alloc] initWithLocalPositionPhoto:geoLocationsPhoto geolocations:geolocations location:location sender:sender timestamp:date];
    geoLocationsMessage.avator = [UIImage imageNamed:@"avator"];
    geoLocationsMessage.avatorUrl = [SKIMUser currentUser].avatarUri;
    [self addMessage:geoLocationsMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeLocalPosition];
}

/**
 *  是否显示时间轴Label的回调方法
 *
 *  @param indexPath 目标消息的位置IndexPath
 *
 *  @return 根据indexPath获取消息的Model的对象，从而判断返回YES or NO来控制是否显示时间轴Label
 */
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *currentMsgDate = ((id<XHMessageModel>)self.messages[indexPath.row]).timestamp;
    NSDate *preMsgDate = [NSDate dateWithTimeIntervalSince1970:0];
    if (indexPath.row > 0) {
        preMsgDate = ((id<XHMessageModel>)self.messages[indexPath.row - 1]).timestamp;
    }
    NSDateComponents *comp1 = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit|  NSHourCalendarUnit| NSMinuteCalendarUnit) fromDate:preMsgDate];
    NSDateComponents *comp2 = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit|  NSHourCalendarUnit| NSMinuteCalendarUnit) fromDate:currentMsgDate];
    currentMsgDate = [[NSCalendar currentCalendar] dateFromComponents:comp1];
    preMsgDate = [[NSCalendar currentCalendar] dateFromComponents:comp2];
    if ([currentMsgDate isEqualToDate:preMsgDate]) {
        return NO;
    }
    return YES;
}

/**
 *  配置Cell的样式或者字体
 *
 *  @param cell      目标Cell
 *  @param indexPath 目标Cell所在位置IndexPath
 */
- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
}

/**
 *  协议回掉是否支持用户手动滚动
 *
 *  @return 返回YES or NO
 */
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling {
    return YES;
}

#pragma mark - SKIMMessageDataManagerNotification

- (void)messageReceived:(NSNotification *)noti {
    XHMessage *message = [noti object];
    if (message && [message.sender isEqualToString:self.conversation.chatterId]) {
        [self addMessage:message];
    }
}
@end
