#import <Foundation/Foundation.h>
#import "CleverTap+AdUnit.h"

@protocol CTAdUnitDelegate <NSObject>
@required
- (void)adUnitsDidUpdate;
@end

@interface CTAdUnitController : NSObject

@property (nonatomic, assign, readonly) BOOL isInitialized;
@property (nonatomic, copy, readonly) NSArray <CleverTapAdUnit *> * _Nullable adUnits;

@property (nonatomic, weak) id<CTAdUnitDelegate> _Nullable delegate;

- (instancetype _Nullable ) init __unavailable;

// blocking, call off main thread
- (instancetype _Nullable)initWithAccountId:(NSString *_Nonnull)accountId
                                       guid:(NSString *_Nonnull)guid;

- (void)updateAdUnits:(NSArray<NSDictionary*> *_Nullable)adUnits;

@end
