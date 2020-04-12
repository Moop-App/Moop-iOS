//
//  CaulyAdSetting.h
//  Cauly
//
//  Created by Neil Kwon on 9/2/15.
//  Copyright (c) 2015 Cauly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Cauly.h"

@interface CaulyAdSetting : NSObject{
    NSArray* serverSettings;
}

+ (CaulyAdSetting *)adSettingWithAppCode:(NSString *)appCode;
+ (CaulyAdSetting *)globalSetting;
+ (void)setLogLevel:(CaulyLogLevel)logLevel;
+ (void)setApplicationState:(BOOL)isBackground;

- (id)initWithAppCode:(NSString *)appCode;
- (id)initWitAdSetting:(CaulyAdSetting *)adSetting;
- (BOOL)isTestAppCode;


@property (nonatomic, strong) NSString * appCode;

@property (nonatomic) CaulyGender gender;
@property (nonatomic) CaulyAge age;
@property (nonatomic) CaulyReloadTime reloadTime;
@property (nonatomic) CaulyAdSize adSize;
@property (nonatomic) CaulyAnim animType;
@property (nonatomic) BOOL useDynamicReloadTime;
@property (nonatomic) BOOL closeOnLanding;

@end
