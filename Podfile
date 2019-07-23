# Uncomment the next line to define a global platform for your project
inhibit_all_warnings!
use_frameworks!

target 'Moop' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  platform :ios, '11.0'

  # Analytics
  pod 'Firebase/Core'
  pod 'Fabric'
  pod 'Crashlytics'

  pod 'FTLinearActivityIndicator'
  pod 'AlamofireNetworkActivityIndicator', '~> 3.0.0-beta.3'

  pod 'SDWebImage'
  pod 'Firebase/Messaging'

  pod 'SwiftLint'
  pod 'Peek', :configuration => ['Debug']
  pod 'Wormholy', :configurations => ['Debug']

  pod 'CTFeedbackSwift'
  pod 'AcknowList'

  target 'MoopTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick'
    pod 'Nimble'
  end

end
