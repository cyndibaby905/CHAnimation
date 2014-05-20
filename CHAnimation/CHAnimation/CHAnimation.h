//
//  CHAnimation.h
//  CHAnimation
//
//  Created by hangchen on 5/20/14.
//  Copyright (c) 2014 hangchen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CHAnimationState;

@interface CHAnimation : NSObject
{
    CHAnimationState *_state;
    
}
@property (nonatomic, assign)id obj;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) CFTimeInterval beginTime;
@property (assign, nonatomic) CFTimeInterval duration;
@property (copy, nonatomic) id fromValue;
@property (copy, nonatomic) id toValue;
@property (readwrite, nonatomic, copy) id (^readBlock)(id obj);
@property (readwrite, nonatomic, copy) void (^writeBlock)(id obj, id value);
@property (readwrite, nonatomic, copy) id (^progressBlock)(id obj, CGFloat progress);


@end

CHAnimationState *CHAnimationGetState(CHAnimation *a);

@interface NSObject (CHAnimation)


- (void)ch_addAnimation:(CHAnimation *)anim forKey:(NSString *)key;


- (void)ch_removeAllAnimations;


- (void)ch_removeAnimationForKey:(NSString *)key;


@end
