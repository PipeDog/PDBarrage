//
//  PDCustomMacro.h
//  PDBarrage
//
//  Created by liang on 2018/2/23.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#ifndef PDCustomMacro_h
#define PDCustomMacro_h


/**
 Synthsize a dynamic object property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @param association  ASSIGN / RETAIN / COPY / RETAIN_NONATOMIC / COPY_NONATOMIC
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Example:
 @interface NSObject (MyAdd)
 @property (nonatomic, retain) UIColor *myColor;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
 PDSYNTH_DYNAMIC_PROPERTY_OBJECT(myColor, setMyColor, RETAIN, UIColor *)
 @end
 */
#ifndef PDSYNTH_DYNAMIC_PROPERTY_OBJECT
#define PDSYNTH_DYNAMIC_PROPERTY_OBJECT(_getter_, _setter_, _association_, _type_) \
- (void)_setter_ : (_type_)object { \
    [self willChangeValueForKey:@#_getter_]; \
    objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _association_); \
    [self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
    return objc_getAssociatedObject(self, @selector(_setter_:)); \
}
#endif


/**
 Synthsize a dynamic c type property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Example:
 @interface NSObject (MyAdd)
 @property (nonatomic, retain) CGPoint myPoint;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
 PDSYNTH_DYNAMIC_PROPERTY_CTYPE(myPoint, setMyPoint, CGPoint)
 @end
 */
#ifndef PDSYNTH_DYNAMIC_PROPERTY_CTYPE
#define PDSYNTH_DYNAMIC_PROPERTY_CTYPE(_getter_, _setter_, _type_) \
- (void)_setter_ : (_type_)object { \
    [self willChangeValueForKey:@#_getter_]; \
    NSValue *value = [NSValue value:&object withObjCType:@encode(_type_)]; \
    objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN); \
    [self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
    _type_ cValue = { 0 }; \
    NSValue *value = objc_getAssociatedObject(self, @selector(_setter_:)); \
    [value getValue:&cValue]; \
    return cValue; \
}
#endif


/// Remove and release the view.
#ifndef PDRelease_UIView
#define PDRelease_UIView(__ref) \
\
{ \
    if ((__ref) != nil) { \
        [__ref removeFromSuperview]; \
        __ref = nil; \
    } \
}
#endif


/// Processing of strings.
#ifndef STR_SAFE
#define STR_SAFE(_str_) /* 字符串确保不为nil */ \
([_str_ isKindOfClass:[NSString class]] ? (_str_.length > 0 ? _str_ : @"") : (@""))
#endif

#define STR_FORMAT(...) [NSString stringWithFormat:__VA_ARGS__] // 字符串拼接


/// Safe callback.
#ifndef BLOCK_EXE
#define BLOCK_EXE(blk_t, ...) \
if (blk_t) { \
    blk_t(__VA_ARGS__); \
}
#endif


/// Definition of pixel value.
#ifndef PDScreenWidth
#define PDScreenWidth ([UIScreen mainScreen].bounds.size.width)
#endif

#ifndef PDScreenHeight
#define PDScreenHeight ([UIScreen mainScreen].bounds.size.height)
#endif

#ifndef PDStatusBarHeight
#define PDStatusBarHeight (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))
#endif


#endif /* PDCustomMacro_h */
