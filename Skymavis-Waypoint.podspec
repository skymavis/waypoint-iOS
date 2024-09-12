Pod::Spec.new do |spec|
  spec.name         = "SkyMavis-Waypoint"
  spec.version      = "0.1.3"
  spec.summary      = "An SDK for integrating Waypoint single sign-on and Web3 wallet features into iOS apps."
  spec.description  = <<-DESC
                      The iOS SDK allows developers to integrate Waypoint into iOS apps. Users can sign in with Waypoint and create an embedded Web3 wallet to interact with the blockchain, enabling token transactions, message signing, and more.
                       DESC


  spec.homepage     = "https://github.com/skymavis/waypoint-iOS"
  spec.license      = { :type => "MIT" }
  spec.authors            = { "SkyMavis" => "developer@skymavis.com" }
  spec.platform     = :ios, "13.0"
  spec.source       = { :git => "https://github.com/skymavis/waypoint-iOS", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/**/*.{swift,h,m}"
  spec.exclude_files = "Sources/Exclude"
end
