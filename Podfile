platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings! # supresses pods project warnings

def common
  pod 'RxCocoa', '~>6.0'
  pod 'EnumKit'
end

target 'RxEnumKit' do common end
target 'RxEnumKitTests' do
  common
  pod 'RxTest', '~>6.0.0'
end

