//
//  NSObject+CrashNilSafeKVO.m
//  NilSafeTest
//
//  Created by PC on 2021/3/18.
//  Copyright © 2021 mac. All rights reserved.
//

#import "NSObject+CrashNilSafeKVO.h"
#import <objc/runtime.h>
#import "TKCrashNilSafe.h"


@interface TKSafeKVOModel :NSObject
@property(nonatomic, copy) NSString *object;//被观察的对象
@property(nonatomic, copy) NSString *observer;
@property(nonatomic, copy) NSString *keyPath;
@property(nonatomic, assign) NSUInteger options;
@property(nonatomic, copy)   NSString *context;
@property(nonatomic, assign) BOOL isContext;//标记context是否存在
@property(nonatomic, assign) BOOL effective;//用于标记当前生成的Model是否有效
/**
 标记查询符合条件KVO对象
 0:默认状态
 1:一定是从removeObserver:forKeyPath:context:进入查询，并且符合条件的KVO对象
 */
@property(nonatomic, assign) NSInteger quearyMarkType;

@end

@implementation TKSafeKVOModel

//create
- (instancetype)initWithObject:(id)object observer:(id)observer keyPath:(NSString *)keyPath options:(NSUInteger)options context:(void *)context
{
    if (self = [super init]) {
        if (!object || !observer || !keyPath) {
            self.effective = NO;
        }else{
            self.effective = YES;
            self.object = [NSString stringWithFormat:@"%p",object];
            self.observer = [NSString stringWithFormat:@"%p",observer];
            self.keyPath = keyPath;
            self.options = options;
            self.context = [NSString stringWithFormat:@"%p",context];
            if (context) {
                self.isContext = YES;
            }else{
                self.isContext = NO;
            }
        }
    }
    return self;
}

//queary
- (instancetype)initWithQuearyObject:(id)object observer:(id)observer keyPath:(NSString *)keyPath context:(void *)context
{
    return [self initWithObject:object observer:observer keyPath:keyPath options:0x996 context:context];
}


//比较两个对象的值是否完全相等
- (BOOL)isEqualTo:(TKSafeKVOModel *)obj
{
    if (![self.object isEqualToString:obj.object]) {
        return NO;
    }
    if (![self.observer isEqualToString:obj.observer]) {
        return NO;
    }
    if (![self.keyPath isEqualToString:obj.keyPath]) {
        return NO;
    }
    if (self.options != obj.options) {
        return NO;
    }
    if (![self.context isEqualToString:obj.context]) {
        return NO;
    }
    return YES;
}


- (BOOL)compareTo:(TKSafeKVOModel *)model
{
    if (![self.object isEqualToString:model.object]) {
        return NO;
    }
    if (![self.observer isEqualToString:model.observer]) {
        return NO;
    }
    if (![self.keyPath isEqualToString:model.keyPath]) {
        return NO;
    }
    return YES;
}

//remove:InContext 时比较符合标准的对象，并标记类型
- (BOOL)isEqualTo:(TKSafeKVOModel*)obj context:(void *)context //nil-obj
{
    if (context) {
        if (!self.isContext) {
            return NO;
        }
        if (![self.context isEqualToString:obj.context]) {
            return NO;
        }
        self.quearyMarkType = 1;
    }else{
        if (self.isContext) {
            return NO;
        }
        self.quearyMarkType = 1;
    }
    return [self compareTo:obj];
}

- (NSString *)description
{
    NSDictionary *dic = @{@"object":self.object,
                          @"observer":self.observer,
                          @"keyPath":self.keyPath,
                          @"context":self.context,
                          @"options":@(self.options)
    };
    return [NSString stringWithFormat:@"\n%@\n",dic];;
}

@end

//只存储，处理有效的TKSafeKVOModel
@interface TKSafeKVOCache:NSObject
@property(nonatomic, strong) NSMutableDictionary *data; // <object:Array>
@end
@implementation TKSafeKVOCache

+ (instancetype)share
{
    static TKSafeKVOCache *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [TKSafeKVOCache new];
        obj.data = [[NSMutableDictionary alloc] initWithCapacity:8];
    });
    return obj;
}

//obj.object存的是KVO对象的地址
- (NSMutableArray *)arrayItemsWithKey:(NSString *)pointer
{
    NSString *key = pointer;
    NSMutableArray *value = self.data[key];
    if (!value) {
        value = [[NSMutableArray alloc] initWithCapacity:4];
        self.data[key] = value;
    }
    return value;
}

//add时查询是否已经有相同的KVO对象
- (BOOL)queary:(TKSafeKVOModel *)model
{
    NSArray *result = [self arrayItemsWithKey:model.object];
    for (TKSafeKVOModel *item in result) {
        if ([model isEqualTo:item]) {
            return YES;
        }
    }
    return NO;
}

- (void)addObject:(TKSafeKVOModel *)model
{
    NSMutableArray *ary = [self arrayItemsWithKey:model.object];
    [ary addObject:model];
}

- (void)removeObject:(TKSafeKVOModel *)model
{
    NSMutableArray *ary = [self arrayItemsWithKey:model.object];
    [ary removeObject:model];
}


//所有符合object,observer,keypath的KVO对象列表，不比较context的值
- (NSMutableArray *)allQuearyRemoveWith:(TKSafeKVOModel*)quearyModel
{
    NSArray *value = [self arrayItemsWithKey:quearyModel.object];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (TKSafeKVOModel *item in value) {
        if ([item compareTo:quearyModel]) {
            [array addObject:item];
        }
    }
    return array;
}


//queary
- (BOOL)quearyRemoveInContextWith:(TKSafeKVOModel *)quearyModel  context:(void *)context
{
    NSMutableArray *result = [self allQuearyRemoveWith:quearyModel];
    NSUInteger count = result.count;
    if (count>0) {
        if (context) {
            for (TKSafeKVOModel *item in result) {
                if ([item isEqualTo:quearyModel context:context]) {
                    return YES;
                }
            }
        }else{//context==nil时，会先移出后添加的KVO
            for (NSUInteger i=count; i>0; i--) {
                TKSafeKVOModel *item = result[i-1];
                if ([item isEqualTo:quearyModel context:context]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

- (TKSafeKVOModel *)quearyRemoveWith:(TKSafeKVOModel *)quearyModel
{
    TKSafeKVOModel *traget = nil;
    NSMutableArray *result = [self allQuearyRemoveWith:quearyModel];
    if (result.count>0) {
        for (TKSafeKVOModel *item in result) {
            if (item.quearyMarkType != 0) {//1
                traget = item;
                break;;
            }
        }
        //表示是从removeObserver:forKeyPath:直接进入删除的，会移出最后添加的KVO对象
        if (!traget) {
            traget = result.lastObject;
        }
    }
    return traget;
}


@end


@implementation NSObject (CrashNilSafeKVO)

+ (void)load
{
    if (TKCrashNilSafe.share.checkCrashNilSafeSwitch) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            //交换KVO添加移出函数
            [self exchangeObjMethod:@selector(addObserver:forKeyPath:options:context:) withMethod:@selector(safe_addObserver:forKeyPath:options:context:)];
            [self exchangeObjMethod:@selector(removeObserver: forKeyPath: context:) withMethod:@selector(safe_removeObserver:forKeyPath:context:)];
            [self exchangeObjMethod:@selector(removeObserver: forKeyPath:) withMethod:@selector(safe_removeObserver:forKeyPath:)];
        });
    }
}


- (void)safe_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    TKCrashSafeKVOType type = TKCrashNilSafe.share.safeKVOType;
    if (type == TKCrashSafeKVOTypeCache) {
        TKSafeKVOModel *model = [[TKSafeKVOModel alloc] initWithObject:self observer:observer keyPath:keyPath options:options context:context];
        if (model.effective) {
            //在缓存中查询是否有相同的对象
            if ([TKSafeKVOCache.share queary:model]) {
                NSString *mask = [NSString stringWithFormat:@"-[%@ addObserver:forKeyPath:options:context:] ==> KVO already exists, object:%@ keyPath:%@  context:%@",self.class,self,keyPath,context];
                [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:mask];
            }else{
                [self safe_addObserver:observer forKeyPath:keyPath options:options context:context];
                [TKSafeKVOCache.share addObject:model];
            }
        }else{
            NSString *mask = [NSString stringWithFormat:@"-[%@ addObserver:forKeyPath:options:context:] ==> Invalid KVO, object:%@ keyPath:%@  context:%@",self.class,self,keyPath,context];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:mask];
        }
    }else if (type == TKCrashSafeKVOTypeTry){
        @try {
            [self safe_addObserver:observer forKeyPath:keyPath options:options context:context];
        } @catch (NSException *exception) {
            [self handleErrorWithName:exception.name mark:exception.reason];
        } @finally {
        }
    }else{
        [self safe_addObserver:observer forKeyPath:keyPath options:options context:context];
    }
}

- (void)safe_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context
{
//    NSLog(@"data begin:%@",TKSafeKVOCache.share.data);
    TKCrashSafeKVOType type = TKCrashNilSafe.share.safeKVOType;
    if (type == TKCrashSafeKVOTypeCache) {
        TKSafeKVOModel *model = [[TKSafeKVOModel alloc] initWithQuearyObject:self observer:observer keyPath:keyPath context:context];
        if (model.effective) {
            if ([TKSafeKVOCache.share quearyRemoveInContextWith:model context:context]) {
                [self safe_removeObserver:observer forKeyPath:keyPath context:context];
            }else{
                NSString *mask = [NSString stringWithFormat:@"-[%@ removeObserver:forKeyPath:context:] ==> KVO not exist, object:%@ keyPath:%@ context:%@",self.class,self,keyPath,context];
                [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:mask];
            }
        }else{
            NSString *mask = [NSString stringWithFormat:@"-[%@ removeObserver:forKeyPath:context:] ==> Invalid KVO, object:%@ keyPath:%@ context:%@",self.class,self,keyPath,context];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:mask];
        }
    }else if (type == TKCrashSafeKVOTypeTry){
        @try {
            [self safe_removeObserver:observer forKeyPath:keyPath context:context];
        } @catch (NSException *exception) {
            [self handleErrorWithName:exception.name mark:exception.reason];
        } @finally {
            
        }
    }else{
        [self safe_removeObserver:observer forKeyPath:keyPath context:context];
    }
}

/**
 1.应该先查询incontext标记的数据
 2.再查询该数据
 */
- (void)safe_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    TKCrashSafeKVOType type = TKCrashNilSafe.share.safeKVOType;
    if (type == TKCrashSafeKVOTypeCache) {
        TKSafeKVOModel *model = [[TKSafeKVOModel alloc] initWithQuearyObject:self observer:observer keyPath:keyPath context:nil];
        if (model.effective) {
            TKSafeKVOModel *traget = [TKSafeKVOCache.share quearyRemoveWith:model];
            if (traget) {
                [self safe_removeObserver:observer forKeyPath:keyPath];
                [TKSafeKVOCache.share removeObject:traget];
            }else{
                NSString *mask = [NSString stringWithFormat:@"-[%@ removeObserver:forKeyPath:] ==> KVO not exist, object:%@ keyPath:%@",self.class,self,keyPath];
                [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:mask];
            }
        }else{
            NSString *mask = [NSString stringWithFormat:@"-[%@ removeObserver:forKeyPath:] ==> Invalid KVO, object:%@ keyPath:%@",self.class,self,keyPath];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:mask];
        }
//        NSLog(@"caches data:%@",TKSafeKVOCache.share.data);
    }else if (type == TKCrashSafeKVOTypeTry){
        @try {
            [self safe_removeObserver:observer forKeyPath:keyPath];
        } @catch (NSException *exception) {
            [self handleErrorWithName:exception.name mark:exception.reason];
        } @finally {
            
        }
    }else{
        [self safe_removeObserver:observer forKeyPath:keyPath];
    }
}




@end
