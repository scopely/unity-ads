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
//- (void)campaignManager:(UnityAdsCampaignManager *)campaignManager campaignData:(NSDictionary *)data;
- (void)campaignManagerCampaignDataReceived;

@end

@interface UnityAdsCampaignManager : NSObject

@property (nonatomic, assign) id<UnityAdsCampaignManagerDelegate> delegate;
//@property (nonatomic, strong) NSString *queryString;
@property (nonatomic, strong) NSArray *campaigns;
@property (nonatomic, strong) NSDictionary *campaignData;
@property (nonatomic, strong) UnityAdsCampaign *selectedCampaign;
//@property (nonatomic, strong) id campaignData;

- (void)updateCampaigns;
- (NSURL *)videoURLForCampaign:(UnityAdsCampaign *)campaign;
- (void)cancelAllDownloads;
- (UnityAdsCampaign *)getCampaignWithId:(NSString *)campaignId;

+ (id)sharedInstance;

@end
