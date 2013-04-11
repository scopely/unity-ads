//
//  UnityAdsViewStateDefaultVideoPlayer.m
//  UnityAds
//
//  Created by Pekka Palmu on 4/4/13.
//  Copyright (c) 2013 Unity Technologies. All rights reserved.
//

#import "UnityAdsViewStateDefaultVideoPlayer.h"

#import "../UnityAdsWebView/UnityAdsWebAppController.h"
#import "../UnityAdsProperties/UnityAdsConstants.h"
#import "../UnityAdsCampaign/UnityAdsRewardItem.h"
#import "../UnityAdsProperties/UnityAdsShowOptionsParser.h"

@implementation UnityAdsViewStateDefaultVideoPlayer

- (UnityAdsViewStateType)getStateType {
  return kUnityAdsViewStateTypeVideoPlayer;
}

- (void)willBeShown {
  [super willBeShown];
  
  if ([[UnityAdsShowOptionsParser sharedInstance] noOfferScreen]) {
    [[UnityAdsWebAppController sharedInstance] sendNativeEventToWebApp:kUnityAdsNativeEventShowSpinner data:@{kUnityAdsTextKeyKey:kUnityAdsTextKeyBuffering}];
    
    [[UnityAdsCampaignManager sharedInstance] setSelectedCampaign:nil];
    
    UnityAdsCampaign *campaign = [[[UnityAdsCampaignManager sharedInstance] getViewableCampaigns] objectAtIndex:0];
    
    if (campaign != nil) {
      [[UnityAdsCampaignManager sharedInstance] setSelectedCampaign:campaign];
    }
  }
}

- (void)wasShown {
  [super wasShown];
  if (self.videoController.parentViewController == nil) {
    [[UnityAdsMainViewController sharedInstance] presentViewController:self.videoController animated:NO completion:nil];
  }
}

- (void)enterState:(NSDictionary *)options {
  UALOG_DEBUG(@"");
  [super enterState:options];
  [self showPlayerAndPlaySelectedVideo];
}

- (void)exitState:(NSDictionary *)options {
  UALOG_DEBUG(@"");
  [super exitState:options];
}

- (void)applyOptions:(NSDictionary *)options {
  [super applyOptions:options];
}


#pragma mark - Video

- (void)videoPlayerStartedPlaying {
  UALOG_DEBUG(@"");
  
  if (self.delegate != nil) {
    [self.delegate stateNotification:kUnityAdsStateActionVideoStartedPlaying];
  }
  
  [[UnityAdsWebAppController sharedInstance] sendNativeEventToWebApp:kUnityAdsNativeEventHideSpinner data:@{kUnityAdsTextKeyKey:kUnityAdsTextKeyBuffering}];

  // Set completed view for the webview right away, so we don't get flickering after videoplay from start->end
  [[UnityAdsWebAppController sharedInstance] setWebViewCurrentView:kUnityAdsWebViewViewTypeCompleted data:@{kUnityAdsWebViewAPIActionKey:kUnityAdsWebViewAPIActionVideoStartedPlaying, kUnityAdsItemKeyKey:[[UnityAdsCampaignManager sharedInstance] getCurrentRewardItem].key, kUnityAdsWebViewEventDataCampaignIdKey:[[UnityAdsCampaignManager sharedInstance] selectedCampaign].id}];
  
  if (!self.waitingToBeShown) {
    [[UnityAdsMainViewController sharedInstance] presentViewController:self.videoController animated:NO completion:nil];
  }
}

- (void)videoPlayerEncounteredError {
  UALOG_DEBUG(@"");
  [[UnityAdsWebAppController sharedInstance] sendNativeEventToWebApp:kUnityAdsNativeEventHideSpinner data:@{kUnityAdsTextKeyKey:kUnityAdsTextKeyBuffering}];
  [[UnityAdsWebAppController sharedInstance] sendNativeEventToWebApp:kUnityAdsNativeEventVideoCompleted data:@{kUnityAdsNativeEventCampaignIdKey:[[UnityAdsCampaignManager sharedInstance] selectedCampaign].id}];
  [[UnityAdsWebAppController sharedInstance] sendNativeEventToWebApp:kUnityAdsNativeEventShowError data:@{kUnityAdsTextKeyKey:kUnityAdsTextKeyVideoPlaybackError}];
  
  [self dismissVideoController];
}

- (void)videoPlayerPlaybackEnded {
  if (self.delegate != nil) {
    [self.delegate stateNotification:kUnityAdsStateActionVideoPlaybackEnded];
  }
  
  [[UnityAdsWebAppController sharedInstance] sendNativeEventToWebApp:kUnityAdsNativeEventVideoCompleted data:@{kUnityAdsNativeEventCampaignIdKey:[[UnityAdsCampaignManager sharedInstance] selectedCampaign].id}];
  [[UnityAdsMainViewController sharedInstance] changeState:kUnityAdsViewStateTypeEndScreen withOptions:nil];
}

- (void)showPlayerAndPlaySelectedVideo {
	UALOG_DEBUG(@"");
  
  if (![self canViewSelectedCampaign]) return;
  
  [[UnityAdsWebAppController sharedInstance] sendNativeEventToWebApp:kUnityAdsNativeEventShowSpinner data:@{kUnityAdsTextKeyKey:kUnityAdsTextKeyBuffering}];

  [self startVideoPlayback:true withDelegate:self];
}

@end