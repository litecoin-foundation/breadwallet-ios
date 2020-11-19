# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
workspace 'loafwallet.xcworkspace'
project 'loafwallet.xcodeproj', 'Debug' => :debug,'Release' => :release
use_frameworks!
platform :ios, '13.0'

#Shared Cocopods
def shared_pods

  pod 'Firebase/Crashlytics' 
  pod 'Firebase/Analytics'
  pod 'UnstoppableDomainsResolution', '~> 0.1.6'
  # add after v2.9.0 pod 'SwiftLint'
end

target 'loafwallet' do
  shared_pods
  
  target 'loafwalletTests' do
    inherit! :search_paths
  end
  
end
