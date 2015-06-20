Pod::Spec.new do |spec|
  spec.name = 'SocketIOKit'
  spec.version = '1.0.3'
  spec.summary = 'Socket.io iOS and OSX Client compatible with v1.0 and later'
  spec.homepage = 'https://github.com/ricardopereira/SocketIO-Kit'
  spec.license = { :type => 'MIT', :file => 'LICENSE.md' }
  spec.author = { "Ricardo Pereira" => "m@ricardopereira.eu" }
  spec.social_media_url = 'https://twitter.com/ricardopereiraw'
  spec.source = { :git => 'https://github.com/ricardopereira/SocketIO-Kit.git', :tag => "v#{spec.version}" }
  spec.source_files = 'SocketIOKit/*.{h}', 'Source/**/*.{h,swift}'

  spec.requires_arc = true

  spec.ios.deployment_target = '8.0'
  spec.ios.frameworks = 'Foundation', 'UIKit'

  spec.osx.deployment_target = '10.9'
  spec.osx.frameworks = 'Foundation', 'AppKit'

  spec.dependency 'Runes', '2.0.0'
  spec.dependency 'SwiftWebSocket', '0.1.18'
end
