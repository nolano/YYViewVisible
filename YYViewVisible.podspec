#
# Be sure to run `pod lib lint YYViewVisible.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YYViewVisible'
  s.version          = '0.1.0'
  s.summary          = 'A short description of YYViewVisible.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/hepburnv/YYViewVisible'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hepburnv' => 'last_yearv@163.com' }
  s.source           = { :git => 'https://github.com/hepburnv/YYViewVisible.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '9.0'

  s.source_files = 'YYViewVisible/Classes/**/*'
  
end
