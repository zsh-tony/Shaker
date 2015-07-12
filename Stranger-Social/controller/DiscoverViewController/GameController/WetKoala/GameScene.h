//
//  GameScene.h
//  Wet Koala
//

//  Copyright (c) 2014 haruair. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <Security/Security.h>

@interface GameScene : SKScene
@property (nonatomic) NSDate * startTime;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) SKTextureAtlas * atlas;
@property (nonatomic,copy)void (^next)();
@property (nonatomic,copy)void (^quit)();
@property (nonatomic,strong) void (^swtchSound)();
@end
