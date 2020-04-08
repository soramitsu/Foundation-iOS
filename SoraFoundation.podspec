#
# Be sure to run `pod lib lint SoraFoundation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SoraFoundation'
  s.version          = '0.7.0'
  s.summary          = 'Implementation of commonly used algorithms to avoid boilerplate code.'

  s.description      = 'Library contains implementation of commonly used algorithms to reduce duplicated and boilerplate code.'

  s.homepage         = 'https://github.com/soramitsu'
  s.license          = { :type => 'GPL 3.0', :file => 'LICENSE' }
  s.author           = { 'ERussel' => 'emkil.russel@gmail.com' }
  s.source           = { :git => 'https://github.com/soramitsu/Foundation-iOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.swift_version = '5.0'

  s.frameworks = 'UIKit'

  s.subspec 'Localization' do |lc|
      lc.dependency 'SoraKeystore', '~> 0.1.5'
      lc.source_files = 'SoraFoundation/Classes/Localization/**/*'
  end

  s.subspec 'Timer' do |tm|
      tm.dependency 'SoraFoundation/NotificationHandlers'
      tm.source_files = 'SoraFoundation/Classes/Timer/**/*'
  end

  s.subspec 'NotificationHandlers' do |nh|
      nh.source_files = 'SoraFoundation/Classes/NotificationHandlers/**/*'
  end

  s.subspec 'QueryProcessing' do |qp|
      qp.source_files = 'SoraFoundation/Classes/QueryProcessing/**/*'
  end

  s.subspec 'DateProcessing' do |dp|
      dp.dependency 'SoraFoundation/Localization'
      dp.source_files = 'SoraFoundation/Classes/DateProcessing/**/*'
  end

  s.subspec 'ViewModel' do |vm|
      vm.source_files = 'SoraFoundation/Classes/ViewModel/**/*'
  end

  s.test_spec do |ts|
      ts.source_files = 'Example/Tests/**/*.swift'
      ts.dependency 'Cuckoo'
  end

end
