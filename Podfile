# Uncomment the next line to define a global platform for your project
inhibit_all_warnings!
use_frameworks!

target 'Moop' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  platform :ios, '13.0'

  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'

  pod 'SwiftLint'
  pod 'Wormholy', :configurations => ['Debug']
  pod 'FLEX', :configurations => ['Debug']
  
  # 광고관련 Pod
  pod 'Firebase/AdMob'
  pod 'FBAudienceNetwork'
  pod 'mopub-ios-sdk/Core'
  pod 'mopub-ios-sdk/NativeAds'
  pod 'AdFitSDK'

  target 'MoopTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick'
    pod 'Nimble'
  end

end
