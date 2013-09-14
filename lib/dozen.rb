require 'libusb'

class Dozen

  def initialize
    @usb = LIBUSB::Context.new
    @devices = query_usb_for_sixaxis_devices
    if @devices.length == 0
      puts "No Sixaxis controllers connected via USB."
    end
  end

  def list_controllers
    @devices.each_with_index do |device, index|
      device.open do |handle|
        master = get_device_master_from_handle(handle)
        puts "Controller ##{index} is paired with #{master.each_byte.map { |b| b.to_s(16) }.join(':')}"
      end
    end
  end

  def assign_address_to_controller(address, controller_index)
    if @devices[controller_index].nil?
      puts "No device available at index #{controller_index}"
      return
    end

    @devices[controller_index].open do |handle|
      puts "Assigning address #{formatAddress(address)} to controller ##{controller_index}"
      assign_master_to_handle(address, handle)
    end
  end

  def assign_address_to_all(address)
    @devices.each_with_index do |device, index|
      device.open do |handle|
        puts "Assigning address #{formatAddress(address)} to controller ##{controller_index}"
        assign_master_to_handle(address, handle)
      end
    end
  end

  def self.parse_bluetooth_address(raw_address)
    begin
      preparedAddress = raw_address.split(':').map{ |x| Integer(x, 16)}
    rescue
      preparedAddress = false
    end
    return false if preparedAddress.length != 6
    return false if preparedAddress.any? {|x| x < 0 || x > 0xFF}
    preparedAddress
  end

  def self.show_header
    puts "Dozen v#{Dozen.VERSION}"
    puts
  end

  def self.VERSION
    '1.0.0'
  end

  private

  def formatAddress(address)
    address.map{|x| x.to_s(16)}.join(':')
  end

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

  def assign_master_to_handle(address, handle)
    msg = ([0x01, 0x00] + address).pack('c*')
    handle.control_transfer(
      :bmRequestType => LIBUSB::REQUEST_TYPE_CLASS | LIBUSB::ENDPOINT_OUT | LIBUSB::RECIPIENT_INTERFACE,
      :bRequest => 0x09,
      :wValue => 0x03f5,
      :wIndex => 0x0000,
      :dataOut => msg,
      :timeout => 5000)
  end
end
