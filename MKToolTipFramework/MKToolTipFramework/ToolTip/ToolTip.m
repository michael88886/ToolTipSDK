//
//  ToolTip.m
//  ToolpitTest
//
//  Created by mk mk on 24/5/19.
//  Copyright © 2019 mk mk. All rights reserved.
//

#import "ToolTip.h"
#import "DataItem.h"
#import "Helper.h"


@implementation ToolTip

-(void) layoutSubviews {
	[super layoutSubviews];
	// Circle user image
	self.usrImgView.layer.cornerRadius = self.usrImgView.frame.size.height / 2.0;
}

-(void) feedData:(DataItem *)data {
	// - Loading info to view
	TagItem *tag = data.tag;
	OwnerInfoItem *ownerInfo = data.owner;
	
	// ID
	self.idLabel.text = [NSString stringWithFormat:@"Data ID: %@", data.dataID];
	
	// Page / Total
	self.pagetotal.text = [NSString stringWithFormat:@"%@ / %@", data.page, data.total];
	
	// Message
	self.msgView.text = [data message];
	
	// Create time
	NSString *timeStr = [data createTime];
	timeStr = [timeStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
	timeStr = [timeStr stringByReplacingOccurrencesOfString:@"Z" withString:@""];
	self.createTime.text = timeStr;
	
	// Image
	self.imgView.image = [Helper imageFromURL: [data imgURL]];
	
	// Tags
	NSMutableString *tagText = [NSMutableString stringWithString:@"Tags: "];
	for (NSInteger i=0; i < tag.titles.count; i++) {
		NSString *tagTx = tag.titles[i];
		[tagText appendString: tagTx];
		if (tagTx == tag.titles.lastObject) {
			[tagText appendString: @"."];
		}
		else {
			[tagText appendString:@", "];
		}
	}
	self.tagTextView.text = tagText;
	
	// User title
	self.usrTitle.text = [[NSString stringWithFormat:@"%@.", [ownerInfo title]] uppercaseString];
	
	// User First / Last name
	self.usrName.text = [NSString stringWithFormat:@"%@ %@", ownerInfo.fName, ownerInfo.lName];
	
	// User ID
	self.usrIDLabel.text = [NSString stringWithFormat:@"User ID: %@", ownerInfo.ownerID];
	
	// User image
	self.usrImgView.image = [Helper imageFromURL: [ownerInfo imgURL]]; 
}

-(void) showTooltip:(DataItem *)data {
	// - Show loading container
	[self.loadingContainer setHidden: false];
	[self.spinner startAnimating];
	[self.infoContainer setHidden: true];
	
	// - Process loading at a bckground thread, improve usablity
	dispatch_async(dispatch_get_main_queue(), ^{
		// - Feed data 
		[self feedData:data];
		
		// - End loading, show infomation container
		[self.loadingContainer setHidden:true];
		[self.spinner stopAnimating];
		[self.infoContainer setHidden: false];
	});
}

@end
