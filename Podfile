# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'Diary' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for Diary
  
  # add pods for desired Firebase products
  # https://firebase.google.com/docs/ios/setup#available-pods
  
  pod 'Firebase/Auth'
  #  pod 'Firebase/Core'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  pod 'Firebase/Database'
  
end

post_install do |pi|
    pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
        end
    end
end
