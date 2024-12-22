<?php

class EventsTest extends TestCase
{
    private $events;
    private $mockXMLFile = 'events.xml';
    
    protected function setUp(): void
    {
        parent::setUp();
        $this->events = $this->createMockDMC('events');
        
        // Create mock XML data with future dates
        $mockXML = <<<XML
<?xml version="1.0" encoding="UTF-8"?>
<events>
    <item>
        <title>Spring Career Fair</title>
        <description>Annual career fair for students and alumni</description>
        <pubDate>2025-04-15</pubDate>
        <link>/events/spring-career-fair</link>
        <startTime>10:00 AM</startTime>
        <endTime>3:00 PM</endTime>
        <tbd>0</tbd>
        <locationName>Student Center</locationName>
    </item>
    <item>
        <title>Orientation Day</title>
        <description>New student orientation</description>
        <pubDate>2025-03-01</pubDate>
        <link>/events/orientation-day</link>
        <startTime>9:00 AM</startTime>
        <endTime>12:00 PM</endTime>
        <tbd>0</tbd>
        <locationName>Main Auditorium</locationName>
    </item>
    <item>
        <title>Campus Holiday</title>
        <description>Campus closed for holiday</description>
        <pubDate>2025-05-01</pubDate>
        <link>/events/campus-holiday</link>
        <tbd>1</tbd>
        <locationName>All Campuses</locationName>
    </item>
</events>
XML;
        $this->createMockXMLFile($this->mockXMLFile, $mockXML);
    }
    
    protected function tearDown(): void
    {
        $this->removeMockXMLFile($this->mockXMLFile);
        parent::tearDown();
    }
    
    /**
     * Helper method to capture both echoed and returned output
     */
    private function getOutput(array $options): string
    {
        ob_start();
        $output = $this->events->get_output($options);
        $echoed = ob_get_clean();
        return $output ?: $echoed;
    }
    
    public function testGenericEventsList()
    {
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'generic_events_list',
            'datasource' => 'events',
            'sort' => 'date(pubDate)'
        ]);
        
        // Test basic structure
        $this->assertStringContainsString('class="column column--three"', $output);
        
        // Test event content
        $this->assertStringContainsString('Spring Career Fair', $output);
        $this->assertStringContainsString('Student Center', $output);
        $this->assertStringContainsString('10:00 AM - 3:00 PM', $output);
    }
    
    public function testHomepageEventsList()
    {
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'homepage_events_list',
            'datasource' => 'events',
            'sort' => 'date(pubDate)'
        ]);
        
        // Test structure and content
        $this->assertStringContainsString('events3up__item', $output);
        $this->assertStringContainsString('events3up__date', $output);
        $this->assertStringContainsString('events3up__time', $output);
        
        // Test event content
        $this->assertStringContainsString('Spring Career Fair', $output);
        $this->assertStringContainsString('Student Center', $output);
        $this->assertStringContainsString('10:00 AM - 3:00 PM', $output);
    }
    
    public function testEventItems()
    {
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'event_items',
            'title' => 'Upcoming Events',
            'datasource' => 'events',
            'sort' => 'date(pubDate)'
        ]);
        
        // Test structure
        $this->assertStringContainsString('class="container"', $output);
        $this->assertStringContainsString('class="row"', $output);
        $this->assertStringContainsString('class="card"', $output);
        
        // Test content
        $this->assertStringContainsString('Upcoming Events', $output);
        $this->assertStringContainsString('Spring Career Fair', $output);
        $this->assertStringContainsString('Annual career fair for students and alumni', $output);
    }
    
    public function testAllDayEvent()
    {
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'generic_events_list',
            'datasource' => 'events',
            'sort' => 'date(pubDate)'
        ]);
        
        // Test all-day event display
        $this->assertStringContainsString('Campus Holiday', $output);
        $this->assertStringContainsString('All Day', $output);
    }
    
    public function testEventDateFormatting()
    {
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'generic_events_list',
            'datasource' => 'events',
            'sort' => 'date(pubDate)'
        ]);
        
        // Test date formatting
        $this->assertStringContainsString('APR', $output); // For April event
        $this->assertStringContainsString('15', $output); // Day
        $this->assertStringContainsString('2025', $output); // Year
    }
    
    public function testEventSorting()
    {
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'generic_events_list',
            'datasource' => 'events',
            'sort' => 'date(pubDate)'
        ]);
        
        // Verify events are in chronological order
        $pos1 = strpos($output, 'Orientation Day');
        $pos2 = strpos($output, 'Spring Career Fair');
        $pos3 = strpos($output, 'Campus Holiday');
        
        $this->assertNotFalse($pos1);
        $this->assertNotFalse($pos2);
        $this->assertNotFalse($pos3);
        
        // Verify chronological order
        $this->assertLessThan($pos2, $pos1);
        $this->assertLessThan($pos3, $pos2);
    }
    
    public function testEventLinks()
    {
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'generic_events_list',
            'datasource' => 'events',
            'sort' => 'date(pubDate)'
        ]);
        
        // Test event links
        $this->assertStringContainsString('href="/events/spring-career-fair"', $output);
        $this->assertStringContainsString('href="/events/orientation-day"', $output);
        $this->assertStringContainsString('href="/events/campus-holiday"', $output);
    }
} 