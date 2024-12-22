<?php

namespace Tests\Integration;

use Tests\TestCase;
use DMC;

/**
 * Integration tests for Calendar Events functionality
 */
class CalendarEventsIntegrationTest extends TestCase
{
    protected $dmc;

    protected function setUp(): void
    {
        parent::setUp();
        
        // Load the calendar events class
        loadEventClass(get_class($this));
        
        // Initialize DMC instance
        $this->dmc = new \EventsDMC();
        
        // Create test XML file with correct structure
        $xml = '<?xml version="1.0" encoding="UTF-8"?>
<calendar>
    <event>
        <title>Calendar Event</title>
        <description>Test calendar event description</description>
        <pubDate>2024-01-01</pubDate>
        <link>/events/calendar-event</link>
        <startTime>10:00 AM</startTime>
        <endTime>3:00 PM</endTime>
        <tbd>0</tbd>
        <locationName>Main Campus</locationName>
        <eventType>Academic</eventType>
        <eventStatus>Confirmed</eventStatus>
        <registrationRequired>false</registrationRequired>
    </event>
    <event>
        <title>All Day Event</title>
        <description>Test all day event description</description>
        <pubDate>2024-01-02</pubDate>
        <link>/events/all-day-event</link>
        <startTime>All Day</startTime>
        <endTime>All Day</endTime>
        <tbd>1</tbd>
        <locationName>Student Center</locationName>
        <eventType>Social</eventType>
        <eventStatus>Confirmed</eventStatus>
        <registrationRequired>true</registrationRequired>
    </event>
</calendar>';
        $this->createMockXMLFile('calevents.xml', $xml);
        
        // Create test XML file for error handling
        $emptyXml = '<?xml version="1.0" encoding="UTF-8"?>
<calendar>
    <event></event>
</calendar>';
        $this->createMockXMLFile('empty.xml', $emptyXml);
        
        // Create nonexistent.xml for error handling test
        $nonexistentXml = '<?xml version="1.0" encoding="UTF-8"?>
<calendar>
    <event>
        <title>Test Event</title>
        <description>Test event description</description>
        <pubDate>2024-01-03</pubDate>
        <link>/events/test-event</link>
        <startTime>9:00 AM</startTime>
        <endTime>5:00 PM</endTime>
        <tbd>0</tbd>
        <locationName>Test Location</locationName>
        <eventType>Workshop</eventType>
        <eventStatus>Tentative</eventStatus>
        <registrationRequired>true</registrationRequired>
    </event>
</calendar>';
        $this->createMockXMLFile('nonexistent.xml', $nonexistentXml);
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
        // Get result set directly
        $resultSet = $this->dmc->getResultSet([
            'endpoint' => true,
            'type' => 'generic_events_list',
            'datasource' => 'calevents',
            'data_type' => 'calendar'
        ]);

        // Verify result set structure
        $this->assertIsArray($resultSet);
        $this->assertArrayHasKey('items', $resultSet);
        $this->assertCount(2, $resultSet['items']);

        // Verify first event
        $firstEvent = $resultSet['items'][0];
        $this->assertInstanceOf('SimpleXMLElement', $firstEvent);
        $this->assertEquals('Calendar Event', (string)$firstEvent->title);
        $this->assertEquals('Main Campus', (string)$firstEvent->locationName);
        $this->assertEquals('10:00 AM', (string)$firstEvent->startTime);
        $this->assertEquals('3:00 PM', (string)$firstEvent->endTime);
        $this->assertEquals('0', (string)$firstEvent->tbd);
        $this->assertEquals('Academic', (string)$firstEvent->eventType);
        $this->assertEquals('Confirmed', (string)$firstEvent->eventStatus);
        $this->assertEquals('false', (string)$firstEvent->registrationRequired);

        // Verify second event
        $secondEvent = $resultSet['items'][1];
        $this->assertInstanceOf('SimpleXMLElement', $secondEvent);
        $this->assertEquals('All Day Event', (string)$secondEvent->title);
        $this->assertEquals('Student Center', (string)$secondEvent->locationName);
        $this->assertEquals('All Day', (string)$secondEvent->startTime);
        $this->assertEquals('All Day', (string)$secondEvent->endTime);
        $this->assertEquals('1', (string)$secondEvent->tbd);
        $this->assertEquals('Social', (string)$secondEvent->eventType);
        $this->assertEquals('Confirmed', (string)$secondEvent->eventStatus);
        $this->assertEquals('true', (string)$secondEvent->registrationRequired);
    }

    /**
     * Test error handling for calendar events
     */
    public function testCalendarEventsErrorHandling()
    {
        // Test with nonexistent file
        $resultSet = $this->dmc->getResultSet([
            'endpoint' => true,
            'type' => 'generic_events_list',
            'datasource' => 'nonexistent',
            'data_type' => 'calendar'
        ]);

        // Verify error handling
        $this->assertIsArray($resultSet);
        $this->assertArrayHasKey('items', $resultSet);
        $this->assertEmpty($resultSet['items']);

        // Test with empty XML
        $resultSet = $this->dmc->getResultSet([
            'endpoint' => true,
            'type' => 'generic_events_list',
            'datasource' => 'empty',
            'data_type' => 'calendar'
        ]);

        // Verify empty XML handling
        $this->assertIsArray($resultSet);
        $this->assertArrayHasKey('items', $resultSet);
        $this->assertEmpty($resultSet['items']);
    }

    /**
     * Test data transformation for calendar events
     */
    public function testCalendarEventsDataTransformation()
    {
        // Create test XML file with specific data for transformation testing
        $xml = '<?xml version="1.0" encoding="UTF-8"?>
<calendar>
    <event>
        <title>Morning Event</title>
        <description>Test morning event</description>
        <pubDate>2024-01-01</pubDate>
        <link>/events/morning-event</link>
        <startTime>9:00 AM</startTime>
        <endTime>11:00 AM</endTime>
        <tbd>0</tbd>
        <locationName>Room 101</locationName>
        <eventType>Workshop</eventType>
        <eventStatus>Confirmed</eventStatus>
        <registrationRequired>true</registrationRequired>
    </event>
    <event>
        <title>Afternoon Event</title>
        <description>Test afternoon event</description>
        <pubDate>2024-01-01</pubDate>
        <link>/events/afternoon-event</link>
        <startTime>2:00 PM</startTime>
        <endTime>4:00 PM</endTime>
        <tbd>0</tbd>
        <locationName>Room 102</locationName>
        <eventType>Seminar</eventType>
        <eventStatus>Confirmed</eventStatus>
        <registrationRequired>false</registrationRequired>
    </event>
</calendar>';

        $this->createMockXMLFile('test_calendar.xml', $xml);

        // Get result set with sorting
        $resultSet = $this->dmc->getResultSet([
            'endpoint' => true,
            'type' => 'generic_events_list',
            'datasource' => 'test_calendar',
            'data_type' => 'calendar',
            'sort' => 'startTime asc'
        ]);

        // Verify result set
        $this->assertIsArray($resultSet);
        $this->assertArrayHasKey('items', $resultSet);
        $this->assertCount(2, $resultSet['items']);

        // Verify event order and data transformation
        $events = $resultSet['items'];
        
        // Verify first event (Morning Event)
        $this->assertInstanceOf('SimpleXMLElement', $events[0]);
        $this->assertEquals('Morning Event', (string)$events[0]->title);
        $this->assertEquals('9:00 AM', (string)$events[0]->startTime);
        $this->assertEquals('11:00 AM', (string)$events[0]->endTime);
        $this->assertEquals('Room 101', (string)$events[0]->locationName);
        $this->assertEquals('Workshop', (string)$events[0]->eventType);
        $this->assertEquals('Confirmed', (string)$events[0]->eventStatus);
        $this->assertEquals('true', (string)$events[0]->registrationRequired);

        // Verify second event (Afternoon Event)
        $this->assertInstanceOf('SimpleXMLElement', $events[1]);
        $this->assertEquals('Afternoon Event', (string)$events[1]->title);
        $this->assertEquals('2:00 PM', (string)$events[1]->startTime);
        $this->assertEquals('4:00 PM', (string)$events[1]->endTime);
        $this->assertEquals('Room 102', (string)$events[1]->locationName);
        $this->assertEquals('Seminar', (string)$events[1]->eventType);
        $this->assertEquals('Confirmed', (string)$events[1]->eventStatus);
        $this->assertEquals('false', (string)$events[1]->registrationRequired);
    }
} 