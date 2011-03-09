//
//  GMARequest.h
//  Tickets
//
//  Created by Casey Marshall on 11/9/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMARequestDelegate.h"

// This is an abstract class that handles the basic functionality of the Google
// Maps web services API. Concrete subclasses will provide the actual
// functionality behind the various maps web services.
@interface GMARequest : NSObject
{
	NSURL *requestURL;
	NSData *clientKey;
	NSObject<GMARequestDelegate> *delegate;

	@private
	NSURLConnection *connection;
}

@property (retain) NSURL *requestURL;
@property (copy) NSData *clientKey;
@property (retain) NSObject<GMARequestDelegate> *delegate;

- (id) initWithURL: (NSURL *) url;

- (void) beginRequest;

@end
