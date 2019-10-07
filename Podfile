# Uncomment the next line to define a global platform for your project
inhibit_all_warnings!
use_frameworks!

target 'Moop' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  platform :ios, '12.0'

  # Analytics
  pod 'Firebase/Core'
  pod 'Fabric'
  pod 'Crashlytics'

  pod 'SDWebImage'
  pod 'Firebase/Messaging'

  pod 'SwiftLint'
  pod 'Wormholy', :configurations => ['Debug']

  pod 'CTFeedbackSwift'
  pod 'AcknowList'

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
