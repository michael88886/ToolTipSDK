//
//  MKToolTipFrameworkTests.m
//  MKToolTipFrameworkTests
//
//  Created by mk mk on 25/5/19.
//  Copyright © 2019 mk mk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "DataItem.h"
#import "TagItem.h"
#import "OwnerInfoItem.h"
#import "ToolTip.h"
#import "Helper.h"

@interface MKToolTipFrameworkTests : XCTestCase

@end

@implementation MKToolTipFrameworkTests

- (void)setUp {
	[super setUp];
}

- (void)tearDown {
	[super tearDown];
}

// Test connect to server
-(void) testConnection {
    // Given
    NSURL *url = [NSURL URLWithString:@"https://dummyapi.io/api/post?limit=1"];
    XCTestExpectation *expectataion = [self expectationWithDescription: @"Test connection"];
    __block NSUInteger statusCode = -1;
    __block NSError *fetchError = nil;
    
    // When
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url
                                        completionHandler:^(NSData *data, NSURLResponse * response, NSError *error) {
                                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                            statusCode = httpResponse.statusCode;
                                            fetchError = error;
                                            [expectataion fulfill];
                                        }];
    [task resume];
    [self waitForExpectations:[NSArray arrayWithObjects:expectataion, nil] timeout:10];
    
    // Then
    XCTAssertNil(fetchError);
    XCTAssertEqual(statusCode, 200);
}

// Test convert raw data to json format 
-(void) testConvertDataToJsonFormat {
	XCTestExpectation *expectataion = [self expectationWithDescription: @"Test PASSED: Get JSON data from API"];
	// Given
	NSBundle *bundle = [NSBundle bundleForClass: [self class]];
	NSURL *path = [bundle URLForResource: @"data" withExtension: @"json"];
	NSData *jsonData = [NSData dataWithContentsOfURL: path];
	XCTAssertNotNil(jsonData);
	
	// When
	NSError *error;
	NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error:&error];
	XCTAssertNotNil(jsonObject);
	
	// Then
	[expectataion fulfill];
	
	[self waitForExpectations: [NSArray arrayWithObject: expectataion]  
					  timeout:5];
}

// Test JSON parsing
-(void) testJSONParsing {
	// Given
	NSBundle *bundle = [NSBundle bundleForClass: [self class]];
	NSURL *path = [bundle URLForResource: @"data" withExtension: @"json"];
	NSData *jsonData = [NSData dataWithContentsOfURL: path];
	XCTAssertNotNil(jsonData);
	
	NSError *error;
	NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error:&error];
	XCTAssertNotNil(jsonObject);
	
	// When
	DataItem *dataObject = [DataItem newDataWith:jsonObject];
	
	// Then
	XCTAssertEqual(dataObject.total, jsonObject[@"total"], "Match [Total]");
	XCTAssertEqual(dataObject.page, jsonObject[@"page"], "Match [Page]");
	
	NSArray *topNode = [jsonObject objectForKey:@"data"];
	XCTAssertEqual(dataObject.dataID, topNode.firstObject[@"id"], "Match [Id]");
	XCTAssertEqual(dataObject.imgURL, topNode.firstObject[@"image"], "Match [image]");
	XCTAssertEqual(dataObject.message, topNode.firstObject[@"message"], "Match [message]");
	XCTAssertEqual(dataObject.createTime, topNode.firstObject[@"createdAt"], "Match [CreateAt]");
	
	XCTAssertNotNil(topNode.firstObject[@"tags"]);
	NSArray *tags = topNode.firstObject[@"tags"];
	TagItem * tagItem = dataObject.tag;
	XCTAssertEqual(tagItem.titles.count, 3, "Check tags item count");
	for (NSInteger i=0; i < [tags count]; i++) {
		NSDictionary *tag = [tags objectAtIndex:i];
		NSString *title = [tag objectForKey:@"title"];
		XCTAssertEqual(tagItem.titles[i], title, "Match [Title] ");
	}
	
	XCTAssertNotNil(topNode.firstObject[@"owner"]);
	NSDictionary *owner = topNode.firstObject[@"owner"];
	OwnerInfoItem *ownerInfo = dataObject.owner;
	XCTAssertEqual(ownerInfo.ownerID, owner[@"id"]);
	XCTAssertEqual(ownerInfo.title, owner[@"nameTitle"]);
	XCTAssertEqual(ownerInfo.fName, owner[@"firstName"]);
	XCTAssertEqual(ownerInfo.lName, owner[@"lastName"]);
	XCTAssertEqual(ownerInfo.imgURL, owner[@"image"]);
}

-(void) testDisplayInfo {
	// Given
	NSBundle *bundle = [NSBundle bundleForClass: [self class]];
	NSURL *path = [bundle URLForResource: @"data" withExtension: @"json"];
	NSData *jsonData = [NSData dataWithContentsOfURL: path];
	XCTAssertNotNil(jsonData);
	
	NSError *error;
	NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error:&error];
	XCTAssertNotNil(jsonObject);
	
	DataItem *dataObject = [DataItem newDataWith:jsonObject];
	XCTAssertNotNil(dataObject);
	
	// When
	ToolTip *tooltip = [[NSBundle bundleForClass: [ToolTip class]] loadNibNamed:@"ToolTip" owner:self options: nil].firstObject;
	[tooltip feedData: dataObject];
	NSLog(@"Test: %@", tooltip.usrName.text);
	
	// Then
	NSString *dispID = [NSString stringWithFormat:@"Data ID: %@", dataObject.dataID];
	XCTAssertEqualObjects(tooltip.idLabel.text, dispID, "Test display <id>");
	
	NSString *disppgTot = [NSString stringWithFormat:@"%@ / %@", dataObject.page, dataObject.total];
	XCTAssertEqualObjects(tooltip.pagetotal.text, disppgTot, "Test display <page / total>");
	
	XCTAssertEqualObjects(tooltip.msgView.text, dataObject.message, "Test display <message>");
	
	NSString *dispTime = [dataObject createTime];
	dispTime = [dispTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
	dispTime = [dispTime stringByReplacingOccurrencesOfString:@"Z" withString:@""];
	XCTAssertEqualObjects(tooltip.createTime.text, dispTime, "Test display <create time>");
	
	UIImage *dataImg = [Helper imageFromURL: [dataObject imgURL]];
	XCTAssertNotNil(dataImg);
	XCTAssertNotNil(tooltip.imgView.image);
	NSData *tooltipImgData = UIImagePNGRepresentation(tooltip.imgView.image);
	NSData *objImgData = UIImagePNGRepresentation(dataImg);
	XCTAssertEqualObjects(tooltipImgData, objImgData, "Test display <image>");
	
	NSMutableString *tagText = [NSMutableString stringWithString:@"Tags: "];
	TagItem *tag = dataObject.tag;
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
	XCTAssertEqualObjects(tooltip.tagTextView.text, tagText, "Test display <tags>");
	
	OwnerInfoItem *ownerInfo = dataObject.owner;
	XCTAssertNotEqual(ownerInfo.ownerID, [NSNumber numberWithInteger: -1]);
	NSString *usrID = [NSString stringWithFormat:@"User ID: %@", ownerInfo.ownerID];
	XCTAssertEqualObjects(tooltip.usrIDLabel.text, usrID, "Test display <user id>");
	
	NSString *usrTitle = [[NSString stringWithFormat:@"%@.", [ownerInfo title]] uppercaseString];
	XCTAssertEqualObjects(tooltip.usrTitle.text, usrTitle, "Test display <user title>");
	
	NSString *usrname = [NSString stringWithFormat:@"%@ %@", ownerInfo.fName, ownerInfo.lName];
	XCTAssertEqualObjects(tooltip.usrName.text, usrname, "Test display <user name>");
	
	UIImage *usrImg = [Helper imageFromURL: [ownerInfo imgURL]];
	XCTAssertNotNil(usrImg);
	XCTAssertNotNil(tooltip.usrImgView.image);
	NSData *tooltipUsrImgData = UIImagePNGRepresentation(tooltip.usrImgView.image);
	NSData *ownerImgData = UIImagePNGRepresentation(usrImg);
	XCTAssertEqualObjects(tooltipUsrImgData, ownerImgData, "Test display <user image>");
	}

@end
