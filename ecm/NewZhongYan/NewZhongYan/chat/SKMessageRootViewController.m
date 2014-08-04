//
//  SKMessageRootViewController.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-7-15.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKMessageRootViewController.h"
#import "XHFoundationMacro.h"
#import "XHPopMenu.h"
#import "SKSToolBar.h"
#import "SKAddressController.h"
#import "SKChatMessageTableViewController.h"
#import "UIView+XHBadgeView.h"
#import "SKChatConversationCellTableViewCell.h"

@interface SKMessageRootViewController ()
@property (nonatomic, strong) XHPopMenu *popMenu;
@end

@implementation SKMessageRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showMenuOnView:)];
    self.tableView.frame = CGRectMake(0.0f, 0.0f,self.view.bounds.size.width, self.view.bounds.size.height-49.0f);
    [self createToolBar];
    [self loadDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMenuOnView:(UIBarButtonItem *)buttonItem {
    [self.popMenu showMenuOnView:self.view atPoint:CGPointZero];
}

#pragma mark - Propertys

- (XHPopMenu *)popMenu {
    if (!_popMenu) {
        NSMutableArray *popMenuItems = [[NSMutableArray alloc] initWithCapacity:6];
        for (int i = 0; i < 1; i ++) {
            NSString *imageName;
            NSString *title;
            switch (i) {
                case 0: {
                    imageName = @"contacts_add_newmessage";
                    title = @"发起聊天";
                    break;
                }
                default:
                    break;
            }
            XHPopMenuItem *popMenuItem = [[XHPopMenuItem alloc] initWithImage:[UIImage imageNamed:imageName] title:title];
            [popMenuItems addObject:popMenuItem];
        }
        
        WEAKSELF
        _popMenu = [[XHPopMenu alloc] initWithMenus:popMenuItems];
        _popMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *popMenuItems) {
            if (index == 0 ) {
                [weakSelf showContactsPicker];
            }
        };
    }
    return _popMenu;
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
        NSMutableArray *dataSource = [NSMutableArray array];
        NSDictionary *u1 = @{@"name": @"海神", @"headImg": @"avator", @"msg": @"Hello!", @"msgTime": @"17:00"};
        NSDictionary *u2 = @{@"name": @"剑圣", @"headImg": @"avator", @"msg": @"Hello!", @"msgTime": @"8:38"};
        NSDictionary *u3 = @{@"name": @"敌法", @"headImg": @"avator", @"msg": @"Hello!", @"msgTime": @"星期日"};
        NSDictionary *u4 = @{@"name": @"屠夫", @"headImg": @"avator", @"msg": @"Hello!", @"msgTime": @"星期五"};
        NSDictionary *u5 = @{@"name": @"巫妖", @"headImg": @"avator", @"msg": @"Hello!", @"msgTime": @"8月21日"};
        NSDictionary *u6 = @{@"name": @"神牛", @"headImg": @"avator", @"msg": @"Hello!", @"msgTime": @"7月21日"};
        NSDictionary *u7 = @{@"name": @"幻影刺客", @"headImg": @"avator", @"msg": @"让我来解脱你的痛苦 --恩赐解脱", @"msgTime": @"7月21日"};
        NSDictionary *u8 = @{@"name": @"炸弹人", @"headImg": @"avator", @"msg": @"注意！不要被炸死了哟。", @"msgTime": @"7月11日"};
        
        [dataSource addObject:u1];
        [dataSource addObject:u2];
        [dataSource addObject:u3];
        [dataSource addObject:u4];
        [dataSource addObject:u5];
        [dataSource addObject:u6];
        [dataSource addObject:u7];
        [dataSource addObject:u8];
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
        cell.nameLabel.text = [self.dataSource[indexPath.row] objectForKey:@"name"];
        cell.msgLabel.text = [self.dataSource[indexPath.row] objectForKey:@"msg"];
        cell.headImg.image = [UIImage imageNamed:[self.dataSource[indexPath.row] objectForKey:@"headImg"]];
        cell.timeLabel.text = [self.dataSource[indexPath.row] objectForKey:@"msgTime"];
    }
    
    [cell.headImg setupCircleBadge];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self enterMessage];
}

#pragma mark - Action
- (void)enterMessage {
    SKChatMessageTableViewController *msgTableViewController = [[SKChatMessageTableViewController alloc] init];
    [self.navigationController pushViewController:msgTableViewController animated:YES];
}
@end
