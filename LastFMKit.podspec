Pod::Spec.new do |s|
  s.name             = 'LastFMKit'
  s.version          = '1.0.0'
  s.summary          = 'Objective-C bindings for the Last.FM API'
  s.homepage         = 'https://github.com/mourke/LastFMKit'
  s.license          = { :type => 'MIT', :text => <<-LICENSE
    MIT License

    Copyright (c) 2017 Mark Bourke

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.

    LICENSE
  }
  s.author           = { 'Mark Bourke' => 'markkbourke@gmail.com' }
  s.requires_arc = true
  s.source   = { :http => "https://github.com/mourke/LastFMKit/releases/download/#{s.version}/LastFMKit.framework.zip" }

  s.ios.vendored_frameworks = 'Carthage/Build/iOS/LastFMKit.framework'
  s.ios.source_files        = 'Carthage/Build/iOS/LastFMKit.framework/Headers/*.h'
  s.ios.public_header_files = 'Carthage/Build/iOS/LastFMKit.framework/Headers/*.h'

  s.tvos.vendored_frameworks = 'Carthage/Build/tvOS/LastFMKit.framework'
  s.tvos.source_files        = 'Carthage/Build/tvOS/LastFMKit.framework/Headers/*.h'
  s.tvos.public_header_files = 'Carthage/Build/tvOS/LastFMKit.framework/Headers/*.h'

  s.osx.vendored_frameworks = 'Carthage/Build/Mac/LastFMKit.framework'
  s.osx.source_files        = 'Carthage/Build/Mac/LastFMKit.framework/Versions/A/Headers/*.h'
  s.osx.public_header_files = 'Carthage/Build/Mac/LastFMKit.framework/Versions/A/Headers/*.h'

  s.watchos.vendored_frameworks = 'Carthage/Build/watchOS/LastFMKit.framework'
  s.watchos.source_files        = 'Carthage/Build/watchOS/LastFMKit.framework/Headers/*.h'
  s.watchos.public_header_files = 'Carthage/Build/watchOS/LastFMKit.framework/Headers/*.h'

  s.ios.deployment_target     = '8.0'
  s.osx.deployment_target     = '10.10'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target    = '9.0'

end
