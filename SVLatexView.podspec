#
# Be sure to run `pod lib lint SVLatexView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SVLatexView'
  s.version          = '1.1.3'
  s.summary          = 'Math equation rendering on iOS'
  s.description      = <<-DESC
  Math equation rendering on iOS using MathJax and WebKit
    DESC

  s.homepage         = 'https://github.com/Mazorati/SVLatexView'
  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mazorati' => 'alex@svntech.ru' }
  s.source           = { :git => 'https://github.com/Mazorati/SVLatexView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.resources = ['SVLatexView/Libs/*']
  s.source_files = 'SVLatexView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SVLatexView' => ['SVLatexView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
