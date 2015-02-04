//
//  FilterViewController.h
//  Yelp
//
//  Created by Xiangnan Xu on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterViewController;
@protocol FilterViewControllerDelegate <NSObject>

- (void) filterViewController:(FilterViewController *) filterViewController didChangeFilters:(NSDictionary *) filters atIndexPath:(NSMutableArray *) selectedIndexPath withDropdownSelected:(NSMutableArray *) dropdownSelectedIndexPath;


@end

@interface FilterViewController : UIViewController
@property (weak, nonatomic) id<FilterViewControllerDelegate> delegate;
- (id)initWithFilters:(NSDictionary *) filters withSelectedIndexPath: (NSMutableArray *) selectedIndexPath withDropdownSelectedIndexPath:(NSMutableArray *) dropdownSelectedIndexPath;
@end
