#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint rationalowl_flutter2.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'rationalowl_flutter'
  s.version          = '1.1.0'
  s.summary          = 'Flutter plugin for RationalOwl, a realtime mobile messaging service.'
  s.description      = <<-DESC
Flutter plugin for RationalOwl, a realtime mobile messaging service
                       DESC
  s.homepage         = 'http://rationalowl.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'RationalOwl' => 'support@rationalowl.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.vendored_frameworks = 'RationalOwl.framework'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'rationalowl_flutter2_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
