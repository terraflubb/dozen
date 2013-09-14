require 'libusb'

class Dozen
  def initialize
    @usb = LIBUSB::Context.new
    @devices = query_usb_for_sixaxis_devices
    puts "Dozen v#{Dozen.VERSION}"
    puts
  end

  def list_controllers
    if @devices.length == 0
      puts "No Sixaxis controllers connected via USB."
      return
    end

    @devices.each_with_index do |device, index|
      device.open do |handle|
        master = get_device_master_from_handle(handle)
        puts "Controller ##{index} is paired with #{master.each_byte.map { |b| b.to_s(16) }.join(':')}"
      end
    end
  end

  def self.VERSION
    '1.0.0'
  end

  private

  def query_usb_for_sixaxis_devices
    @usb.devices(:idVendor => 0x054c, :idProduct => 0x0268)
  end

  def get_device_master_from_handle(handle)
    handle.control_transfer(
      :bmRequestType => LIBUSB::REQUEST_TYPE_CLASS | LIBUSB::ENDPOINT_IN | LIBUSB::RECIPIENT_INTERFACE,
      :bRequest => 0x01,
      :wValue => 0x03f5,
      :wIndex => 0x0000,
      :dataIn => 8,
      :timeout => 5000)[2,6]
  end

  def assign_master_with_handle(handle)
    # starts with 0x01, 0x00, then your bluetooth address
    bluetooth_addy = [0x01, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]

    msg = bluetooth_addy.pack('c*')
    handle.control_transfer(
      :bmRequestType => LIBUSB::REQUEST_TYPE_CLASS | LIBUSB::ENDPOINT_OUT | LIBUSB::RECIPIENT_INTERFACE,
      :bRequest => 0x09,
      :wValue => 0x03f5,
      :wIndex => 0x0000,
      :dataOut => msg,
      :timeout => 5000)
  end
end
