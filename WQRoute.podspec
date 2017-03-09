#
# Be sure to run `pod lib lint WQRoute.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WQRoute'
  s.version          = '0.1.0'
  s.summary          = 'A route framework for ios.'

  s.description      = <<-DESC
WQRoute is a route framework for iOS.
                       DESC

  s.homepage         = 'https://github.com/jayla25349/WQRoute'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jayla25349' => '253491679@qq.com' }
  s.source           = { :git => 'https://github.com/jayla25349/WQRoute.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'
  s.pod_target_xcconfig    = { 'OTHER_LDFLAGS' => '-lObjC' }

  s.source_files = 'WQRoute/Classes/**/*'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.resource_bundles = {
  #   'WQFramework' => ['WQFramework/Assets/*.png']
  # }

  s.frameworks = 'UIKit', 'Foundation'
end
