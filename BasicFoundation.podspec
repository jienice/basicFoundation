#
# Be sure to run `pod lib lint BasicFoundation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BasicFoundation'
  s.version          = '0.1.0'
  s.summary          = 'A short description of BasicFoundation.'
  s.description      = 'description'
  s.homepage         = 'https://github.com/jienice/BasicFoundation'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jienice' => 'jie.xing.personal@gmail.com' }
  s.source           = { :git => 'https://github.com/jienice/BasicFoundation.git', :tag => s.version.to_s }
  s.swift_versions = '5.0'
  s.ios.deployment_target = '11.0'

  s.source_files = 'BasicFoundation/Classes/**/*'

  s.frameworks = 'UIKit'
  # OC
  s.dependency 'DZNEmptyDataSet'
  s.dependency 'MJRefresh'
  s.dependency 'XLForm'
  # s.dependency 'MBProgressHUD'
  s.dependency 'TZImagePickerController'
  # s.dependency 'WMPageController'
  # s.dependency 'HMSegmentedControl'
  s.dependency 'SKPhotoBrowser'
  # Swift
  # s.dependency 'CollectionKit'
  # s.dependency 'RTRootNavigationController'
  # s.dependency 'SnapKit'
  s.dependency 'SwiftyJSON'
  # s.dependency 'Kingfisher'
  s.dependency 'SwiftDate'
  s.dependency 'DeviceKit'
  s.dependency 'SwifterSwift/UIKit'
  s.dependency 'SwifterSwift/Foundation'
  s.dependency 'SwifterSwift/Dispatch'
  s.dependency 'SwifterSwift/SwiftStdlib'
  s.dependency 'Swinject'
  # Rx
  s.dependency 'Moya/RxSwift'
  s.dependency 'RxDataSources'
  s.dependency 'RxSwiftExt'
  s.dependency 'RxGesture'
  s.dependency 'RxOptional'
  # s.dependency 'RxTheme'
  s.dependency 'Action'
end
