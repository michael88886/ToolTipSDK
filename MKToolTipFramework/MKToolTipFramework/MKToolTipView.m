//
//  MKToolTipView.m
//  MKToolTipFramework
//
//  Created by mk mk on 25/5/19.
//  Copyright © 2019 mk mk. All rights reserved.
//

#import "MKToolTipView.h"
#import "DataItem.h"
#import "TagItem.h"
#import "OwnerInfoItem.h"
#import "ToolTip.h"

@interface MKToolTipView ()
// MARK: - Private functions
-(void) requestData;
-(void) parseData: (NSData *) jsonData;
-(void) showToolTip: (DataItem *) data;

@end


@implementation MKToolTipView
// MARK: Convenience init
+(MKToolTipView *) newToolTip {
	return [[self alloc] initNewToolTip];
}

// MARK: Custom init
-(id) initNewToolTip {
	CGFloat width = [[UIScreen mainScreen] bounds].size.width;
	CGFloat height = [[UIScreen mainScreen] bounds].size.height; 
	
	if (self = [super initWithFrame: CGRectMake(0, 0, width, height)]) {
		self.backgroundColor = [UIColor colorWithWhite:0 alpha: 0.2];
		[self requestData];
	}
	return self;
}

// - Send reqeust to API for data
-(void) requestData {
	// API URL
	NSString *urlStr = @"https://dummyapi.io/api/post?limit=1";
	// Encode URL
	NSString *encodeUrlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
	// Retrive json data
	NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodeUrlStr]];
	//  No Json data found, skip parse
	if (!jsonData) {
		NSLog(@"Json data not avaliable.");
		return;
	}
	[self parseData: jsonData];
}

// - Convert data to json format
-(void) parseData: (NSData *) jsonData {
	NSError *error;
	NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error:&error];
	// Convert failed, skip
	if (!jsonObject) {
		return;
	}
	
	// Create [Data] object
	DataItem *dataItem = [DataItem newDataWith: jsonObject];	
	
	// Show tooltip view with data
	[self showToolTip: dataItem];
}

// - Show tooltip
-(void) showToolTip: (DataItem *) data {
	// Define tooltip size
	CGFloat width = [[UIScreen mainScreen] bounds].size.width * 0.9;
	CGFloat height = width * 1.4;
	
	// Load tooltip view from nib 
	NSBundle *nibBundle = [NSBundle bundleForClass:[self class]];
	ToolTip *tooltip = [nibBundle loadNibNamed:@"ToolTip" owner:self options: nil].firstObject;
	tooltip.frame = CGRectMake(0, 0, width, height);
	tooltip.center = self.center;
	[self addSubview: tooltip];
	[tooltip showTooltip: data];
}

@end
