//
//  TagItem.h
//  ToolpitTest
//
//  Created by mk mk on 24/5/19.
//  Copyright © 2019 mk mk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagItem : NSObject

@property (nonatomic, strong) NSMutableArray *titles;

// - Create new TagItem object
+(TagItem *) newTag;

@end
