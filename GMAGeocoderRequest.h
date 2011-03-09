//
//  GMAGeocoderRequest.h
//  Tickets
//
//  Created by Casey Marshall on 11/10/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMARequest.h"

@interface GMAGeocoderRequest : GMARequest
{
	NSMutableData *receivedData;
	NSURLResponse *urlResponse;
}

- (id) initWithQuery: (NSString *) addressQuery;

@end
