//
//  ToolTip.h
//  ToolpitTest
//
//  Created by mk mk on 24/5/19.
//  Copyright © 2019 mk mk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataItem;

// MARK: - ToolTip View class
@interface ToolTip : UIView
// - IBOutlets
@property (nonatomic, weak) IBOutlet UIView *loadingContainer;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, weak) IBOutlet UIView *infoContainer;
@property (nonatomic, weak) IBOutlet UIImageView *usrImgView;
@property (nonatomic, weak) IBOutlet UILabel *usrTitle;
@property (nonatomic, weak) IBOutlet UILabel *usrName;
@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@property (nonatomic, weak) IBOutlet UITextView *msgView;
@property (nonatomic, weak) IBOutlet UILabel *createTime;
@property (nonatomic, weak) IBOutlet UILabel *idLabel;
@property (nonatomic, weak) IBOutlet UITextView *tagTextView;
@property (nonatomic, weak) IBOutlet UILabel *pagetotal;

// - Declare functions
-(void) showTooltip: (DataItem *) data;

@end
