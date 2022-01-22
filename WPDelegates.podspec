#
# Be sure to run `pod lib lint WPDelegates.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WPDelegates'
  s.version          = '0.3.0'
  s.summary          = '一个方便易用的多播代理工具'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/codernash/WPDelegates'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'stevepeng13' => 'stevepeng13@outlook.com' }
  s.source           = { :git => 'https://github.com/codernash/WPDelegates.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'WPDelegates/Classes/**/*'
end
