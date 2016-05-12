Pod::Spec.new do |s|
  s.name             = 'Omise-iOS-Swift'
  s.version          = '2.0.1'
  s.summary          = 'Swift 2.0 client library for the Omise API'
  s.description      = <<-DESC
    Omise-iOS-Swift is a library for managing payment authorization tokens and
    stored credit card details with the Omise API.
  DESC

  s.homepage         = 'https://github.com/omise/omise-ios-swift'
  s.social_media_url = 'https://twitter.com/omise'
  s.author           = { 'Omise' => 'support@omise.co' }
  s.license          = 'MIT'
  s.source           = { :git => 'https://github.com/omise/omise-ios-swift.git',
                         :tag => "v#{s.version}" }

  s.platform = :ios, '8.0'

  s.source_files = 'Omise-iOS_SDK/Omise-iOS_SDK/SDK/*.swift'
  s.frameworks = ['UIKit']
end

