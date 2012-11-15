//
//  UnityAdsCampaignManager.h
//  UnityAdsExample
//
//  Created by Johan Halin on 5.9.2012.
//  Copyright (c) 2012 Unity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UnityAdsCampaignManager;
@class UnityAdsRewardItem;
@class UnityAdsCampaign;

@protocol UnityAdsCampaignManagerDelegate <NSObject>

@required
- (void)campaignManager:(UnityAdsCampaignManager *)campaignManager updatedWithCampaigns:(NSArray *)campaigns rewardItem:(UnityAdsRewardItem *)rewardItem gamerID:(NSString *)gamerID;
- (void)campaignManagerCampaignDataReceived;

@end

@interface UnityAdsCampaignManager : NSObject

@property (nonatomic, assign) id<UnityAdsCampaignManagerDelegate> delegate;
@property (nonatomic, strong) NSArray *campaigns;
@property (nonatomic, strong) NSDictionary *campaignData;
@property (nonatomic, strong) UnityAdsCampaign *selectedCampaign;

- (void)updateCampaigns;
- (NSURL *)getVideoURLForCampaign:(UnityAdsCampaign *)campaign;
- (void)cancelAllDownloads;
- (UnityAdsCampaign *)getCampaignWithId:(NSString *)campaignId;

+ (id)sharedInstance;

@end