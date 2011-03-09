//
//  GMARequestDelegate.h
//  Tickets
//
//  Created by Casey Marshall on 11/9/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMAResponse.h"

@class GMARequest;

@protocol GMARequestDelegate <NSObject>

- (void) mapsRequest: (GMARequest *) request
	didFailWithError: (NSError *) error;

- (void) mapsRequest: (GMARequest *) request
  didReceiveResponse: (GMAResponse *) response;

@end
