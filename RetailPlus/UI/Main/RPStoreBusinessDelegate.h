//
//  RPStoreBusinessDelegate.h
//  RetailPlus
//
//  Created by lin dong on 13-12-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RPStoreBusinessDelegate <NSObject>
-(void)OnStoreCVisit:(StoreDetailInfo *)store;
-(void)OnStoreHandover:(StoreDetailInfo *)store;
-(void)OnStoreMaintenance:(StoreDetailInfo *)store;
-(void)OnStoreBVisit:(StoreDetailInfo *)store CacheDataId:(NSString *)strCacheDataId NeedLoadData:(BOOL)bNeedLoad;
-(void)OnStoreLogbook:(StoreDetailInfo *)store;
-(void)OnStoreKPIEntry:(StoreDetailInfo *)store;
-(void)OnLiveVideo:(StoreDetailInfo *)store;
-(void)OnEditStore:(StoreDetailInfo *)store;
-(void)OnDailyStock:(StoreDetailInfo *)store;
@end
