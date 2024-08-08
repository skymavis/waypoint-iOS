Pod::Spec.new do |spec|
  spec.name         = "id"
  spec.version      = "0.1.1"
  spec.summary      = "A framework to interact with Mavis ID."
  spec.description  = <<-DESC
                      The Mavis ID iOS SDK lets developers integrate Mavis ID into mobile apps developed for the iOS platform.
                       After the integration, users can sign in to your app with Mavis ID and create an embedded Web3 wallet to interact with the blockchain to send and receive tokens, sign messages, and more.
                       DESC


  spec.homepage     = "https://github.com/skymavis/mavis-id-iOS"
  spec.license      = { :type => "MIT" }
  spec.authors            = { "thienNH0" => "thien.hoang.nguyen@skymavis.com" }
  spec.platform     = :ios, "13.0"
  spec.source       = { :git => "https://github.com/skymavis/mavis-id-iOS", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/**/*.{swift,h,m}"
  spec.exclude_files = "Sources/Exclude"
end
