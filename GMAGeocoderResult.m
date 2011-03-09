//
//  GMAGeocoderResult.m
//  Tickets
//
//  Created by Casey Marshall on 11/10/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import "GMAGeocoderResult.h"

@implementation GMAGeocoderResult

@synthesize coordinate;
@synthesize formattedAddress;
@synthesize viewport;
@synthesize addressDictionary;

#define set_address_property(comp,akey,dict) do { \
	NSObject *__object__ = [comp objectForKey: @"long_name"];	\
	if (__object__ == nil)										\
		__object__ = [comp objectForKey: @"short_name"];		\
	if (__object__ != nil)										\
		[d setObject: __object__ forKey: akey];					\
} while (0)

- (id) initWithDictionary: (NSDictionary *) dict
{
	if (self = [super init])
	{
		formattedAddress = [dict objectForKey: @"formatted_address"];
		if (formattedAddress != nil)
			[formattedAddress retain];
		
		// Invalid values, initially.
		coordinate.latitude = 1000;
		coordinate.longitude = 1000;
		viewport.northeast = coordinate;
		viewport.southwest = coordinate;
		
		NSDictionary *geometry = [dict objectForKey: @"geometry"];
		if (geometry != nil)
		{
			NSDictionary *location = [geometry objectForKey: @"location"];
			coordinate = CLLocationCoordinate2DMake([[location objectForKey: @"lat"] doubleValue],
													[[location objectForKey: @"lng"] doubleValue]);
			
			NSDictionary *vport = [geometry objectForKey: @"viewport"];
			NSDictionary *vpne = [vport objectForKey: @"northeast"];
			NSDictionary *vpsw = [vport objectForKey: @"southwest"];
			
			viewport.northeast = CLLocationCoordinate2DMake([[vpne objectForKey: @"lat"] doubleValue],
															[[vpne objectForKey: @"lng"] doubleValue]);
			viewport.southwest = CLLocationCoordinate2DMake([[vpsw objectForKey: @"lat"] doubleValue],
															[[vpsw objectForKey: @"lng"] doubleValue]);
		}
		NSArray *comps = [dict objectForKey: @"address_components"];
		NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity: [dict count]];
		for (NSDictionary *comp in comps)
		{
			NSArray *types = [comp objectForKey: @"types"];
			
			// Google-side names are described here: http://code.google.com/apis/maps/documentation/geocoding/
			// iOS-side names derived from printing out a MKPlacemark that came from MKReverseGeocoder.
			//   MKPlacemark *placemark = ...;
			//   NSLog(@"addressDictionary: %@", placemark.addressDictionry);
			// Note: no analog to "CountryCode" from Google?
			// No analog to "Street" from Google?

			if ([types containsObject: @"locality"])
			{
				set_address_property(comp, @"City", d);
			}
			if ([types containsObject: @"country"])
			{
				set_address_property(comp, @"Country", d);
			}
			if ([types containsObject: @"administrative_area_level_1"])
			{
				set_address_property(comp, @"State", d);
			}
			if ([types containsObject: @"administrative_area_level_2"])
			{
				set_address_property(comp, @"SubAdministrativeArea", d);
			}
			if ([types containsObject: @"route"])
			{
				set_address_property(comp, @"Thoroughfare", d);
			}
			if ([types containsObject: @"street_number"])
			{
				set_address_property(comp, @"SubThoroughfare", d);
			}
			if ([types containsObject: @"postal_code"])
			{
				set_address_property(comp, @"ZIP", d);
			}
		}
		// FIXME -- maybe split formatted address into lines?
		if (formattedAddress != nil)
			[d setObject: [NSArray arrayWithObject: formattedAddress]
				  forKey: @"FormattedAddressLines"];
		addressDictionary = [[NSDictionary alloc] initWithDictionary: d];
	}
	return self;
}

- (void) dealloc
{
	[formattedAddress release];
	[super dealloc];
}

@end
