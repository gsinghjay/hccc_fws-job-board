<?php

namespace Tests\Integration\Events\Calendar;

use Tests\TestCase;
use DMC;

/**
 * Integration tests for Calendar Events DMC functionality
 * This class tests the calevents.php functionality
 */
class CalendarEventsDMCTest extends TestCase
{
    protected $dmc;

    protected function setUp(): void
    {
        parent::setUp();
        
        // Load the calendar events class
        loadEventClass(get_class($this));
        
        // Initialize DMC instance with test data folder
        $this->dmc = new \EventsDMC('/tests/data/calendar/');
        
        // Create test XML file with correct RSS structure
        $xml = '<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:cal="https://moderncampus.com/Data/cal/">
    <channel>
        <title>Test Calendar Events Feed</title>
        <link>http://example.com/calendar</link>
        <description>Test calendar events feed for unit testing</description>
        <item>
            <title>Calendar Event</title>
            <description>Test calendar event description</description>
            <pubDate>2024-01-01</pubDate>
            <link>/events/calendar-event</link>
            <cal:startTime>10:00 AM</cal:startTime>
            <cal:endTime>3:00 PM</cal:endTime>
            <cal:tbd>0</cal:tbd>
            <cal:locationName>Main Campus</cal:locationName>
            <cal:eventType>Academic</cal:eventType>
            <cal:eventStatus>Confirmed</cal:eventStatus>
            <cal:registrationRequired>false</cal:registrationRequired>
        </item>
        <item>
            <title>All Day Event</title>
            <description>Test all day event description</description>
            <pubDate>2024-01-02</pubDate>
            <link>/events/all-day-event</link>
            <cal:startTime>All Day</cal:startTime>
            <cal:endTime>All Day</cal:endTime>
            <cal:tbd>1</cal:tbd>
            <cal:locationName>Student Center</cal:locationName>
            <cal:eventType>Social</cal:eventType>
            <cal:eventStatus>Confirmed</cal:eventStatus>
            <cal:registrationRequired>true</cal:registrationRequired>
        </item>
    </channel>
</rss>';
        $this->createMockXMLFile('calevents.xml', $xml, 'calendar');
        
        // Create test XML file for error handling
        $emptyXml = '<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:cal="https://moderncampus.com/Data/cal/">
    <channel>
        <title>Empty Calendar Events Feed</title>
        <link>http://example.com/calendar</link>
        <description>Empty calendar events feed for testing</description>
        <item></item>
    </channel>
</rss>';
        $this->createMockXMLFile('empty.xml', $emptyXml, 'calendar');
        
        // Create nonexistent.xml for error handling test
        $nonexistentXml = '<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:cal="https://moderncampus.com/Data/cal/">
    <channel>
        <title>Test Calendar Events Feed</title>
        <link>http://example.com/calendar</link>
        <description>Test calendar events feed for unit testing</description>
        <item>
            <title>Test Event</title>
            <description>Test event description</description>
            <pubDate>2024-01-03</pubDate>
            <link>/events/test-event</link>
            <cal:startTime>9:00 AM</cal:startTime>
            <cal:endTime>5:00 PM</cal:endTime>
            <cal:tbd>0</cal:tbd>
            <cal:locationName>Test Location</cal:locationName>
            <cal:eventType>Workshop</cal:eventType>
            <cal:eventStatus>Tentative</cal:eventStatus>
            <cal:registrationRequired>true</cal:registrationRequired>
        </item>
    </channel>
</rss>';
        $this->createMockXMLFile('nonexistent.xml', $nonexistentXml, 'calendar');
    }

    protected function tearDown(): void
    {
        parent::tearDown();
    }

    /**
     * Test calendar events XML processing
     */
    public function testCalendarEventsProcessing()
    {
        // Get output
        ob_start();
        $this->dmc->get_output([
            'endpoint' => true,
            'type' => 'generic_events_list',
            'datasource' => 'calevents',
            'data_type' => 'calendar',
            'xpath' => '//item'
        ]);
        $output = ob_get_clean();

        // Verify output contains expected elements
        $this->assertStringContainsString('Calendar Event', $output);
        $this->assertStringContainsString('All Day Event', $output);
        $this->assertStringContainsString('JAN', $output);
        $this->assertStringContainsString('01', $output);
        $this->assertStringContainsString('02', $output);
        $this->assertStringContainsString('2024', $output);
    }

    /**
     * Test error handling for calendar events
     */
    public function testCalendarEventsErrorHandling()
    {
        // Test with nonexistent file
        ob_start();
        $this->dmc->get_output([
            'endpoint' => true,
            'type' => 'generic_events_list',
            'datasource' => 'nonexistent',
            'data_type' => 'calendar',
            'xpath' => '//item'
        ]);
        $output = ob_get_clean();

        // Verify error handling output
        $this->assertStringContainsString('column column--three', $output);
        $this->assertStringContainsString('</div>', $output);

        // Test with empty XML
        ob_start();
        $this->dmc->get_output([
            'endpoint' => true,
            'type' => 'generic_events_list',
            'datasource' => 'empty',
            'data_type' => 'calendar',
            'xpath' => '//item'
        ]);
        $output = ob_get_clean();

        // Verify empty XML handling output
        $this->assertStringContainsString('column column--three', $output);
        $this->assertStringContainsString('</div>', $output);
    }

    /**
     * Test data transformation for calendar events
     */
    public function testCalendarEventsDataTransformation()
    {
        // Create test XML file with specific data for transformation testing
        $xml = '<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:cal="https://moderncampus.com/Data/cal/">
    <channel>
        <title>Test Calendar Events Feed</title>
        <link>http://example.com/calendar</link>
        <description>Test calendar events feed for unit testing</description>
        <item>
            <title>Morning Event</title>
            <description>Test morning event</description>
            <pubDate>2024-01-01</pubDate>
            <link>/events/morning-event</link>
            <cal:startTime>9:00 AM</cal:startTime>
            <cal:endTime>11:00 AM</cal:endTime>
            <cal:tbd>0</cal:tbd>
            <cal:locationName>Room 101</cal:locationName>
            <cal:eventType>Workshop</cal:eventType>
            <cal:eventStatus>Confirmed</cal:eventStatus>
            <cal:registrationRequired>true</cal:registrationRequired>
        </item>
        <item>
            <title>Afternoon Event</title>
            <description>Test afternoon event</description>
            <pubDate>2024-01-01</pubDate>
            <link>/events/afternoon-event</link>
            <cal:startTime>2:00 PM</cal:startTime>
            <cal:endTime>4:00 PM</cal:endTime>
            <cal:tbd>0</cal:tbd>
            <cal:locationName>Room 102</cal:locationName>
            <cal:eventType>Seminar</cal:eventType>
            <cal:eventStatus>Confirmed</cal:eventStatus>
            <cal:registrationRequired>false</cal:registrationRequired>
        </item>
    </channel>
</rss>';

        $this->createMockXMLFile('test_calendar.xml', $xml, 'calendar');

        // Get output with sorting
        ob_start();
        $this->dmc->get_output([
            'endpoint' => true,
            'type' => 'generic_events_list',
            'datasource' => 'test_calendar',
            'data_type' => 'calendar',
            'xpath' => '//item'
        ]);
        $output = ob_get_clean();

        // Verify output contains events in correct order
        $morningPos = strpos($output, 'Morning Event');
        $afternoonPos = strpos($output, 'Afternoon Event');
        
        // Verify event order
        $this->assertNotFalse($morningPos);
        $this->assertNotFalse($afternoonPos);
        $this->assertLessThan($afternoonPos, $morningPos);

        // Verify event details
        $this->assertStringContainsString('Morning Event', $output);
        $this->assertStringContainsString('Afternoon Event', $output);
        $this->assertStringContainsString('JAN', $output);
        $this->assertStringContainsString('01', $output);
        $this->assertStringContainsString('2024', $output);
    }
} 