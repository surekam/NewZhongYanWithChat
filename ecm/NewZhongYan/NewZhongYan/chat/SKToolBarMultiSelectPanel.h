//
//  SKToolBarMultiSelectPanel.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-7-10.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKMultiSelectItem;
@class SKToolBarMultiSelectPanel;

@protocol SKToolBarMultiSelectPanelDelegate <NSObject>

- (void)willDeleteRowWithItem:(SKMultiSelectItem *)item withMultiSelectedPanel:(SKToolBarMultiSelectPanel* )multiSelectedPanel;
- (void)didConfirmWithMultiSelectedPanel:(SKToolBarMultiSelectPanel *)multiSelectedPanel;

@end

@interface SKToolBarMultiSelectPanel : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *panelTableView;
    UIButton *confirmBtn;
}

@property (nonatomic, strong) NSMutableArray *selectedItems;
@property (nonatomic, weak) id<SKToolBarMultiSelectPanelDelegate> delegate;

//数组有变化之后需要主动激活
- (void)didDeleteSelectedIndex:(NSUInteger)selectedIndex;
- (void)didAddSelectedIndex:(NSUInteger)selectedIndex;

@end
