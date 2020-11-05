Pod::Spec.new do |s|
  s.name             = 'Four20'
  s.version          = '0.3.15'
  s.summary          = 'A grab-bag of Swift extensions.'
  s.description      = 'A grab-bag of Swift extensions for rapid prototyping.'

  s.homepage         = 'https://github.com/Buglife/four20'
  s.license          = { :type => 'Apache', :file => 'LICENSE' }
  s.author           = { 'Buglife' => 'support@buglife.com' }
  s.source           = { :git => 'https://github.com/Buglife/four20.git', :tag => s.version.to_s }
  s.ios.deployment_target = '12.0'
  s.tvos.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.source_files     = 'Source/Shared/**/*'
  s.ios.source_files     = 'Source/iOS/**/*'
  s.swift_version    = '5.0'
end
