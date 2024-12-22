<?php

namespace Tests\Integration;

use Tests\TestCase;
use DMC;

/**
 * Integration tests for Events DMC functionality
 * This class tests the events.php functionality
 */
class EventsDMCTest extends TestCase
{
    protected $dmc;

    protected function setUp(): void
    {
        parent::setUp();
        
        // Load the events class
        loadEventClass(get_class($this));
        
        // Initialize DMC instance
        $this->dmc = new \EventsDMC();
        
        // Create test XML file with correct structure
        $xml = '<?xml version="1.0" encoding="UTF-8"?>
<events>
    <event>
        <title>Test Event</title>
        <description>Test event description</description>
        <pubDate>2024-01-01</pubDate>
        <link>/events/test-event</link>
        <startTime>10:00 AM</startTime>
        <endTime>3:00 PM</endTime>
        <tbd>0</tbd>
        <locationName>Main Hall</locationName>
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
        <locationName>Conference Room</locationName>
        <eventType>Social</eventType>
        <eventStatus>Confirmed</eventStatus>
        <registrationRequired>true</registrationRequired>
    </event>
</events>';
        $this->createMockXMLFile('events.xml', $xml);
        
        // Create test XML file for error handling
        $emptyXml = '<?xml version="1.0" encoding="UTF-8"?>
<events>
    <event></event>
</events>';
        $this->createMockXMLFile('empty.xml', $emptyXml);
        
        // Create nonexistent.xml for error handling test
        $nonexistentXml = '<?xml version="1.0" encoding="UTF-8"?>
<events>
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
</events>';
        $this->createMockXMLFile('nonexistent.xml', $nonexistentXml);
    }

    protected function tearDown(): void
    {
        parent::tearDown();
    }

    /**
     * Test events XML processing
     */
    public function testEventsProcessing()
    {
        // Get result set directly
        $resultSet = $this->dmc->getResultSet([
            'endpoint' => true,
            'type' => 'generic_events_list',
            'datasource' => 'events',
            'data_type' => 'events'
        ]);

        // Verify result set structure
        $this->assertIsArray($resultSet);
        $this->assertArrayHasKey('items', $resultSet);
        $this->assertCount(2, $resultSet['items']);

        // Verify first event
        $firstEvent = $resultSet['items'][0];
        $this->assertInstanceOf('SimpleXMLElement', $firstEvent);
        $this->assertEquals('Test Event', (string)$firstEvent->title);
        $this->assertEquals('Main Hall', (string)$firstEvent->locationName);
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
        $this->assertEquals('Conference Room', (string)$secondEvent->locationName);
        $this->assertEquals('All Day', (string)$secondEvent->startTime);
        $this->assertEquals('All Day', (string)$secondEvent->endTime);
        $this->assertEquals('1', (string)$secondEvent->tbd);
        $this->assertEquals('Social', (string)$secondEvent->eventType);
        $this->assertEquals('Confirmed', (string)$secondEvent->eventStatus);
        $this->assertEquals('true', (string)$secondEvent->registrationRequired);
    }

    /**
     * Test error handling for events
     */
    public function testErrorHandling()
    {
        // Test with nonexistent file
        $resultSet = $this->dmc->getResultSet([
            'endpoint' => true,
            'type' => 'generic_events_list',
            'datasource' => 'nonexistent',
            'data_type' => 'events'
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
            'data_type' => 'events'
        ]);

        // Verify empty XML handling
        $this->assertIsArray($resultSet);
        $this->assertArrayHasKey('items', $resultSet);
        $this->assertEmpty($resultSet['items']);
    }

    /**
     * Test data transformation for events
     */
    public function testDataTransformation()
    {
        // Create test XML file with specific data for transformation testing
        $xml = '<?xml version="1.0" encoding="UTF-8"?>
<events>
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
</events>';

        $this->createMockXMLFile('test_events.xml', $xml);

        // Get result set with sorting
        $resultSet = $this->dmc->getResultSet([
            'endpoint' => true,
            'type' => 'generic_events_list',
            'datasource' => 'test_events',
            'data_type' => 'events',
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