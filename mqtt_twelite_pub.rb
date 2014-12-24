#!/usr/bin/ruby
#  -*- encoding: utf-8 -*-
#
# mqtt_sensor_pub.rb - Sample script to publish the sensor data using the MQTT
#
#   $ sudo gem install serialport
#   $ sudo gem install mqtt 
#   $ sudo gem install pit
# 
require 'rubygems'
require 'serialport'
require 'mqtt'
require 'json'
require 'time'
require 'pit'
require_relative './twe'

config = Pit.get("mqtt_twelite", :require => {
	"remote_host" => "mqtt.example.com",
	"remote_port" => 1883,
	"username"    => "username",
	"password"    => "password",
	"topic"       => "topic",
	"dev"         => "/dev/ttyUSB0",
	"src_irn"     => "11223344"
})

conn_opts = {
	remote_host: config["remote_host"],
	remote_port: config["remote_port"].to_i,
	username:    config["username"],
	password:    config["password"],
}

sp = SerialPort.new(config["dev"], 115200)

loop do
	begin
		MQTT::Client.connect(conn_opts) do |c|
			while true do
				l = sp.gets.chomp
				puts l

				twe = TWE.parse(l)
				next if twe.nil?

				if twe.irn != config["src_irn"]
					$stderr.puts "ignore packet from irn=#{twe.irn}..."
					next
				end

				h = {}
				h["door"]      = twe.di(1)
				h["lqi"]       = twe.lqi
				h["timestamp"] = twe.timestamp
				h["power_supply_voltage"] = twe.power_supply_voltage
				json_str = JSON.generate(h)
			
				puts "[#{Time.now.iso8601}] publish : " + json_str
				c.publish(config["topic"], json_str)
			end
		end
	rescue Exception => e
		puts e
	end
	sleep 5
end
