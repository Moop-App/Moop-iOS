# Uncomment the next line to define a global platform for your project
inhibit_all_warnings!
use_frameworks!
source 'https://github.com/CocoaPods/Specs.git'

target 'Moop' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  platform :ios, '12.0'

  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'FacebookSDK'

  pod 'SDWebImage'
  pod 'SwiftyStoreKit'

  pod 'SwiftLint'
  pod 'Wormholy', :configurations => ['Debug']
  pod 'FLEX', :configurations => ['Debug']
  
  pod 'CTFeedbackSwift'
  pod 'AcknowList'
  
  pod 'kor45cw_Extension'
  
  pod 'RealmSwift'
  
  # 광고관련 Pod
  pod 'Firebase/AdMob'
  pod 'FBAudienceNetwork'
  pod 'mopub-ios-sdk'
  pod 'AdFitSDK'

  target 'Networking' do
    inherit! :search_paths
    pod 'FTLinearActivityIndicator'
    pod 'AlamofireNetworkActivityIndicator'
  end

  target 'MoopTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick'
    pod 'Nimble'
  end

end
