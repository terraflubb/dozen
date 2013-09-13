require 'libusb'
require 'commander/import'

program :name, 'dozen'
program :version, '0.0.1'
program :description, 'Tool to pair your Bluetooth Sixaxis PS3 controller, a Ruby port of sixpair.'

command :list do |c|
  c.syntax = 'dozen list'
  c.description = 'Will list all Sixaxis controllers currently connected via USB and display their masters.'
  c.action do |args, options|
    x = Dozen.new
    x.list_controllers
  end
end

default_command :list

class Dozen
  public
  def initialize
    @usb = LIBUSB::Context.new
  end

  def list_controllers
    find_sixaxis_devices.each_with_index do |device, index|
      device.open do |handle|
        master = query_for_bluetooth_master(handle)
        puts "Sixaxis #{index} master is: #{master.each_byte.map { |b| b.to_s(16) }.join(':')}"
        set_bluetooth_master(handle)
        master = query_for_bluetooth_master(handle)
        puts "Sixaxis #{index} master is: #{master.each_byte.map { |b| b.to_s(16) }.join(':')}"
      end
    end
  end

  private

  def find_sixaxis_devices
    @usb.devices(:idVendor => 0x054c, :idProduct => 0x0268)
  end

  def query_for_bluetooth_master(handle)
    handle.control_transfer(
      :bmRequestType => LIBUSB::REQUEST_TYPE_CLASS | LIBUSB::ENDPOINT_IN | LIBUSB::RECIPIENT_INTERFACE,
      :bRequest => 0x01,
      :wValue => 0x03f5,
      :wIndex => 0x0000,
      :dataIn => 8,
      :timeout => 5000)[2,6]
  end

  def set_bluetooth_master(handle)
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
