# detect_fake_location.podspec
Pod::Spec.new do |s|
  s.name             = 'detect_fake_location'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin to detect fake locations (patched for iOS 14+)'
  s.description      = <<-DESC
A Flutter plugin to detect fake locations.
Patched to be compatible with iOS 14–18 simulators by avoiding _LocationEssentials on older iOS versions.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }

  # Source files are in Classes folder
  s.source_files = 'Classes/**/*.{swift,h,m}'

  s.dependency 'Flutter'

  # Minimum iOS version
  s.platform = :ios, '14.0'

  # Exclude old simulator architectures
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }

  # Swift version
  s.swift_version = '5.0'
end
