Gem::Specification.new do |s|
  s.name        = "dozen"
  s.version     = '1.1.0'
  s.authors     = ["Rob Fletcher"]
  s.email       = ["rob@terraflubb.com"]
  s.date        = "2013-09-13"
  s.homepage    = "http://terraflubb.github.com/dozen"
  s.summary     = "A simple tool to pair your Sixaxis controller with any Bluetooth device"
  s.description = "A simple tool to pair your Sixaxis controller with any Bluetooth device. Derived from the sixpair.c source."
  s.license = "MIT"

  s.files         = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]]
  s.executables   << 'dozen'
  s.require_paths = ["lib"]

  s.add_runtime_dependency("commander", "~> 4.1.3")
  s.add_runtime_dependency("libusb", "~> 0.3.4")
end
