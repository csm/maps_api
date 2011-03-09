//
//  GMAGeocoderResponse.h
//  Tickets
//
//  Created by Casey Marshall on 11/10/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GMAResponse.h"


@interface GMAGeocoderResponse : GMAResponse
{
	NSArray *results;
}

- (id) initWithURLResponse: (NSURLResponse *) response
				   success: (BOOL) success
				   results: (NSArray *) results;

// Returns an array of GMAGeocoderResult objects.
@property (readonly) NSArray *results;

@end
