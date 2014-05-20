//
//  CHAnimator.m
//  CHAnimation
//
//  Created by hangchen on 5/20/14.
//  Copyright (c) 2014 hangchen. All rights reserved.
//

#import "CHAnimator.h"
#import "CHAnimation.h"
#import "CHAnimationState.h"

@interface CHAnimatorItem : NSObject
@property(nonatomic, weak)id object;
@property(nonatomic, copy)NSString *key;
@property(nonatomic)CHAnimation *animation;
@end

@implementation CHAnimatorItem



@end
    





@interface CHAnimator ()
{
    CADisplayLink *_displayLink;
    NSMutableArray *_list;
    CFMutableDictionaryRef _dict;
}
@end



@implementation CHAnimator



static Boolean pointerEqual(const void *ptr1, const void *ptr2) {
    return ptr1 == ptr2;
}

static CFHashCode pointerHash(const void *ptr) {
    return (CFHashCode)(ptr);
}

static void updateAnimating(CHAnimator *self)
{
    BOOL paused = (self->_list.count == 0);
    if (paused != self->_displayLink.paused) {
        self->_displayLink.paused = paused;
    }

}


+ (id)sharedAnimator
{
    static CHAnimator* _animator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _animator = [[CHAnimator alloc] init];
    });
    return _animator;
}

- (id)init
{
    self = [super init];
    if (self) {
    
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render)];
        _displayLink.paused = YES;
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
        
        CFDictionaryKeyCallBacks kcb = kCFTypeDictionaryKeyCallBacks;
        // weak, pointer keys
        kcb.retain = NULL;
        kcb.release = NULL;
        kcb.equal = pointerEqual;
        kcb.hash = pointerHash;
        
        // strong, object values
        CFDictionaryValueCallBacks vcb = kCFTypeDictionaryValueCallBacks;
        
        _dict = CFDictionaryCreateMutable(NULL, 10, &kcb, &vcb);
        
        _list = [[NSMutableArray alloc] initWithCapacity:10];
    
    }
    return self;
}



- (void)addAnimation:(CHAnimation *)anim forObject:(id)obj key:(NSString *)key
{
    if (!anim || !obj) {
        return;
    }
    
    // support arbitrarily many nil keys
    if (!key) {
        key = [[NSUUID UUID] UUIDString];
    }
    
    NSMutableDictionary *animations = (__bridge id)CFDictionaryGetValue(_dict, (__bridge void *)obj);
    
    // update associated animation state
    if (nil == animations) {
        animations = [NSMutableDictionary dictionary];
        CFDictionarySetValue(_dict, (__bridge void *)obj, (__bridge void *)animations);
    } else {
        // if the animation instance already exists, avoid cancelling only to restart
        CHAnimation *existingAnim = animations[key];
        if (existingAnim) {
            if (existingAnim == anim) {
                return;
            }
            
            [self removeAnimationForObject:obj key:key];
        }
    }
    animations[key] = anim;
    
    // create entry after potential removal
    CHAnimatorItem *item = [CHAnimatorItem new];
    item.key = key;
    item.object = obj;
    item.animation = anim;
    [_list addObject:item];
    
    
    // start animating if necessary
    updateAnimating(self);
}

- (void)removeAllAnimationsForObject:(id)obj
{
    NSArray *animations = [(__bridge id)CFDictionaryGetValue(_dict, (__bridge void *)obj) allValues];
    CFDictionaryRemoveValue(_dict, (__bridge void *)obj);
    
    if (0 == animations.count)
        return;
    
    for (CHAnimation* animation in animations) {
        
        for (NSInteger index = _list.count - 1; index >= 0; index--) {
            CHAnimatorItem *item = _list[index];
            if ([animation isEqual:item.animation]) {
                [_list removeObject:item];
            }
        }
    }
    updateAnimating(self);
   
}


- (void)removeAnimationForObject:(id)obj key:(NSString *)key
{
    NSMutableDictionary *animations = (__bridge id)CFDictionaryGetValue(self->_dict, (__bridge void *)obj);
    if (nil == animations)
        return;
    
    CHAnimation *anim = animations[key];
    if (nil == anim)
        return;
    
    // remove key
    [animations removeObjectForKey:key];
    
    // cleanup empty dictionaries
    if (0 == animations.count)
        CFDictionaryRemoveValue(self->_dict, (__bridge void *)obj);
    
    
    for (NSInteger index = _list.count - 1; index >= 0; index--) {
        CHAnimatorItem *item = _list[index];
        if ([anim isEqual:item.animation]) {
            [_list removeObject:item];
        }
    }

}


- (void)render
{
    CFTimeInterval time = CACurrentMediaTime();
    
    [self renderTime:time];
}

- (void)renderTime:(CFTimeInterval)time
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    NSMutableArray *doneAnimations = [NSMutableArray new];
    
    for (CHAnimatorItem *item in _list) {
        CHAnimationState *state = CHAnimationGetState(item.animation);
        
        if ([state startIfNeeded:item.animation atTime:time]) {
            [state applyAnimation:item.animation atTime:time];

            if ([state isDone]) {
               
                [doneAnimations addObject:item];
            }
        }

    }
    
    
    [_list removeObjectsInArray:doneAnimations];
    

 
    
    updateAnimating(self);
    
    [CATransaction commit];
}


@end

