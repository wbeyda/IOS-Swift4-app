//
//  ABCellMenuView.h
//  Test
//
//  Created by Alex Bumbu on 17/02/15.
//  Copyright (c) 2015 Alex Bumbu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+XIB.h"
#import "HCSStarRatingView.h"

@protocol ABCellMenuViewDelegate;

@interface ABCellMenuView : UIView

@property (nonatomic, assign) id<ABCellMenuViewDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) IBOutlet HCSStarRatingView *rateView;

@end


@protocol ABCellMenuViewDelegate <NSObject>

@optional
- (void)cellMenuViewMoreBtnTapped:(ABCellMenuView *)menuView;

@end
