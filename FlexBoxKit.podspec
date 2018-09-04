
Pod::Spec.new do |s|

  s.name             = 'FlexBoxKit'
  s.version          = '0.1.1'
  s.summary          = 'iOS Flexbox layout Kit'

  s.description      = <<-DESC
                        iOS Flexbox layout Kit.
                       DESC

  s.homepage         = 'https://github.com/fengshanjian/FlexBoxKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = 'will'
  s.source           = { :git => 'https://github.com/fengshanjian/FlexBoxKit.git', :tag => s.version.to_s }

  s.platform              = :ios
  s.ios.deployment_target = '8.0'
  s.ios.frameworks        = 'UIKit'
  s.source_files          = 'FlexBoxKit/Source/*.{h,m,swift}'

  s.dependency 'Yoga', '~> 1.8'


end
