//
//  GMAGeocoderResponse.m
//  Tickets
//
//  Created by Casey Marshall on 11/10/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import "GMAGeocoderResponse.h"


@implementation GMAGeocoderResponse

@synthesize results;

- (id) initWithURLResponse: (NSURLResponse *) _response
				   success: (BOOL) _success
				   results: (NSArray *) _results
{
	if (self = [super init])
	{
		urlResponse = _response;
		[urlResponse retain];
		success = _success;
		results = [[NSArray alloc] initWithArray: _results];
	}
	return self;
}

- (void) dealloc
{
	[results release];
	[super dealloc];
}

@end
