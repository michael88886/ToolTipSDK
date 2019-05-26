//
//  DataObject.h
//  ToolpitTest
//
//  Created by mk mk on 24/5/19.
//  Copyright © 2019 mk mk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagItem.h"
#import "OwnerInfoItem.h"


@interface DataItem : NSObject

@property (nonatomic) NSNumber *dataID;
@property (nonatomic, strong) NSString *imgURL;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) TagItem *tag;
@property (nonatomic, strong) OwnerInfoItem *owner; 
@property (nonatomic, strong) NSNumber *total;
@property (nonatomic, strong) NSNumber *page;

+(DataItem *) newDataWith: (NSDictionary *) json;

@end

