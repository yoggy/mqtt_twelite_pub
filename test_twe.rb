require 'test/unit'
require './twe.rb'

class TWETest < Test::Unit::TestCase
	def setup
	end

	def test_case0
		twe = TWE.parse("testtesttest")
		assert_equal(true, twe.nil?)
	end

	def test_case1
		src = ":7C81150121810076ED788793000BD32700014D0D27048348"
		check(src, 0x21, "810076ED", 0x8793, 0x0BD3 / 1000.0, 0, 0, 0, 0)
	end

	def test_case2
		src = ":7C81150121810076ED788793000BD32701014D0D27048348"
		check(src, 0x21, "810076ED", 0x8793, 0x0BD3 / 1000.0, 1, 0, 0, 0)
	end

	def test_case3
		src = ":7C81150121810076ED788793000BD3270F014D0D27048348"
		check(src, 0x21, "810076ED", 0x8793, 0x0BD3 / 1000.0, 1, 1, 1, 1)
	end

	def check(src, lqi, irn, timestamp, power_supply_voltage, di1, di2, di3, di4)
		twe = TWE.parse(src)
		assert_equal false, twe.nil?

		assert_equal src,                  twe.status
		assert_equal lqi,                  twe.lqi
		assert_equal irn,                  twe.irn
		assert_equal timestamp,            twe.timestamp
		assert_equal power_supply_voltage, twe.power_supply_voltage
		assert_equal di1,                  twe.di(1)
		assert_equal di2,                  twe.di(2)
		assert_equal di3,                  twe.di(3)
		assert_equal di4,                  twe.di(4)
	end
end

