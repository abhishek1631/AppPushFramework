
Pod::Spec.new do |spec|

  spec.name         = "PushFramework"
  spec.version      = "0.0.2"
  spec.summary      = "Sample framework to support APNs Services PushFramework."
  spec.description  = "Provide the feature for Apple push notification."
  spec.homepage     = "https://github.com/abhishek1631/AppPushFramework"
  spec.license =  "MIT"
  spec.author             = { "Abhishek Kumar" => "abkumar@awesomemotive.com" }
  spec.platform = :ios
  spec.ios.deployment_target  = '14.0'
  spec.requires_arc = true
  spec.source = { :git => "https://github.com/abhishek1631/AppPushFramework.git",
                  :tag => "#{spec.version}"
                }
  spec.ios.framework = "UIKit"
  spec.dependency 'SwiftKeychainWrapper'
  spec.source_files = "PushFramework/**/*.{swift}"
  spec.swift_version = "5.0"
end
