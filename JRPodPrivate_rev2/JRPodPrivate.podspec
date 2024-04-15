#
# Be sure to run `pod lib lint JRPodPrivate.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JRPodPrivate'
  s.version          = '1.5.8'
  s.summary          = '升级图片选择器'


# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: 组件弹窗高度优化
                       DESC

  s.homepage         = 'https://gitee.com/jerrisoft2'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wni' => '578433100@qq.com' }
  s.source           = { :git => 'https://gitee.com/jerrisoft2/JRPodPrivate.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 arm64' }
  
  s.source_files = 'JRPodPrivate/Classes/**/*'
  s.resource_bundles = {
      'JRPodPrivate' => ['JRPodPrivate/Assets/*','JRPodPrivate/Third/MJRefresh/MJRefresh/*'],
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'Masonry'
   s.dependency 'MBProgressHUD','~> 1.2.0'
   s.dependency 'JKCategories', '~> 1.9'
   s.dependency 'TZImagePickerController', '~> 3.7.0'
   s.dependency 'DateTools', '~> 2.0.0'
   s.dependency 'YBImageBrowser'
   s.dependency 'YBImageBrowser/Video'
   s.dependency 'FrameAccessor'
   s.dependency 'XXNibBridge'
   s.dependency 'Masonry'
   s.dependency 'extobjc'
   s.dependency 'AGGeometryKit'
   
end
