Pod::Spec.new do |spec|
  spec.name         = "Netlink"
  spec.version      = "1.0.0"
  spec.summary      = "An iOS SDK to do HTTP network calls."
  spec.description  = <<-DESC
                    You can use the Netlink SDK in your iOS app project to make api calls.
                   DESC

  spec.homepage     = "https://github.com/rohit-13/Netlink"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Rohit Kumar" => "https://github.com/rohit-13" }
  spec.platform     = :ios, "15.0"
  spec.source       = { :git => "https://github.com/rohit-13/Netlink.git", :branch => "main", :tag => "#{spec.version}" }
  spec.vendored_frameworks = 'Netlink.xcframework'
end
