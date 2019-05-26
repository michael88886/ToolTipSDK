//
//  DataObject.m
//  ToolpitTest
//
//  Created by mk mk on 24/5/19.
//  Copyright © 2019 mk mk. All rights reserved.
//

#import "DataItem.h"

@interface DataItem ()
// MARK: - Private functions
-(void) loadData: (NSDictionary *) data;

@end



@implementation DataItem

// MARK: - Static init
+(DataItem *) newDataWith: (NSDictionary *) json{
	return [[self alloc] initWithJson: json];
}

// Custom initialier
-(id) initWithJson: (NSDictionary *) json {
	if (self = [super init]) {
		[self loadData: json];		
	}
	return self;
}

// Load json data
-(void) loadData: (NSDictionary *) data {
	// Fetch limit
	NSInteger limit = [[data objectForKey:@"limit"] integerValue];

	self.total = [data objectForKey:@"total"];
	self.page = [data objectForKey:@"page"];
	
	// Top level
	NSArray *topNode = [data objectForKey:@"data"];
	NSInteger i = 0;
	while (i < limit) {
		// Item in [Data] array
		NSDictionary *item = [topNode objectAtIndex:i];
		self.dataID = [item objectForKey:@"id"];
		self.imgURL = [item objectForKey:@"image"];
		self.message = [item objectForKey:@"message"];
		self.createTime = [item objectForKey:@"createdAt"];
		
		// Tag
		NSArray *tag = [item objectForKey:@"tags"];
		if (tag != nil && 
			tag.count > 0) {
			self.tag = [TagItem newTag];
			// Collecting [Tag] array data
			for (NSInteger j=0; j < [tag count]; j++) {
				NSDictionary *tagItem = [tag objectAtIndex:j];
				NSString *title = [tagItem objectForKey:@"title"];
				[self.tag.titles addObject:title];
			}
		}
		
		// Owner
		NSDictionary *owner = [item objectForKey:@"owner"];
		if (owner != nil) {
			self.owner = [OwnerInfoItem newOwnerInfo];
			self.owner.ownerID = [owner objectForKey:@"id"];
			self.owner.title = [owner objectForKey:@"nameTitle"];
			self.owner.fName = [owner objectForKey:@"firstName"];
			self.owner.lName = [owner objectForKey:@"lastName"];
			self.owner.imgURL = [owner objectForKey:@"image"];
		}
		i++;
	}
}

@end
