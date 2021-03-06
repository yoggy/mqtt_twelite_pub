#!/usr/bin/ruby
#  -*- encoding: utf-8 -*-
#
# twe.rb - TWE-Lite DIP client status(0x81) packet parser
#

class TWE
	def self.parse(str)
		str = str.chomp
		if str.nil?
			$stderr.puts "TWE.parse() : str is nil..."
			return nil
		end
		if str.size != 49
			$stderr.puts "TWE.parse() : invalid string length...str=#{str}"
		return nil
	end

	TWE.new(str)
	end

	def initialize(str)
		@status = str
	end
	
	def status
		@status
	end

	# 電波強度 (0-255)
	def lqi
		@status[9, 2].to_i(16)
	end

	# 個体識別番号 (individual recognition number)
	def irn
		@status[11,8]
	end

	# タイムスタンプ
	def timestamp
		@status[21,4].to_i(16)
	end

	# 電源減圧 (V)
	def power_supply_voltage
		@status[27,4].to_i(16) / 1000.0
	end

	# DIの状態ビット
	def di(idx)
		d = @status[33,2].to_i(16)
		return (d >> 0) & 0x01 if idx == 1
		return (d >> 1) & 0x01 if idx == 2
		return (d >> 2) & 0x01 if idx == 3
		return (d >> 3) & 0x01 if idx == 4
	
		0
	end

	# for debug...
	def dump_str
		return <<-EOS
    lqi                  : #{lqi}
    irn                  : #{irn}
    timestamp            : #{timestamp}
    power_supply_voltage : #{power_supply_voltage}
    di1                  : #{di(1)}
    di2                  : #{di(2)}
    di3                  : #{di(3)}
    di4                  : #{di(4)}
		EOS
	end
end

def usage
	puts "usage : ./twe.rb [twe-lite client status packet string(0x81)]"
	puts
	exit 1
end

def main
	usage if ARGV.size == 0
	
	twe = TWE.parse(ARGV[0])
	if twe.nil?
		puts "TWE.parse() failed..."
		return
	end

	puts twe.dump_str
end

if __FILE__ == $0
	main
end
