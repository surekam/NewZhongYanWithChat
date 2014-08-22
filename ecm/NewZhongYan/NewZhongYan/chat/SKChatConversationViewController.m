//
//  SKMessageRootViewController.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-7-15.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKChatConversationViewController.h"
#import "XHFoundationMacro.h"
#import "XHPopMenu.h"
#import "SKSToolBar.h"
#import "SKAddressController.h"
#import "SKChatMessageTableViewController.h"
#import "SKChatConversationCellTableViewCell.h"

@interface SKChatConversationViewController ()
@property (nonatomic, strong) XHPopMenu *popMenu;
@end

@implementation SKChatConversationViewController

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

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [cell setUnreadNum:@"12"];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SKChatConversationCellTableViewCell *cell = (SKChatConversationCellTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    SKChatMessageTableViewController *msgTableViewController = [[SKChatMessageTableViewController alloc] init];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"sdafjkla;dsjfa;jfa;jdfasfasfafadsfadsfas";
    title.textAlignment = NSTextAlignmentCenter;
    title.lineBreakMode = NSLineBreakByTruncatingMiddle;
    //[title sizeToFit];
    msgTableViewController.navigationItem.titleView = title;
    //    msgTableViewController.title = @"sdafjkla;dsjfa;jfa;jdfasfasfafadsfadsfas";
    
    [self.navigationController pushViewController:msgTableViewController animated:YES];
}

@end
