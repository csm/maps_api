//
//  GMAResponse.h
//  Tickets
//
//  Created by Casey Marshall on 11/9/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GMAResponse : NSObject
{
	NSURLResponse *urlResponse;
	BOOL success;
}

@property (readonly) NSURLResponse *urlResponse;
@property (readonly) BOOL success;

@end
