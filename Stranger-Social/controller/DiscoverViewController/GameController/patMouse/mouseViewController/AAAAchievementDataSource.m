//
//  AAAAchievementDataSource.m
//  Gamify
//
//  Created by Håkon Bogen on 05.03.14.
//  Copyright (c) 2014 Haaakon Bogen. All rights reserved.
//

#import "AAAAchievementDataSource.h"
NSString *const kForestStarAchievementKey = @"forestStar";
NSString *const kPenguinAchievementKey = @"penguin";
@implementation AAAAchievementDataSource

- (AAAAchievement *)achievementForKey:(NSString *)key
{
    if ([key isEqualToString:kForestStarAchievementKey]) {
        AAAAchievement *achievement = [[AAAAchievement alloc] initWithTitleText:NSLocalizedString(@"Forest star", @"") descriptionText:NSLocalizedString(@"All forest star questions mastered. Congratulations", @"") image:[UIImage imageNamed:@"forest"]];
        return achievement;
    } else if ([key isEqualToString:kPenguinAchievementKey]) {
        AAAAchievement *achievement = [[AAAAchievement alloc] initWithTitleText:NSLocalizedString(@"Blue penguin", @"") descriptionText:NSLocalizedString(@"You got all penguin related questions correct.", @"") image:[UIImage imageNamed:@"penguin"]];
        return achievement;
    } else if ([key isEqualToString:kPenguinAchievementKey]) {
        
    }
    return nil;
}

@end
