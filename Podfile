inhibit_all_warnings!
use_frameworks!

link_with 'StackViewTesterTests'

source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'

pod 'PureLayout', '~> 3.0'
pod 'FBSnapshotTestCase', '~> 2.0'

bleeding_edge = false

if bleeding_edge
  pod 'OAStackView', :git => 'https://github.com/oarrabi/OAStackView.git', :branch => 'master'
  pod 'TZStackView', :git => 'https://github.com/tomvanzummeren/TZStackView.git', :branch => 'master'
  pod 'FDStackView', :git => 'https://github.com/forkingdog/FDStackView.git', :branch => 'master'
else
  pod 'OAStackView'
  pod 'TZStackView'
  # pod 'FDStackView'

  # Semantic Versioning won't pickup FDStackView (version 1.0-alpha)
  pod 'FDStackView', :git => 'https://github.com/forkingdog/FDStackView.git', :branch => 'master'
end

