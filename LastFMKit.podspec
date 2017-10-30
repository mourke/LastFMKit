Pod::Spec.new do |s|
  s.name             = 'LastFMKit'
  s.version          = '1.0.0'
  s.summary          = 'Objective-C bindings for the Last.FM API'
  s.homepage         = 'https://github.com/mourke/LastFMKit'
  s.license          = 'MIT'
  s.author           = { 'Mark Bourke' => 'markkbourke@gmail.com' }
  s.requires_arc = true
  s.source   = { :git => 'https://github.com/mourke/LastFMKit.git', :tag => s.version }

  s.ios.vendored_frameworks = 'Carthage/Build/iOS/LastFMKit.framework'
  s.ios.source_files        = 'Carthage/Build/iOS/LastFMKit.framework/Headers/*.h'
  s.ios.public_header_files = 'Carthage/Build/iOS/LastFMKit.framework/Headers/*.h'

  s.tvos.vendored_frameworks = 'Carthage/Build/tvOS/LastFMKit.framework'
  s.tvos.source_files        = 'Carthage/Build/tvOS/LastFMKit.framework/Headers/*.h'
  s.tvos.public_header_files = 'Carthage/Build/tvOS/LastFMKit.framework/Headers/*.h'

  s.osx.vendored_frameworks = 'Carthage/Build/Mac/LastFMKit.framework'
  s.osx.source_files        = 'Carthage/Build/Mac/LastFMKit.framework/Headers/*.h'
  s.osx.public_header_files = 'Carthage/Build/Mac/LastFMKit.framework/Headers/*.h'

  s.watchos.vendored_frameworks = 'Carthage/Build/watchOS/LastFMKit.framework'
  s.watchos.source_files        = 'Carthage/Build/watchOS/LastFMKit.framework/Headers/*.h'
  s.watchos.public_header_files = 'Carthage/Build/watchOS/LastFMKit.framework/Headers/*.h'

  s.ios.deployment_target     = '8.0'
  s.osx.deployment_target     = '10.10'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target    = '9.0'

end
