Pod::Spec.new do |s|

    s.version = "1.0.1"
    s.ios.deployment_target = '10.0'
    s.osx.deployment_target = '10.10'
    s.name = "RxEnumKit"
 	s.summary      = "Reactive extension for the EnumKit framework to enable easy working with observables streams of events as enum cases"
	s.swift_version = '5.0'
    
  	s.description  = <<-DESC
                   RxEnumKit is a library that gives you the ability to simply access, map, filter and flatMap an enum associated value, without having to use pattern matching, in a stream of enum cases.
                   DESC
                   
    s.requires_arc = true

    s.license = { :type => "MIT" }
	s.homepage = "https://www.pfrpg.net"
    s.author = { "Giuseppe Lanza" => "gringoire986@gmail.com" }

    s.source = {
        :git => "https://github.com/gringoireDM/RxEnumKit.git",
        :tag => s.version.to_s
    }
    
	s.dependency 'EnumKit', '~>1.0.0'
	s.dependency 'RxCocoa', '~>5.0.0'
	
    s.source_files = "RxEnumKit/**/*.swift"
end
