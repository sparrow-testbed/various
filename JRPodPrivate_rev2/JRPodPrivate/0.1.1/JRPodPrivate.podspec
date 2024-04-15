#
# Be sure to run `pod lib lint JRPodPrivate.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JRPodPrivate'
  s.version          = '0.1.1'
  s.summary          = 'UIButton组件完成'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: UIButton组件完成 提交一次小版本.
                       DESC

  s.homepage         = 'https://gitee.com/jerrisoft2'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wni' => '578433100@qq.com' }
  s.source           = { :git => 'https://gitee.com/jerrisoft2/JRPodPrivate.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'JRPodPrivate/Classes/**/*'
  s.resource_bundles = {
      'JRPodPrivate' => ['JRPodPrivate/Assets/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'Masonry','~> 1.0.2'
   s.dependency 'MBProgressHUD','~> 1.2.0'
   s.dependency 'JKCategories', '~> 1.9'

end
