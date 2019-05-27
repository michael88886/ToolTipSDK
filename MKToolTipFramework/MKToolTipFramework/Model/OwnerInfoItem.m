//
//  OwnerItem.m
//  ToolpitTest
//
//  Created by mk mk on 24/5/19.
//  Copyright © 2019 mk mk. All rights reserved.
//

#import "OwnerInfoItem.h"

@implementation OwnerInfoItem

// MARK: Static init
+(OwnerInfoItem *) newOwnerInfo {
	return [[self alloc] initNewOwnerInfo];
}

// MARK: Custom init
-(id) initNewOwnerInfo {
	if (self = [super init]) {
		// - Default value 
		self.ownerID = [NSNumber numberWithInteger: -1];
		self.title = @"";
		self.fName = @"";
		self.lName = @"";
		self.imgURL = @"";
	}
	return self;
}

@end
