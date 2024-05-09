Pod::Spec.new do |spec|

  spec.name         = "Networking"
  spec.version      = "1.0.0"
  spec.summary      = "An iOS SDK to do Network Calls"
  spec.description  = <<-DESC
                    An iOS SDK to do Network Calls
                   DESC

  spec.homepage     = "https://github.com/rohit-13/Networking"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Rohit Kumar" }
  spec.platform     = :ios, "15.0"
  spec.source       = { :git => "http://EXAMPLE/Networking.git", :tag => "#{spec.version}" }
  spec.vendored_frameworks = 'Networking.framework'
end
