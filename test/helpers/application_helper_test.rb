##
# application_helper_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
    test 'should get form fields partial string of model instance' do
        assert_equal 'albums/fields', fields_partial_for(Album.new)
    end

    test 'should get show partial string of model instance' do
        assert_equal 'albums/show', show_partial_for(Album.new)
    end

    test 'should get details partial string of model instance' do
        assert_equal 'albums/details', details_partial_for(Album.new)
    end

    test 'should get index partial string of model instance' do
        assert_equal 'albums/index', index_partial_for(Album.new)
    end

    test 'should cut text if longer then given max length of characters' do
        text = 'Lorem ipsum dorem.'
        assert_equal 'Lorem ...', short_text(text, 10)
    end

    test 'should return time difference in words' do
        assert_equal 'less than a minute ago', set_time_difference(Time.now)
    end
end
