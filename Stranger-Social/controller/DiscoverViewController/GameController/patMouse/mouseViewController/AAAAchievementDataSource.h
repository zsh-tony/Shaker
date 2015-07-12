//
//  AAAAchievementDataSource.h
//  Gamify
//
//  Created by Håkon Bogen on 05.03.14.
//  Copyright (c) 2014 Haaakon Bogen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAAAchievementManager.h"

extern NSString *const kForestStarAchievementKey;
extern NSString *const kPenguinAchievementKey;
@interface AAAAchievementDataSource : NSObject<AAAAchievementManagerDataSource>

@end
