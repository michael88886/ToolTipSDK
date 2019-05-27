//
//  TagItem.m
//  ToolpitTest
//
//  Created by mk mk on 24/5/19.
//  Copyright © 2019 mk mk. All rights reserved.
//

#import "TagItem.h"

@implementation TagItem

// MARK: Static init
+(TagItem *) newTag {
	return [[self alloc] initNewTag];
}

// MARK: Custon init
-(id) initNewTag {
	if (self = [super init]){
		// - Initialing array for collecting tags
		self.titles = [NSMutableArray new];
	}
	return self;
}

@end
