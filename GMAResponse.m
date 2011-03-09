//
//  GMAResponse.m
//  Tickets
//
//  Created by Casey Marshall on 11/9/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import "GMAResponse.h"


@implementation GMAResponse

@synthesize urlResponse;
@synthesize success;

- (void) dealloc
{
	[urlResponse release];
	[super dealloc];
}

@end
