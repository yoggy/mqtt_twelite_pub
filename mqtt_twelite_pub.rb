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
require 'JSON'
require 'time'
require 'pit'
require './twe'

config = Pit.get("mqtt_twelite", :require => {
	"remote_host" => "mqtt broker host",
	"remote_port" => "mqtt broker port",
	"username"    => "mqtt username",
	"password"    => "mqtt password",
	"topic"       => "mqtt publish topic",
	"dev"         => "serial port device file",
	"idn:e:e
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

				h = {}
				h["door"]      = twe.di(1)
				h["lqi"]       = twe.lqi
				h["timestamp"] = twe.timestamp
				h["power_supply_voltage"] = twe.power_supply_voltage
				json_str = JSON.generate(h)
			
				puts "[#{Time.now.iso8601}] publish : " + json_str
				#c.publish(config["topic"], json_str)
			end
		end
	rescue Exception => e
		puts e
	end
	sleep 5
end
