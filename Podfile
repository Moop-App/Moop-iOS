# Uncomment the next line to define a global platform for your project
inhibit_all_warnings!
use_frameworks!

target 'Moop' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  platform :ios, '12.0'

  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Analytics'
  pod 'Firebase/AdMob'
  pod 'Fabric'
  pod 'Crashlytics'

  pod 'SDWebImage'
  pod 'SwiftyStoreKit'

  pod 'SwiftLint'
  pod 'Wormholy', :configurations => ['Debug']
  pod 'FLEX', :configurations => ['Debug']
  
  pod 'CTFeedbackSwift'
  pod 'AcknowList'
  
  pod 'FacebookSDK'
  pod 'kor45cw_Extension'

  target 'Networking' do
    inherit! :search_paths
    pod 'FTLinearActivityIndicator'
    pod 'AlamofireNetworkActivityIndicator', '~> 3.0.0-beta.3'
  end

  target 'MoopTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick'
    pod 'Nimble'
  end

end
