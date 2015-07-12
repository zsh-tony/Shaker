//
//  GameScene.m
//  Wet Koala
//
//  Created by ed on 12/02/2014.
//  Copyright (c) 2014 haruair. All rights reserved.
//

#import "WetKoalaViewController.h"
#import "GameScene.h"
//#import "HomeScene.h"
#import "CounterHandler.h"
#import "PlayerNode.h"
#import "ButtonNode.h"
#import "GuideNode.h"
#define kScore 50

static const uint32_t rainCategory     =  0x1 << 0;
static const uint32_t koalaCategory    =  0x1 << 1;

@interface GameScene()  <SKPhysicsContactDelegate>

@end

@implementation GameScene
{
    CounterHandler * _counter;
    NSArray        * _waterDroppingFrames;
    PlayerNode     * _player;
    SKSpriteNode   * _ground;
    SKSpriteNode   * _score;
    GuideNode      * _guide;
    
    int _rainCount;
    BOOL _raindrop;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        // hold raindrop first
        _raindrop = NO;
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        self.atlas = [SKTextureAtlas atlasNamed:@"sprite"];
        
        // set background
        SKSpriteNode * background = [SKSpriteNode spriteNodeWithTexture:[self.atlas textureNamed:@"background"]];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild: background];
        
        // set cloud
        SKSpriteNode * cloudDark = [SKSpriteNode spriteNodeWithTexture:[self.atlas textureNamed:@"cloud-dark"]];
        SKSpriteNode * cloudBright = [SKSpriteNode spriteNodeWithTexture:[self.atlas textureNamed:@"cloud-bright"]];
        cloudDark.anchorPoint = CGPointMake(0.5, 1.0);
        cloudBright.anchorPoint = CGPointMake(0.5, 1.0);
        cloudDark.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
        cloudBright.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
        [self addChild:cloudBright];
        [self addChild:cloudDark];
        
        
        SKAction * cloudMoveUpDown = [SKAction repeatActionForever:
                                         [SKAction sequence:@[
                                                              [SKAction moveByX:0.0 y:30.0 duration:2.5],
                                                              [SKAction moveByX:0.0 y:-30.0 duration:2.5]
                                                           ]]];
        SKAction * cloudMoveLeftRight = [SKAction repeatActionForever:
                                         [SKAction sequence:@[
                                                              [SKAction moveByX:30.0 y:0.0 duration:3.0],
                                                              [SKAction moveByX:-30.0 y:0.0 duration:3.0]
                                                           ]]];

        [cloudBright runAction:cloudMoveUpDown];
        [cloudDark   runAction:cloudMoveLeftRight];
        
        // set ground
        SKSpriteNode * ground = [SKSpriteNode spriteNodeWithTexture:[self.atlas textureNamed:@"ground"]];
        ground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) - ground.size.height / 4);
        ground.anchorPoint = CGPointMake(0.5, 0.0);
        [self addChild:ground];
        
        _ground = ground;
        
        // set Koala Player
        NSMutableArray * _koalaAnimateTextures = [[NSMutableArray alloc] init];
        
        for (int i = 1; i <= 6; i++) {
            NSString * textureName = [NSString stringWithFormat:@"koala-walk-%d", i];
            SKTexture * texture = [self.atlas textureNamed:textureName];
            [_koalaAnimateTextures addObject:texture];
        }
        
        SKTexture * koalaTexture = [self.atlas textureNamed:@"koala-stop"];
        PlayerNode * player = [[PlayerNode alloc] initWithDefaultTexture:koalaTexture andAnimateTextures:_koalaAnimateTextures];
        
        [player setEndedTexture:[self.atlas textureNamed:@"koala-wet"]];
        [player setEndedAdditionalTexture:[self.atlas textureNamed:@"wet"]];
        
        player.position = CGPointMake(CGRectGetMidX(self.frame), ground.position.y + ground.size.height + koalaTexture.size.height / 2 - 15.0);
        [player setPhysicsBodyCategoryMask:koalaCategory andContactMask:rainCategory];
        [self addChild: player];
        _player = player;
        
        // set Rain Sprite
        NSMutableArray * _rainTextures = [[NSMutableArray alloc] init];
        
        for (int i = 1; i <= 4; i++) {
            NSString * textureName = [NSString stringWithFormat:@"rain-%d", i];
            SKTexture * texture = [self.atlas textureNamed:textureName];
            [_rainTextures addObject:texture];
        }
        
        _waterDroppingFrames = [[NSArray alloc] initWithArray: _rainTextures];
        
        
        // add Guide
        GuideNode * guide = [[GuideNode alloc] initWithTitleTexture:[_atlas textureNamed:@"text-swipe"]
                                                andIndicatorTexture:[_atlas textureNamed:@"finger"]];
        guide.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [guide setMethod:^{
            [self gameStart];
        }];
        [self addChild:guide];
        
        _guide = guide;
        
        SKTexture * musicDefault = [self.atlas textureNamed:@"button-music-off"];
        SKTexture * musicTouched = [self.atlas textureNamed:@"button-music-on"];
        
        ButtonNode * musicButton = [[ButtonNode alloc] initWithDefaultTexture:musicDefault andTouchedTexture:musicTouched];
        
        
            musicButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-250);
        
        [musicButton setMethod: ^ (void) {
            if (_swtchSound) {
                _swtchSound();
            }
        }];
        
        [self addChild:musicButton];

        
        
    }
    return self;
}

-(void) gameStart {
    
    _rainCount = 0;
    
    // set count
    SKSpriteNode * score = [SKSpriteNode spriteNodeWithTexture:[_atlas textureNamed:@"score"]];
    score.position = CGPointMake(CGRectGetMidX(self.frame) , CGRectGetMidY(self.frame) * 3 / 2 +50);
    score.alpha = 0.0;
    [self addChild:score];
    
    _score = score;
    
    CounterHandler * counter = [[CounterHandler alloc] init];
    counter.position = CGPointMake(CGRectGetMidX(self.frame)+ 105, CGRectGetMidY(self.frame) * 3 / 2+50  - 18);
    counter.alpha = 0.0;
    [self addChild:counter];
    
    _counter = counter;

    [self runAction:[SKAction sequence:@[
                                         [SKAction waitForDuration:0.5],
                                         [SKAction runBlock:^{
        
        [score runAction:[SKAction fadeInWithDuration:0.3]];
        [counter runAction:[SKAction fadeInWithDuration:0.3]];
    }],
                                         [SKAction waitForDuration:0.5],
                                         [SKAction runBlock:^{
                                            _raindrop = YES;
    }]]]];
    
    [self setGameStartTime];
}

-(void) setGameStartTime {
    _startTime = [NSDate date];
}

-(void) gameOver {
    
    SKSpriteNode * gameOverText = [SKSpriteNode spriteNodeWithTexture:[_atlas textureNamed:@"text-gameover"]];
    gameOverText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) * 3 / 2);
    
    SKSpriteNode * completeBoard = [SKSpriteNode spriteNodeWithTexture:[_atlas textureNamed:@"complete"]];
    completeBoard.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    SKSpriteNode * failBoard = [SKSpriteNode spriteNodeWithTexture:[_atlas textureNamed:@"failed"]];
    failBoard.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    CGFloat buttonY = CGRectGetMidY(self.frame) / 2;
    //CGFloat smallButtonY = buttonY - homeButton.size.height;
    SKTexture * retryDefault = [_atlas textureNamed:@"retry_normal"];
    SKTexture * retryTouched = [_atlas textureNamed:@"retry_highlighted"];
    
    SKTexture * quitDefault = [_atlas textureNamed:@"quit_normal"];
    SKTexture * quitTouched = [_atlas textureNamed:@"quit_highlighted"];

    SKTexture * nextDefault = [_atlas textureNamed:@"next_normal"];
    SKTexture * nextTouched = [_atlas textureNamed:@"next_highlighted"];
    
    ButtonNode * retryButton = [[ButtonNode alloc] initWithDefaultTexture:retryDefault andTouchedTexture:retryTouched];
    //retryButton.position = CGPointMake(CGRectGetMidX(self.frame) - retryButton.size.width / 2 - 8, smallButtonY);
    retryButton.position = CGPointMake(CGRectGetMidX(self.frame) - (retryButton.size.width / 2 + 8), buttonY);
    [retryButton setMethod: ^ (void) {
        SKTransition * reveal = [SKTransition fadeWithColor:[UIColor whiteColor] duration:0.5];
        GameScene * gameScene = [[GameScene alloc] initWithSize:self.size];
        gameScene.quit= self.quit;
        gameScene.next = self.next;
        gameScene.swtchSound = self.swtchSound;
        [self.view presentScene:gameScene transition:reveal];
    } ];
    
    ButtonNode * quitButton = [[ButtonNode alloc] initWithDefaultTexture:quitDefault andTouchedTexture:quitTouched];

    quitButton.position = CGPointMake(CGRectGetMidX(self.frame) + (quitButton.size.width / 2 + 8), buttonY);

    
        [quitButton setMethod: ^ (void) {
            if (_quit) {
                _quit();
            }
        } ];
    
    ButtonNode * nextButton = [[ButtonNode alloc] initWithDefaultTexture:nextDefault andTouchedTexture:nextTouched];
    
    nextButton.position = CGPointMake(CGRectGetMidX(self.frame), buttonY);
    
    
    [nextButton setMethod: ^ (void) {
        if (_next) {
            _next();
        }
    } ];
    [self addChild:gameOverText];
    if ([_counter getNumber]>= kScore ) {
        [self addChild:completeBoard];
    }else{
        [self addChild:failBoard];
    }
    
    
    
    SKAction * buttonMove = [SKAction sequence:@[[SKAction moveToY:buttonY - 10.0 duration:0.0],
                                                 [SKAction group:@[[SKAction fadeInWithDuration:0.3], [SKAction moveToY:buttonY duration:0.5]]
                                                  ]]];
    
    
    gameOverText.alpha = 0.0;
    completeBoard.alpha = 0.0;
    failBoard.alpha = 0.0;
    [self runAction:[SKAction sequence:@[[SKAction runBlock:^{
        [gameOverText runAction:
         [SKAction sequence:@[
                              [SKAction group:@[[SKAction scaleBy:2.0 duration:0.0]]],
                              [SKAction group:@[[SKAction fadeInWithDuration:0.5],[SKAction scaleBy:0.5 duration:0.2]]]
                              ]]];
    }],
     [SKAction waitForDuration:0.2],
     [SKAction runBlock:^{
        if ([_counter getNumber]>= kScore ) {
            [completeBoard runAction:[SKAction fadeInWithDuration:0.5]];
        }else{
            [failBoard runAction:[SKAction fadeInWithDuration:0.5]];
        }
        
        
    }],
 
     [SKAction waitForDuration:0.3],
     [SKAction runBlock:^{
   
        quitButton.alpha = 0.0;
        nextButton.alpha = 0.0;
        retryButton.alpha = 0.0;
      
        if ([_counter getNumber]>= kScore ) {
            [self addChild:nextButton];
            
            [nextButton runAction:buttonMove];
        }else{
            [self addChild:quitButton];
            [self addChild:retryButton];
            [quitButton runAction:buttonMove];
            [retryButton runAction:buttonMove];
        }
      
       
     
    }]]]];

}


-(void) addRaindrop {

    SKTexture *temp = _waterDroppingFrames[0];
    SKSpriteNode * raindrop = [SKSpriteNode spriteNodeWithTexture:temp];
    int minX = raindrop.size.width / 2;
    int maxX = self.frame.size.width - raindrop.size.width / 2;

    CGFloat s = - ceil(_startTime.timeIntervalSinceNow);
    if ((s < 20 && _rainCount % 4 == 0) ||
        (s >= 20 && _rainCount % 4 == 0)) {
        int x = [_player position].x + self.frame.size.width / 2;
        minX = x - 10.0;
        maxX = x + 10.0;
    }
    
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
    
    if (actualX > self.frame.size.width - raindrop.size.width / 2) {
        actualX = self.frame.size.width - raindrop.size.width / 2;
    }else if (actualX < raindrop.size.width / 2) {
        actualX = raindrop.size.width / 2;
    }
    
    raindrop.name = @"raindrop";
    
    // set raindrop physicsbody
    raindrop.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:raindrop.size];
    raindrop.physicsBody.dynamic = YES;
    raindrop.physicsBody.categoryBitMask = rainCategory;
    raindrop.physicsBody.contactTestBitMask = koalaCategory;
    raindrop.physicsBody.collisionBitMask = 0;
    raindrop.physicsBody.usesPreciseCollisionDetection = YES;

    raindrop.position = CGPointMake(actualX, self.frame.size.height + raindrop.size.height / 2);
    
    [raindrop runAction:[SKAction repeatActionForever:
                          [SKAction animateWithTextures:_waterDroppingFrames
                                           timePerFrame:0.1f
                                                 resize:YES
                                                restore:YES]] withKey:@"rainingWaterDrop"];
    
    [self addChild:raindrop];
    
    int minDuration = 10;
    int maxDuration = 20;
    
    if(s >= 40 && _rainCount % 8 == 0){
        minDuration = 20;
        maxDuration = 30;
    }else if(s >= 20 && _rainCount % 6 == 0){
        minDuration = 20;
        maxDuration = 25;
    }
    
    int rangeDuration = maxDuration - minDuration;
    float actualDuration = ((arc4random() % rangeDuration) + minDuration) / 10;
    
    SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX, _ground.position.y + _ground.size.height)
                                    duration:actualDuration];
    SKAction * countMove = [SKAction runBlock:^{
        [_counter increse];
    }];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    
    [raindrop runAction:[SKAction sequence:@[actionMove, countMove, actionMoveDone]] withKey:@"rain"];
    _rainCount++;
}

-(void) stopAllRaindrop{
    for (SKSpriteNode * node in [self children]) {
        if ([node actionForKey:@"rain"]) {
            [node removeActionForKey:@"rain"];
        }
    }
}

-(void) didBeginContact:(SKPhysicsContact *) contact {
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }else{
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & rainCategory) != 0 &&
        (secondBody.categoryBitMask & koalaCategory) != 0) {
        [self player:(SKSpriteNode *) secondBody.node didCollideWithRaindrop:(SKSpriteNode *)firstBody.node];
    }
}

-(void) player:(SKSpriteNode *)playerNode didCollideWithRaindrop:(SKSpriteNode *)raindropNode {
    if (_player.isLive) {
        
        [_player ended];
        [self stopAllRaindrop];
        
        [raindropNode runAction:[SKAction fadeOutWithDuration:0.3]];
        
        [_counter runAction:[SKAction fadeOutWithDuration:0.3]];
        [_score runAction:[SKAction fadeOutWithDuration:0.3]];
        
        [self runAction:
         [SKAction sequence:@[
                              [SKAction waitForDuration:1.0],
                              [SKAction runBlock:^{
                                 // call gameover screen
                                 [self gameOver];
                              }],
          ]]];

    }
}

-(CGFloat) getFireTime {
    CGFloat s = - ceil(_startTime.timeIntervalSinceNow);
    CGFloat fireTime = 1.0;
    if (s < 15) {
        fireTime = (25 - s) * 0.02;
    }else {
        fireTime = 0.2;
    }
    return fireTime;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [ButtonNode doButtonsActionEnded:self touches:touches withEvent:event];
    [_player touchesEnded:touches withEvent:event];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [_player touchesMoved:touches withEvent:event];
    [_guide touchesMoved:touches withEvent:event];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [ButtonNode doButtonsActionBegan:self touches:touches withEvent:event];
    [_player touchesBegan:touches withEvent:event];
}

-(void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    if(_player.isLive && _raindrop){
        self.lastSpawnTimeInterval += timeSinceLast;
        if(self.lastSpawnTimeInterval > [self getFireTime]){
            self.lastSpawnTimeInterval = 0;
            [self addRaindrop];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1.0) {
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }

    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    [_player update:currentTime];
}

@end
