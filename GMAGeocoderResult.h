//
//  GMAGeocoderResult.h
//  Tickets
//
//  Created by Casey Marshall on 11/10/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

// A single search result.

typedef struct GMAViewport
{
	CLLocationCoordinate2D northeast;
	CLLocationCoordinate2D southwest;
} GMAViewport;

@interface GMAGeocoderResult : NSObject
{
	CLLocationCoordinate2D coordinate;
	NSString *formattedAddress;
	GMAViewport viewport;
	NSDictionary *addressDictionary;
}

// Init with a dictionary, as received from Google.
- (id) initWithDictionary: (NSDictionary *) dict;

@property (readonly) CLLocationCoordinate2D coordinate;
@property (readonly) NSString *formattedAddress;
@property (readonly) GMAViewport viewport;
@property (readonly) NSDictionary *addressDictionary;

@end
