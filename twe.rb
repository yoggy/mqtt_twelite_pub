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

    # 個体識別番号
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
        return d & 0x01 if idx == 1
        return d & 0x02 if idx == 2
        return d & 0x04 if idx == 3
        return d & 0x08 if idx == 4

		0
    end

    def jkkk
    end
end

def test_main
	twe = TWE.parse(":7C81150121810076ED788793000BD32703014D0D27048348")
	if twe.nil?
		$stderr.puts "TWE.parse() failed..."
		return
	end

	puts "twe.status : #{twe.status}"
	puts "lqi : #{twe.lqi}"
	puts "irn : #{twe.irn}"
	puts "timestamp : #{twe.timestamp}"
	puts "power_supply_voltage : #{twe.power_supply_voltage}"
	puts "di(1) : #{twe.di(1)}"
end

test_main if __FILE__ == $0


