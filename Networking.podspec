Pod::Spec.new do |spec|

  spec.name         = "Networking"
  spec.version      = "1.0.0"
  spec.summary      = "An iOS SDK to do Network Calls."
  spec.description  = <<-DESC
                    You can use the Networking SDK in your iOS app project to make api calls.
                   DESC

  spec.homepage     = "https://github.com/rohit-13/Networking"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Rohit Kumar" => "https://github.com/rohit-13" }
  spec.platform     = :ios, "15.0"
  spec.source       = { :git => "https://github.com/rohit-13/Networking/blob/main/Networking.xcframework.zip", :tag => "#{spec.version}" }
  spec.vendored_frameworks = 'Networking.xcframework'
end
