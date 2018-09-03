
Pod::Spec.new do |s|

  s.name             = 'FlexBoxKit'
  s.version          = '0.0.1'
  s.summary          = 'iOS Flexbox layout Kit'

  s.description      = <<-DESC
                        iOS Flexbox layout Kit.
                       DESC

  s.homepage         = 'https://github.com/carlSQ/FlexBoxLayout'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = 'Master'
  s.source           = { :git => 'https://github.com/carlSQ/FlexBoxLayout.git', :tag => s.version.to_s }

  s.platform              = :ios
  s.ios.deployment_target = '8.0'
  s.ios.frameworks        = 'UIKit'
  s.source_files          = 'FlexBoxKit/Source/*.{h,m,swift}'

  s.dependency 'Yoga', '~> 1.8'

  s.public_header_files = 'YogaKit/Source/{FBKLayout,UIView+FBKit}.h'
  s.private_header_files = 'YogaKit/Source/FBKLayout+Private.h'

end
