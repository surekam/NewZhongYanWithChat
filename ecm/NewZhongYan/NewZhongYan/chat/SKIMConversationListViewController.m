//
//  SKIMConversationListViewController.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-19.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMConversationListViewController.h"
#import "SKSToolBar.h"
#import "SKChatConversationCellTableViewCell.h"
#import "SKIMConversationDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "SKAddressController.h"

@interface SKIMConversationListViewController ()

@end

@implementation SKIMConversationListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDataSource];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    self.title = @"即时聊天";
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showContactsPicker)];
    self.tableView.frame = CGRectMake(0.0f, 0.0f,self.view.bounds.size.width, self.view.bounds.size.height-49.0f);
    [self createToolBar];
    [self loadDataSource];
    [self configuraTableViewNormalSeparatorInset];
    [self setExtraCellLineHidden:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showContactsPicker {
    SKAddressController *addresser = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"SKAddressController"];
    
    addresser.isChat = YES;
    addresser.fromViewController = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addresser];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - ToolBar
-(void)createToolBar
{
    SKSToolBar* myToolBar = [[SKSToolBar alloc] initWithFrame:CGRectMake(0, BottomY-49, 320, 49)];
    [myToolBar.firstButton addTarget:self action:@selector(showMenuOnView:) forControlEvents:UIControlEventTouchUpInside];
    //    [myToolBar.secondButton addTarget:self action:@selector(getUserInfoFromServer) forControlEvents:UIControlEventTouchUpInside];
    [myToolBar setFirstItem:@"btn_sms_ecm" Title:@"新建"];
    [myToolBar setSecondItem:@"btn_refresh_ecm" Title:@"刷新"];
    
    [self.view addSubview:myToolBar];
}

#pragma mark - DataSource
- (void)loadDataSource {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *dataSource = [NSMutableArray arrayWithArray:[SKIMConversation loadAllExistConversation]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataSource = dataSource;
            [self.tableView reloadData];
        });
    });
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"chatCellIdentifier";
    SKChatConversationCellTableViewCell *cell = (SKChatConversationCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SKChatConversationCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row < self.dataSource.count) {
        SKIMConversation *conversation = (SKIMConversation *)(self.dataSource[indexPath.row]);
        XHMessage *latestMsg = [conversation latestMessage];
        cell.nameLabel.text = [conversation conversationName];
        NSString *conversationImg = [conversation conversationHeadImg];
        if (conversationImg == nil || conversationImg.length == 0) {
            [cell.headImg setImage:[UIImage imageNamed:@"avator"]];
        } else {
            [cell.headImg sd_setImageWithURL:[NSURL URLWithString:[conversation conversationHeadImg]] placeholderImage:[UIImage imageNamed:[conversation chatterId]]];
        }
        [cell setTime:latestMsg.timestamp];
        //NSLog(@"msgTime=%@", [NSDateFormatter localizedStringFromDate:latestMsg.timestamp dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterFullStyle]);
        
        if (latestMsg) {
            switch (latestMsg.messageMediaType) {
                case XHBubbleMessageMediaTypeText:
                    cell.msgLabel.text = latestMsg.text;
                    break;
                case XHBubbleMessageMediaTypePhoto:
                    cell.msgLabel.text = @"[图片]";
                    break;
                case XHBubbleMessageMediaTypeVoice:
                    cell.msgLabel.text = @"[语音]";
                    break;
                case XHBubbleMessageMediaTypeVideo:
                    cell.msgLabel.text = @"[视频]";
                    break;
                case XHBubbleMessageMediaTypeLocalPosition:
                    cell.msgLabel.text = @"[位置]";
                    break;
                case XHBubbleMessageMediaTypeEmotion:
                    cell.msgLabel.text = @"[表情]";
                    break;
                default:
                    break;
            }

        }
        [cell setUnreadNum:[NSString stringWithFormat:@"%lu", (unsigned long)[conversation unreadMessagesCount]]];
    }
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SKIMConversationDetailViewController *conversationDetailVC = [[SKIMConversationDetailViewController alloc] init];
    conversationDetailVC.conversation = (SKIMConversation *)(self.dataSource[indexPath.row]);
    [self.navigationController pushViewController:conversationDetailVC animated:YES];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
@end