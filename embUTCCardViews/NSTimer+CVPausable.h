//
//  NSTimer+CVPausable.h
//  embUTCCardViews
//
//  Created by Evan Buxton on 12/1/14.
//  Copyright (c) 2014 neoscape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (CVPausable)

- (void)pauseOrResume;
- (BOOL)isPaused;

@end
