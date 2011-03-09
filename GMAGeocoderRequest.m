//
//  GMAGeocoderRequest.m
//  Tickets
//
//  Created by Casey Marshall on 11/10/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import "GMAGeocoderRequest.h"
#import "GMAGeocoderResponse.h"
#import "GMAGeocoderResult.h"
#import "CJSONDeserializer.h"

#define GMAGeocoderBaseURL @"http://maps.googleapis.com/maps/api/geocode/json"

@implementation GMAGeocoderRequest

- (id) initWithQuery:(NSString *)addressQuery
{
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"%@?address=%@&sensor=false",
										GMAGeocoderBaseURL,
										[addressQuery stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]];
	if (self = [super initWithURL: url])
	{
		// ...
	}
	return self;
}

- (void) beginRequest
{
	if (receivedData != nil)
		[receivedData release];
	receivedData = [[NSMutableData alloc] initWithCapacity: 32];
	[super beginRequest];
}

- (void) dealloc
{
	if (receivedData != nil)
		[receivedData release];
	if (urlResponse != nil)
		[urlResponse release];
	[super dealloc];
}

#pragma mark NSURLConnection delegate methods

- (void) connection: (NSURLConnection *) conn
 didReceiveResponse: (NSURLResponse *) response
{
	if (urlResponse != nil)
		[urlResponse release];
	urlResponse = [response retain];
	[super connection: conn didReceiveResponse: response];
}

- (void) connection: (NSURLConnection *) conn
	 didReceiveData: (NSData *) data
{
#if DEBUG
	NSLog(@"did receive data...");
#endif
	[receivedData appendData: data];
}

- (void) connectionDidFinishLoading: (NSURLConnection *) _connection
{
	NSError *error = nil;
	CJSONDeserializer *deserial = [CJSONDeserializer deserializer];
	NSDictionary *reply = [deserial deserializeAsDictionary: receivedData
													  error: &error];

#if DEBUG
	NSLog(@"got deserialized response: %@, error: %@", reply, error);
#endif
	
	if (reply == nil || error != nil)
	{
		if (delegate != nil)
		{
			[delegate mapsRequest: self didFailWithError: error];
		}
		[super connectionDidFinishLoading: _connection];
		return;
	}
	
	BOOL success = [@"OK" isEqual: [reply objectForKey: @"status"]];
	
	NSArray *results = [reply objectForKey: @"results"];
	NSMutableArray *geoResults = [NSMutableArray arrayWithCapacity: [results count]];
	
	for (NSDictionary *result in results)
	{
		GMAGeocoderResult *r = [[GMAGeocoderResult alloc] initWithDictionary: result];
		[geoResults addObject: r];
		[r release];
	}
	
	GMAGeocoderResponse *response = [[GMAGeocoderResponse alloc] initWithURLResponse: nil // ?
																			 success: success
																			 results: geoResults];
	if (delegate != nil)
	{
		[delegate mapsRequest: self
		   didReceiveResponse: response];
	}
	
	[super connectionDidFinishLoading: _connection];
}

@end
