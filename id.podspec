Pod::Spec.new do |spec|
  spec.name         = "id"
  spec.version      = "0.1.1"
  spec.summary      = "An SDK for integrating Mavis ID single sign-on and Web3 wallet features into iOS apps."
  spec.description  = <<-DESC
                      The Mavis ID iOS SDK allows developers to integrate Mavis ID into iOS apps. Users can sign in with Mavis ID and create an embedded Web3 wallet to interact with the blockchain, enabling token transactions, message signing, and more.
                       DESC


  spec.homepage     = "https://github.com/skymavis/mavis-id-iOS"
  spec.license      = { :type => "MIT" }
  spec.authors            = { "thienNH0" => "thien.hoang.nguyen@skymavis.com" }
  spec.platform     = :ios, "13.0"
  spec.source       = { :git => "https://github.com/skymavis/mavis-id-iOS", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/**/*.{swift,h,m}"
  spec.exclude_files = "Sources/Exclude"
end
