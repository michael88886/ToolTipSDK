//
//  Helper.m
//  MKToolTipFramework
//
//  Created by mk mk on 26/5/19.
//  Copyright © 2019 mk mk. All rights reserved.
//

#import "Helper.h"


@implementation Helper

// - Convenience method to get image for URL
+(UIImage *) imageFromURL:(NSString *)url {
	// Image data
	NSData *imgData = [NSData dataWithContentsOfURL: [NSURL URLWithString: url]];
	return [UIImage imageWithData:imgData];
}

@end
