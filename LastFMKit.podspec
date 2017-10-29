Pod::Spec.new do |s|
  s.name             = "LastFMKit"
  s.version          = "1.0.0"
  s.summary          = "Objective-C bindings for the Last.FM API"
  s.homepage         = "https://github.com/mourke/LastFMKit"
  s.license          = 'MIT'
  s.author           = { "Mark Bourke" => "markkbourke@gmail.com" }
  s.requires_arc = true
  s.source   = { :git => 'https://github.com/mourke/LastFMKit.git', :tag => s.version }

  s.public_header_files = 'LastFMKit/LastFMKit.h'
  s.source_files = 'LastFMKit/LastFMKit.h'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

end
