<?php

namespace Tests\Integration;

use Tests\TestCase;
use DMC;

/**
 * Integration tests for FWS jobs DMC functionality
 */
class FWSJobsDMCTest extends TestCase
{
    protected $dmc;

    protected function setUp(): void
    {
        parent::setUp();
        
        // Load the FWS jobs class
        loadEventClass(get_class($this));
        
        // Initialize DMC instance
        $this->dmc = new \FWSJobsDMC();
        
        // Create test XML file with correct structure
        $jobsXml = '<?xml version="1.0" encoding="UTF-8"?>
<jobs>
    <on_campus_jobs>
        <job>
            <title>Student Assistant</title>
            <department>Library</department>
            <pay_rate>15.00</pay_rate>
            <description>
                <overview>Work in the library helping students.</overview>
                <responsibilities>
                    <item>Assist students with research</item>
                    <item>Maintain library organization</item>
                </responsibilities>
                <requirements>
                    <item>Good communication skills</item>
                    <item>Basic computer knowledge</item>
                </requirements>
            </description>
            <contact_email>library@example.com</contact_email>
            <supervisor>John Doe</supervisor>
            <location>Main Campus Library</location>
            <post_date>2024-01-01</post_date>
        </job>
        <job>
            <title>Lab Assistant</title>
            <department>Computer Science</department>
            <pay_rate>16.00</pay_rate>
            <description>
                <overview>Assist in computer labs.</overview>
                <responsibilities>
                    <item>Help students with technical issues</item>
                    <item>Maintain lab equipment</item>
                </responsibilities>
                <requirements>
                    <item>Computer Science major</item>
                    <item>Experience with Windows and Linux</item>
                </requirements>
            </description>
            <contact_email>cs@example.com</contact_email>
            <supervisor>Jane Smith</supervisor>
            <location>Computer Science Building</location>
            <post_date>2024-01-02</post_date>
        </job>
    </on_campus_jobs>
</jobs>';

        $this->createMockXMLFile('fws_jobs.xml', $jobsXml);
        
        // Create empty XML file
        $emptyXml = '<?xml version="1.0" encoding="UTF-8"?>
<jobs>
    <on_campus_jobs>
        <job></job>
    </on_campus_jobs>
</jobs>';

        $this->createMockXMLFile('empty.xml', $emptyXml);
    }

    protected function tearDown(): void
    {
        parent::tearDown();
    }

    /**
     * Test jobs processing
     */
    public function testJobsProcessing()
    {
        // Start output buffering
        ob_start();
        
        // Get jobs
        $this->dmc->get_output([
            'endpoint' => true,
            'type' => 'listing',
            'datasource' => 'fws_jobs',
            'data_type' => 'jobs'
        ]);
        
        // Get output
        $output = ob_get_clean();
        
        // Verify job details
        $this->assertStringContainsString('Student Assistant', $output);
        $this->assertStringContainsString('Lab Assistant', $output);
        $this->assertStringContainsString('Library', $output);
        $this->assertStringContainsString('Computer Science', $output);
        $this->assertStringContainsString('$15.00', $output);
        $this->assertStringContainsString('$16.00', $output);
    }

    /**
     * Test error handling
     */
    public function testErrorHandling()
    {
        // Start output buffering
        ob_start();
        
        // Test with nonexistent file
        $this->dmc->get_output([
            'endpoint' => true,
            'type' => 'listing',
            'datasource' => 'nonexistent',
            'data_type' => 'jobs'
        ]);
        
        // Get output
        $output = ob_get_clean();
        
        // Verify error message for missing file
        $this->assertStringContainsString('Failed to load XML', $output);
        
        // Start output buffering again
        ob_start();
        
        // Test empty XML content
        $this->dmc->get_output([
            'endpoint' => true,
            'type' => 'listing',
            'datasource' => 'empty',
            'data_type' => 'jobs'
        ]);
        
        // Get output
        $output = ob_get_clean();
        
        // Verify handling of empty XML
        $this->assertEmpty(trim($output));
    }

    /**
     * Test job data transformation
     */
    public function testJobDataTransformation()
    {
        // Start output buffering
        ob_start();
        
        // Get jobs with sorting
        $this->dmc->get_output([
            'endpoint' => true,
            'type' => 'listing',
            'datasource' => 'fws_jobs',
            'data_type' => 'jobs',
            'sort' => 'post_date desc'
        ]);
        
        // Get output
        $output = ob_get_clean();
        
        // Verify sorting (Lab Assistant should appear before Student Assistant)
        $this->assertMatchesRegularExpression('/Lab Assistant.*Student Assistant/s', $output);
        
        // Verify date formatting
        $this->assertStringContainsString('2024', $output);
        
        // Verify pay rate formatting
        $this->assertStringContainsString('$15.00', $output);
        $this->assertStringContainsString('$16.00', $output);
        
        // Verify location display
        $this->assertStringContainsString('Main Campus Library', $output);
        $this->assertStringContainsString('Computer Science Building', $output);
    }
} 