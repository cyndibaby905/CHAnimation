//
//  CHAnimator.m
//  CHAnimation
//
//  Created by hangchen on 5/20/14.
//  Copyright (c) 2014 Hang Chen (https://github.com/cyndibaby905)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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
        kcb.retain = NULL;
        kcb.release = NULL;
        kcb.equal = pointerEqual;
        kcb.hash = pointerHash;
        
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
    
    if (!key) {
        key = [[NSUUID UUID] UUIDString];
    }
    
    NSMutableDictionary *animations = (__bridge id)CFDictionaryGetValue(_dict, (__bridge void *)obj);
    
    if (nil == animations) {
        animations = [NSMutableDictionary dictionary];
        CFDictionarySetValue(_dict, (__bridge void *)obj, (__bridge void *)animations);
    } else {
        CHAnimation *existingAnim = animations[key];
        if (existingAnim) {
            if (existingAnim == anim) {
                return;
            }
            
            [self removeAnimationForObject:obj key:key];
        }
    }
    animations[key] = anim;
    
    CHAnimatorItem *item = [CHAnimatorItem new];
    item.key = key;
    item.object = obj;
    item.animation = anim;
    [_list addObject:item];
    
    
    [self updateAnimating];
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
    [self updateAnimating];
   
}


- (void)removeAnimationForObject:(id)obj key:(NSString *)key
{
    NSMutableDictionary *animations = (__bridge id)CFDictionaryGetValue(self->_dict, (__bridge void *)obj);
    if (nil == animations)
        return;
    
    CHAnimation *anim = animations[key];
    if (nil == anim)
        return;
    
    [animations removeObjectForKey:key];
        
    
    for (NSInteger index = _list.count - 1; index >= 0; index--) {
        CHAnimatorItem *item = _list[index];
        if ([anim isEqual:item.animation]) {
            [_list removeObject:item];
        }
    }
    [self updateAnimating];
}

- (void)updateAnimating
{
    BOOL paused = (_list.count == 0);
    if (paused != _displayLink.paused) {
        _displayLink.paused = paused;
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
    for (CHAnimatorItem *item in doneAnimations) {
        [self removeAnimationForObject:item.object key:item.key];
    }
    
    

    [self updateAnimating];
    
    [CATransaction commit];
}


@end

