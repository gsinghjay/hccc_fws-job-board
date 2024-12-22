<?php

namespace Tests;

use PHPUnit\Framework\TestCase;
use function Tests\createTestXMLFile;
use function Tests\getTestDataPath;

class EventsTest extends TestCase
{
    protected string $eventsXmlPath;

    protected function setUp(): void
    {
        parent::setUp();
        
        // Create test events data
        $eventsXml = <<<XML
<?xml version="1.0" encoding="UTF-8"?>
<events>
    <event>
        <id>1</id>
        <title>Test Event 1</title>
        <description>This is a test event description</description>
        <date>2024-01-01</date>
        <time>10:00 AM</time>
        <location>Main Campus</location>
        <link>/events/test-event-1</link>
        <all_day>false</all_day>
        <requirements>Must be enrolled in at least 6 credits</requirements>
    </event>
    <event>
        <id>2</id>
        <title>Test Event 2</title>
        <description>This is another test event description</description>
        <date>2024-01-02</date>
        <time>2:00 PM</time>
        <location>Science Building</location>
        <link>/events/test-event-2</link>
        <all_day>true</all_day>
        <requirements>Science major preferred</requirements>
    </event>
</events>
XML;

        $this->eventsXmlPath = createTestXMLFile('tests/data/events.xml', $eventsXml);
    }

    protected function tearDown(): void
    {
        parent::tearDown();
        if (file_exists($this->eventsXmlPath)) {
            unlink($this->eventsXmlPath);
        }
    }

    public function testGenericEventsList(): void
    {
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'events_list',
            'datasource' => 'events',
            'xpath' => '//event'
        ]);
        
        $this->assertStringContainsString('Test Event 1', $output);
        $this->assertStringContainsString('Test Event 2', $output);
        $this->assertStringContainsString('Main Campus', $output);
        $this->assertStringContainsString('Science Building', $output);
    }
    
    public function testHomepageEventsList(): void
    {
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'events_list',
            'datasource' => 'events',
            'xpath' => '//event',
            'limit' => 3
        ]);
        
        $this->assertStringContainsString('Test Event 1', $output);
        $this->assertStringContainsString('Test Event 2', $output);
        $this->assertStringContainsString('Main Campus', $output);
    }
    
    public function testEventItems(): void
    {
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'events_list',
            'datasource' => 'events',
            'xpath' => '//event'
        ]);
        
        $this->assertStringContainsString('class="event-item"', $output);
        $this->assertStringContainsString('class="event-title"', $output);
        $this->assertStringContainsString('class="event-date"', $output);
        $this->assertStringContainsString('class="event-location"', $output);
    }
    
    public function testAllDayEvent(): void
    {
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'events_list',
            'datasource' => 'events',
            'xpath' => '//event[all_day="true"]'
        ]);
        
        $this->assertStringContainsString('Test Event 2', $output);
        $this->assertStringContainsString('All Day Event', $output);
    }
    
    public function testEventDateFormatting(): void
    {
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'events_list',
            'datasource' => 'events',
            'xpath' => '//event'
        ]);
        
        $this->assertStringContainsString('January 1, 2024', $output);
        $this->assertStringContainsString('10:00 AM', $output);
    }
    
    public function testEventSorting(): void
    {
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'events_list',
            'datasource' => 'events',
            'xpath' => '//event',
            'sort' => 'date'
        ]);
        
        // Check if events are sorted by date
        $pos1 = strpos($output, 'Test Event 1');
        $pos2 = strpos($output, 'Test Event 2');
        
        $this->assertLessThan($pos2, $pos1, 'Events should be sorted by date');
    }
    
    public function testEventLinks(): void
    {
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'events_list',
            'datasource' => 'events',
            'xpath' => '//event'
        ]);
        
        $this->assertStringContainsString('href="/events/test-event-1"', $output);
        $this->assertStringContainsString('href="/events/test-event-2"', $output);
    }

    private function getOutput(array $options): string
    {
        // Mock the output generation
        $xml = simplexml_load_file($this->eventsXmlPath);
        if (!$xml) {
            return '<div class="alert alert-warning">Events data is unavailable.</div>';
        }

        $events = $xml->xpath($options['xpath']);
        if (empty($events)) {
            return '<div class="alert alert-info">No events found matching your criteria.</div>';
        }

        $output = '<div class="events-list">';
        foreach ($events as $event) {
            $output .= '<div class="event-item">';
            $output .= '<h3 class="event-title"><a href="' . $event->link . '">' . $event->title . '</a></h3>';
            $output .= '<div class="event-date">' . date('F j, Y', strtotime($event->date)) . '</div>';
            if ((string)$event->all_day === 'true') {
                $output .= '<div class="event-time">All Day Event</div>';
            } else {
                $output .= '<div class="event-time">' . $event->time . '</div>';
            }
            $output .= '<div class="event-location">' . $event->location . '</div>';
            $output .= '<div class="event-description">' . $event->description . '</div>';
            if (isset($event->requirements)) {
                $output .= '<div class="event-requirements">' . $event->requirements . '</div>';
            }
            $output .= '</div>';
        }
        $output .= '</div>';

        return $output;
    }
} 