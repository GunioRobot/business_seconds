require 'helper'

class TestTimeWithZoneExtensions < Test::Unit::TestCase
  
  context "With Eastern Standard Time" do
    setup do
      Time.zone = 'Eastern Time (US & Canada)'
    end

    context "Business duration" do

      should "know a seconds to an instance" do
        start_time = Time.zone.parse("August 17th, 2010, 8:50 am")
        end_time = Time.zone.parse("August 17th, 2010, 13:00 pm")
        expecting = Time.business_seconds_duration_from_to(start_time, end_time)
        assert_equal expecting, 3600 * 4

        start_time = Time.zone.parse("August 17th, 2010, 11:50 am")
        end_time = Time.zone.parse("August 17th, 2010, 13:50 pm")
        expecting = Time.business_seconds_duration_from_to(start_time, end_time)
        assert_equal expecting, 7200

        start_time = Time.zone.parse("August 17th, 2010, 17:50 pm")
        end_time = Time.zone.parse("August 17th, 2010, 18:50 pm")
        expecting = Time.business_seconds_duration_from_to(start_time, end_time)
        assert_equal expecting, 0
        
        start_time = Time.zone.parse("August 22th, 2010, 11:50 am")
        end_time = Time.zone.parse("August 22th, 2010, 13:50 pm")
        expecting = Time.business_seconds_duration_from_to(start_time, end_time)
        assert_equal expecting, 0
      end

      should "know a seconds to an instance between holidays" do
        # weekend day
        start_time = Time.zone.parse("August 22th, 2010, 11:50 am")
        BusinessTime::Config.reset
        
        BusinessTime::Config.holidays << Date.parse("August 24, 2010")
        end_time = Time.zone.parse("August 24th, 2010, 13:50 pm")
        expecting = Time.business_seconds_duration_from_to(start_time, end_time)
        assert_equal expecting, 8 * 3600
      end

      should "know a seconds to an other day instance" do
        start_time = Time.zone.parse("August 17th, 2010, 16:00 pm")
        end_time = Time.zone.parse("August 18th, 2010, 9:00 am")
        expecting = Time.business_seconds_duration_from_to(start_time, end_time)
        assert_equal expecting, 3600

        start_time = Time.zone.parse("August 21th, 2010, 13:00 pm")
        end_time = Time.zone.parse("August 22th, 2010, 17:00 pm")
        expecting = Time.business_seconds_duration_from_to(start_time, end_time)
        assert_equal expecting, 0
      end

      should "know a seconds to an other week instance" do
        start_time = Time.zone.parse("August 17th, 2010, 16:00 pm")
        end_time = Time.zone.parse("August 23th, 2010, 10:00 am")
        expecting = Time.business_seconds_duration_from_to(start_time, end_time)
        assert_equal expecting, (3600 * 26)
      end

      should "know a seconds to end of business hours" do
        time = Time.zone.parse("August 17th, 2010, 16:00 pm")
        expecting = Time.business_seconds_left_to_the_end_of_day(time)
        assert_equal expecting, 3600
        time = Time.zone.parse("August 17th, 2010, 8:00 am")
        expecting = Time.business_seconds_left_to_the_end_of_day(time)
        assert_equal expecting, 3600 * 8
        time = Time.zone.parse("August 17th, 2010, 18:00 pm")
        expecting = Time.business_seconds_left_to_the_end_of_day(time)
        assert_equal expecting, 0
        time = Time.zone.parse("August 21th, 2010, 16:00 pm")
        expecting = Time.business_seconds_left_to_the_end_of_day(time)
        assert_equal expecting, 0
      end

      should "know a seconds from beginning of business hours" do
        time = Time.zone.parse("August 17th, 2010, 16:00 pm")
        expecting = Time.business_seconds_from_the_beginning_of_day(time)
        assert_equal expecting, 3600 * 7
        time = Time.zone.parse("August 17th, 2010, 8:00 am")
        expecting = Time.business_seconds_from_the_beginning_of_day(time)
        assert_equal expecting, 0
        time = Time.zone.parse("August 17th, 2010, 18:00 pm")
        expecting = Time.business_seconds_from_the_beginning_of_day(time)
        assert_equal expecting, 3600 * 8
        time = Time.zone.parse("August 21th, 2010, 16:00 pm")
        expecting = Time.business_seconds_from_the_beginning_of_day(time)
        assert_equal expecting, 0
      end

    end

    should "know if instance is during business hours" do
      BusinessTime::Config.holidays = []
      assert(!Time.during_business_hours?(Time.zone.parse("April 11, 2010 10:45 am")))
      assert(!Time.during_business_hours?(Time.zone.parse("April 12, 2010  8:45 am")))
      assert(!Time.during_business_hours?(Time.zone.parse("April 12, 2010  18:15 pm")))
      assert(Time.during_business_hours?(Time.zone.parse("April 12, 2010  9:45 am")))
      time = Time.zone.parse("August 17th, 2010, 16:00 pm")
      assert(Time.during_business_hours?(time))
      assert(Time.during_business_hours?(Time.zone.parse("April 12, 2010  16:00 pm")))
    end
  end

  context "With UTC Timezone" do
    setup do
      Time.zone = 'UTC'
    end


    context "Business duration" do

      should "know a seconds to an instance" do
        start_time = Time.zone.parse("August 17th, 2010, 8:50 am")
        end_time = Time.zone.parse("August 17th, 2010, 13:00 pm")
        expecting = Time.business_seconds_duration_from_to(start_time, end_time)
        assert_equal expecting, 3600 * 4

        start_time = Time.zone.parse("August 17th, 2010, 11:50 am")
        end_time = Time.zone.parse("August 17th, 2010, 13:50 pm")
        expecting = Time.business_seconds_duration_from_to(start_time, end_time)
        assert_equal expecting, 7200

        start_time = Time.zone.parse("August 17th, 2010, 17:50 pm")
        end_time = Time.zone.parse("August 17th, 2010, 18:50 pm")
        expecting = Time.business_seconds_duration_from_to(start_time, end_time)
        assert_equal expecting, 0
        
        start_time = Time.zone.parse("August 22th, 2010, 11:50 am")
        end_time = Time.zone.parse("August 22th, 2010, 13:50 pm")
        expecting = Time.business_seconds_duration_from_to(start_time, end_time)
        assert_equal expecting, 0
      end

      should "know a seconds to an instance between holidays" do
        # weekend day
        start_time = Time.zone.parse("August 22th, 2010, 11:50 am")
        BusinessTime::Config.reset
        
        BusinessTime::Config.holidays << Date.parse("August 24, 2010")
        end_time = Time.zone.parse("August 24th, 2010, 13:50 pm")
        expecting = Time.business_seconds_duration_from_to(start_time, end_time)
        assert_equal expecting, 8 * 3600
      end

      should "know a seconds to an other day instance" do
        start_time = Time.zone.parse("August 17th, 2010, 16:00 pm")
        end_time = Time.zone.parse("August 18th, 2010, 9:00 am")
        expecting = Time.business_seconds_duration_from_to(start_time, end_time)
        assert_equal expecting, 3600

        start_time = Time.zone.parse("August 21th, 2010, 13:00 pm")
        end_time = Time.zone.parse("August 22th, 2010, 17:00 pm")
        expecting = Time.business_seconds_duration_from_to(start_time, end_time)
        assert_equal expecting, 0
      end

      should "know a seconds to an other week instance" do
        start_time = Time.zone.parse("August 17th, 2010, 16:00 pm")
        end_time = Time.zone.parse("August 23th, 2010, 10:00 am")
        expecting = Time.business_seconds_duration_from_to(start_time, end_time)
        assert_equal expecting, (3600 * 26)
      end

      should "know a seconds to end of business hours" do
        time = Time.zone.parse("August 17th, 2010, 16:00 pm")
        expecting = Time.business_seconds_left_to_the_end_of_day(time)
        assert_equal expecting, 3600
        time = Time.zone.parse("August 17th, 2010, 8:00 am")
        expecting = Time.business_seconds_left_to_the_end_of_day(time)
        assert_equal expecting, 3600 * 8
        time = Time.zone.parse("August 17th, 2010, 18:00 pm")
        expecting = Time.business_seconds_left_to_the_end_of_day(time)
        assert_equal expecting, 0
        time = Time.zone.parse("August 21th, 2010, 16:00 pm")
        expecting = Time.business_seconds_left_to_the_end_of_day(time)
        assert_equal expecting, 0
      end

      should "know a seconds from beginning of business hours" do
        time = Time.zone.parse("August 17th, 2010, 16:00 pm")
        expecting = Time.business_seconds_from_the_beginning_of_day(time)
        assert_equal expecting, 3600 * 7
        time = Time.zone.parse("August 17th, 2010, 8:00 am")
        expecting = Time.business_seconds_from_the_beginning_of_day(time)
        assert_equal expecting, 0
        time = Time.zone.parse("August 17th, 2010, 18:00 pm")
        expecting = Time.business_seconds_from_the_beginning_of_day(time)
        assert_equal expecting, 3600 * 8
        time = Time.zone.parse("August 21th, 2010, 16:00 pm")
        expecting = Time.business_seconds_from_the_beginning_of_day(time)
        assert_equal expecting, 0
      end

    end

    should "know if instance is during business hours" do
      BusinessTime::Config.holidays = []
      assert(!Time.during_business_hours?(Time.zone.parse("April 11, 2010 10:45 am")))
      assert(!Time.during_business_hours?(Time.zone.parse("April 12, 2010  8:45 am")))
      assert(!Time.during_business_hours?(Time.zone.parse("April 12, 2010  18:15 pm")))
      assert(Time.during_business_hours?(Time.zone.parse("April 12, 2010  9:45 am")))
      time = Time.zone.parse("August 17th, 2010, 16:00 pm")
      assert(Time.during_business_hours?(time))
      assert(Time.during_business_hours?(Time.zone.parse("April 12, 2010  16:00 pm")))
    end
  end
end
