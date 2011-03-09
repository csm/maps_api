//
//  GMARequest.m
//  Tickets
//
//  Created by Casey Marshall on 11/9/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import "GMARequest.h"
#import <CommonCrypto/CommonHMAC.h>
#import "NSData+Base64.h"

@interface GMARequest (private)

- (NSURL *) signURL: (NSURL *) url
			withKey: (NSData *) key;

@end

@implementation GMARequest (private)

- (NSURL *) signURL: (NSURL *) url
			withKey: (NSData *) key
{
	CCHmacContext context;
	CCHmacInit(&context, kCCHmacAlgSHA1, [key bytes], [key length]);
	NSString *path = [url path];
	NSString *query = [url query];
	// Note: omit fragment, I suppose.
	NSData *pathData = [path dataUsingEncoding: NSUTF8StringEncoding];
	char sep = '?';
	NSData *queryData = [query dataUsingEncoding: NSUTF8StringEncoding];
	CCHmacUpdate(&context, [pathData bytes], [pathData length]);
	CCHmacUpdate(&context, &sep, 1);
	CCHmacUpdate(&context, [queryData bytes], [queryData length]);
	char mac[20];
	CCHmacFinal(&context, mac);
	NSMutableString *sig = [NSMutableString stringWithString:
							[[NSData dataWithBytes: mac length: 20] base64EncodedString]];
	[sig replaceOccurrencesOfString: @"+"
						 withString: @"-"
							options: 0
							  range: NSMakeRange(0, [sig length])];
	[sig replaceOccurrencesOfString: @"/"
						 withString: @"_"
							options: 0
							  range: NSMakeRange(0, [sig length])];
	NSMutableString *urlStr = [[NSMutableString alloc] initWithString: [url absoluteString]];
	[urlStr appendString: @"&sig="];
	[urlStr appendString: sig];
	NSURL *ret = [NSURL URLWithString: urlStr];
	[urlStr release];
	return ret;
}

@end


@implementation GMARequest

@synthesize requestURL;
@synthesize delegate;

- (NSData *) clientKey
{
	return clientKey;
}

- (void) setClientKey:(NSData *) k
{
	if (clientKey != nil)
		[clientKey release];
	clientKey = nil;
	if (k != nil)
		clientKey = [[NSData alloc] initWithData: k];
}

- (id) initWithURL:(NSURL *)url
{
	if (self = [super init])
	{
		requestURL = url;
		[requestURL retain];
	}
	return self;
}

- (void) beginRequest
{
	if (connection != nil)
		[[NSException exceptionWithName: @"GMARequestAlreadyRunningException"
								 reason: @"A request is already running for this object"
							   userInfo: nil] raise];
	
	NSURL *url = requestURL;
	if (clientKey != nil)
		url = [self signURL: url withKey: clientKey];
	NSURLRequest *request = [NSURLRequest requestWithURL: url];
	connection = [[NSURLConnection alloc] initWithRequest: request
												 delegate: self];
	[connection start];
}

- (void) dealloc
{
	if (clientKey != nil)
		[clientKey release];
	if (delegate != nil)
		[delegate release];
	if (requestURL != nil)
		[requestURL release];
	[super dealloc];
}

#pragma mark NSURLConnection delegate methods

// Not handling:
// redirect responses
// authentication challenges (shouldn't be necessary).

- (void) connection: (NSURLConnection *) _connection
 didReceiveResponse: (NSURLResponse *) response
{
	NSAssert(connection == _connection, @"got unexpected connection (multiple requests at once?)");
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
	
	if ([httpResponse statusCode] >= 400)
	{
		if (delegate != nil)
			[delegate mapsRequest: self
				 didFailWithError: [NSError errorWithDomain: @"GMARequestHTTPErrorDomain"
													   code: [httpResponse statusCode]
												   userInfo: nil]];
		[connection cancel];
	}
}

// Not handling: receiving data. Subclasses must handle data.

- (void) connectionDidFinishLoading: (NSURLConnection *) _connection
{
	NSAssert(connection == _connection, @"got unexpected connection (multiple requests at once?)");
	[connection release];
	connection = nil;
}

- (void) connection: (NSURLConnection *) _connection
   didFailWithError: (NSError *) error
{
	NSAssert(connection == _connection, @"got unexpected connection (multiple requests at once?)");
	if (delegate != nil)
	{
		[delegate mapsRequest: self didFailWithError: error];
	}
	[connection release];
	connection = nil;
}

@end
