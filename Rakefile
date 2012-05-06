$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = "Birdemia"
  app.version = "1.0"
  app.identifier = "com.alexeypro.apps.Birdemia"
#  app.icons = ["Icon.png", "Icon@2x.png"]
  app.prerendered_icon = true
  app.sdk_version = "5.1"
  app.deployment_target = "5.0"
  app.codesign_certificate = "iPhone Distribution: Olexiy Prokhorenko"
  app.provisioning_profile = "/Users/alexey/Library/MobileDevice/Provisioning Profiles/056E79C1-3E90-4B53-8D81-8AC81514336E.mobileprovision"
  app.device_family = :iphone
  app.interface_orientations = [:portrait]
  app.frameworks << "AudioToolbox"
  app.frameworks << "AVFoundation"
end
