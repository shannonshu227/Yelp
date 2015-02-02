//
//  SwitchCell.h
//  Yelp
//
//  Created by Xiangnan Xu on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;
@protocol SwitchCellDelegate <NSObject>

- (void)switchCell:(SwitchCell *) cell didUpdateValue:(BOOL)value;
- (void) setOn:(BOOL)on animated:(BOOL) animated;
@end


@interface SwitchCell : UITableViewCell
@property (nonatomic,weak) id<SwitchCellDelegate> delegate;
@property (nonatomic, assign) BOOL on;

@property (weak, nonatomic) IBOutlet UILabel *switchLabel;

@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end
