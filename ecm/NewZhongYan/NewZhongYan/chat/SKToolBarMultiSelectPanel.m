//
//  SKToolBarMultiSelectPanel.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-7-10.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKToolBarMultiSelectPanel.h"
#import "SKMultiSelectItem.h"

@implementation SKToolBarMultiSelectPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = COLOR(247, 247, 247);
        self.autoresizingMask = UIViewAutoresizingNone;
        
        panelTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 0, 49, 235)];
        panelTableView.backgroundColor = [UIColor clearColor];
        
        panelTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        panelTableView.scrollsToTop = NO;
        panelTableView.showsVerticalScrollIndicator = NO;
        panelTableView.transform = CGAffineTransformMakeRotation(M_PI/-2);
        panelTableView.frame = CGRectMake(5, 0, 235, 49);
        
        //NSLog(@"%f,%f,%f,%f",panelTableView.frame.origin.x,panelTableView.frame.origin.y,panelTableView.frame.size.width,panelTableView.frame.size.height);
        confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmBtn setFrame:CGRectMake(245, 9, 70, 30)];
        [confirmBtn setTitle:@"确认(0)" forState:UIControlStateNormal];
        confirmBtn.enabled = NO;
        [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"MultiSelectedPanelConfirmBtnbKG"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)] forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:panelTableView];
        [self addSubview:confirmBtn];
        //self.selectedItems = [NSMutableArray array];
//        SKMultiSelectItem *item1 = [[SKMultiSelectItem alloc] init];
//        item1.cname = @"死灵法";
//        SKMultiSelectItem *item2 = [[SKMultiSelectItem alloc] init];
//        item2.cname = @"Yneroy";
//        SKMultiSelectItem *item3 = [[SKMultiSelectItem alloc] init];
//        item3.cname = @"c";
//        SKMultiSelectItem *item4 = [[SKMultiSelectItem alloc] init];
//        item4.cname = @"测试";
//        self.selectedItems = [NSMutableArray arrayWithObjects:item1, item2, item3, item4, nil];
        panelTableView.delegate = self;
        panelTableView.dataSource = self;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)updateConfirmButton
{
    int count = (int)_selectedItems.count;
    confirmBtn.enabled = count > 0;
    
    [confirmBtn setTitle:[NSString stringWithFormat:@"确认(%d)",count] forState:UIControlStateNormal];
}

#pragma mark - setter
- (void)setSelectedItems:(NSMutableArray *)selectedItems
{
    _selectedItems = selectedItems;
    
    [panelTableView reloadData];
    
    [self updateConfirmButton];
}


#pragma mark - out call
- (void)didDeleteSelectedIndex:(NSUInteger)selectedIndex
{
    [self updateConfirmButton];
    //执行删除操作
    [panelTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    
}

- (void)didAddSelectedIndex:(NSUInteger)selectedIndex
{
    //找到index
    if (selectedIndex<self.selectedItems.count) {
        [self updateConfirmButton];
        //执行插入操作
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        [panelTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [panelTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SKToolBarMultiSelectPanelTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = COLOR(247, 247, 247);
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(8.0f, 0.0f, 35.0f, 35.0f)];
        nameLabel.tag = 999;
        nameLabel.layer.cornerRadius = 4.0f;
        nameLabel.clipsToBounds = YES;
        nameLabel.contentMode = UIViewContentModeScaleAspectFill;
        nameLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
        nameLabel.frame = CGRectMake(8.0f, 0.0f, 35.0f, 58.0f);
        nameLabel.backgroundColor = COLOR(127, 189, 246);
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:nameLabel];
    }
    SKMultiSelectItem *item = self.selectedItems[indexPath.row];
    UILabel *nameLabel = (UILabel*)[cell.contentView viewWithTag:999];
    nameLabel.text = item.cname;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SKMultiSelectItem *item = self.selectedItems[indexPath.row];
    //删除某元素,实际上是告诉delegate去删除
    if (self.delegate&&[self.delegate respondsToSelector:@selector(willDeleteRowWithItem:withMultiSelectedPanel:)]) {
        [self.delegate willDeleteRowWithItem:item withMultiSelectedPanel:self];
    }
    //确定没了删掉
    if ([self.selectedItems indexOfObject:item]==NSNotFound) {
        [self updateConfirmButton];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)confirmBtnPressed {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didConfirmWithMultiSelectedPanel:)]) {
        [self.delegate didConfirmWithMultiSelectedPanel:self];
    }
}

@end
