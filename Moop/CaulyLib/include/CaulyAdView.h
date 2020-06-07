//
//  CaulyAdView.h
//  Cauly
//
//  Created by Neil Kwon on 9/2/15.
//  Copyright (c) 2015 Cauly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaulyAdSetting.h"

@class CaulyAdView;

// Cauly 광고 이벤트 Delegate
@protocol CaulyAdViewDelegate <NSObject>

@optional

// 광고 정보 수신 성공
- (void)didReceiveAd:(CaulyAdView *)adView isChargeableAd:(BOOL)isChargeableAd;

// 광고 정보 수신 실패
- (void)didFailToReceiveAd:(CaulyAdView *)adView errorCode:(int)errorCode errorMsg:(NSString *)errorMsg;

// 랜딩 화면 표시
- (void)willShowLandingView:(CaulyAdView *)adView;

// 랜딩 화면이 닫혔을 때
- (void)didCloseLandingView:(CaulyAdView *)adView;

@end

@interface CaulyAdView : UIView

+ (id)caulyAdViewWithController:(UIViewController *)controller;
- (id)initWithParentViewController:(UIViewController *)controller;

- (void)startBannerAdRequest;
- (void)stopAdRequest;
- (void) didOrientationChanged:(UIInterfaceOrientation) orientation;

@property (nonatomic, weak) UIViewController * parentController;
@property (nonatomic) BOOL showPreExpandableAd;

@property (nonatomic, weak) id<CaulyAdViewDelegate> delegate;
@property (nonatomic, strong) CaulyAdSetting * localSetting;
@property (nonatomic, strong) NSObject * data;

@property (nonatomic, readonly) NSString * errorMsg;





@end
