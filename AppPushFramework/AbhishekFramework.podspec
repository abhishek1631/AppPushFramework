
Pod::Spec.new do |spec|

  spec.name         = "AbhishekFramework"
  spec.version      = "5.0.0"
  spec.summary      = "Sample framework to support APNs Services PushEngage."
  spec.description  = "Provide the feature for Apple push notification."
  spec.homepage     = "https://github.com/abhishek1631/AppPushFramework.git"
  spec.license =  { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Abhishek Kumar" => "abkumar@awesomemotive.com" }
  spec.platform = :ios
  spec.ios.deployment_target  = '10.0'
  spec.requires_arc = true
  spec.source = { :git => "https://github.com/abhishek1631/AppPushFramework.git",
                  :tag => "#{spec.version}"
                }
  spec.ios.framework = "UIKit"
  spec.dependency 'SwiftKeychainWrapper'
  spec.source_files = "AppPushFramework/AbhishekFramework/**/*.swift"
  spec.swift_version = "5.0"
end
