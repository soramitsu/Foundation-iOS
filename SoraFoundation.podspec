#
# Be sure to run `pod lib lint SoraFoundation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SoraFoundation'
  s.version          = '0.1.0'
  s.summary          = 'Implementation of commonly used algorithms to avoid boilerplate code.'

  s.description      = 'Library contains implementation of commonly used algorithms to reduce duplicated and boilerplate code.'

  s.homepage         = 'https://github.com/soramitsu'
  s.license          = { :type => 'GPL 3.0', :file => 'LICENSE' }
  s.author           = { 'ERussel' => 'emkil.russel@gmail.com' }
  s.source           = { :git => 'https://github.com/soramitsu/Foundation-iOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.swift_version = '5.0'

  s.subspec 'Localization' do |lc|
      lc.dependency 'SoraKeystore'
      lc.source_files = 'SoraFoundation/Classes/Localization/**/*'
  end

  s.test_spec do |ts|
      ts.source_files = 'Example/Tests/**/*.swift'
  end

end
