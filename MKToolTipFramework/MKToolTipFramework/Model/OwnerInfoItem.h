//
//  OwnerItem.h
//  ToolpitTest
//
//  Created by mk mk on 24/5/19.
//  Copyright © 2019 mk mk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OwnerInfoItem : NSObject

@property (nonatomic, strong) NSNumber *ownerID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *fName;
@property (nonatomic, strong) NSString *lName;
@property (nonatomic, strong) NSString *imgURL;

+(OwnerInfoItem *) newOwnerInfo;

@end

