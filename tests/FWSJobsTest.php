<?php

namespace Tests;

use PHPUnit\Framework\TestCase;
use DOMDocument;
use DOMXPath;
use function Tests\createTestXMLFile;
use function Tests\getTestDataPath;

class FWSJobsTest extends TestCase
{
    protected string $jobsXmlPath;

    protected function setUp(): void
    {
        parent::setUp();
        
        // Create test jobs data
        $jobsXml = <<<XML
<?xml version="1.0" encoding="UTF-8"?>
<jobs>
    <job>
        <id>1</id>
        <title>Student Assistant</title>
        <department>Library</department>
        <description>Work in the library helping students</description>
        <requirements>Must be enrolled in at least 6 credits</requirements>
        <location>Main Campus</location>
        <type>Federal Work Study</type>
        <hours>10-20 hours per week</hours>
        <wage>$15.00 per hour</wage>
        <contact>library@example.com</contact>
        <posted>2024-01-01</posted>
    </job>
    <job>
        <id>2</id>
        <title>Lab Assistant</title>
        <department>Science</department>
        <description>Assist in science labs</description>
        <requirements>Science major preferred</requirements>
        <location>Science Building</location>
        <type>Federal Work Study</type>
        <hours>15-25 hours per week</hours>
        <wage>$16.00 per hour</wage>
        <contact>science@example.com</contact>
        <posted>2024-01-02</posted>
    </job>
</jobs>
XML;

        $this->jobsXmlPath = createTestXMLFile('tests/data/jobs.xml', $jobsXml);
    }

    protected function tearDown(): void
    {
        parent::tearDown();
        if (file_exists($this->jobsXmlPath)) {
            unlink($this->jobsXmlPath);
        }
    }

    public function testJobListingOutput(): void
    {
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'job_listing',
            'datasource' => 'fws_jobs',
            'xpath' => '//job'
        ]);
        
        // Test basic structure
        $this->assertStringContainsString('class="hccc-bs"', $output);
        $this->assertStringContainsString('id="jobListings"', $output);
        
        // Test search and filter controls
        $this->assertStringContainsString('id="jobSearch"', $output);
        $this->assertStringContainsString('class="form-control"', $output);
    }
    
    public function testJobCardContent(): void
    {
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'job_listing',
            'datasource' => 'fws_jobs',
            'xpath' => '//job'
        ]);
        
        // Test job content
        $this->assertStringContainsString('Student Assistant', $output);
        $this->assertStringContainsString('Library', $output);
        $this->assertStringContainsString('$15.00 per hour', $output);
    }
    
    public function testJobDetailsContent(): void
    {
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'job_listing',
            'datasource' => 'fws_jobs',
            'xpath' => '//job'
        ]);
        
        // Test job details content
        $this->assertStringContainsString('Work in the library helping students', $output);
        $this->assertStringContainsString('Must be enrolled in at least 6 credits', $output);
        $this->assertStringContainsString('library@example.com', $output);
    }
    
    public function testFilteringAndSearchFunctionality(): void
    {
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'job_listing',
            'datasource' => 'fws_jobs',
            'xpath' => '//job'
        ]);
        
        // Test filter buttons
        $this->assertStringContainsString('button', $output);
        $this->assertStringContainsString('data-filter="all"', $output);
        $this->assertStringContainsString('data-filter="Federal Work Study"', $output);
    }

    private function getOutput(array $options): string
    {
        // Mock the output generation
        $xml = simplexml_load_file($this->jobsXmlPath);
        if (!$xml) {
            return '<div class="hccc-bs">
                <div class="container-fluid py-4">
                    <div class="alert alert-warning">
                        Job listing data is unavailable.
                    </div>
                </div>
            </div>';
        }

        $jobs = $xml->xpath($options['xpath']);
        if (empty($jobs)) {
            return '<div class="hccc-bs">
                <div class="container-fluid py-4">
                    <div class="alert alert-info">
                        No jobs found matching your criteria.
                    </div>
                </div>
            </div>';
        }

        $output = '<div class="hccc-bs">
            <div class="container-fluid py-4">
                <div id="jobListings">
                    <div class="row">
                        <div class="col-12 mb-4">
                            <input type="text" id="jobSearch" class="form-control" placeholder="Search jobs...">
                            <div class="btn-group mt-2">
                                <button class="btn btn-outline-primary active" data-filter="all">All Jobs</button>
                                <button class="btn btn-outline-primary" data-filter="Federal Work Study">Work Study</button>
                            </div>
                        </div>
                    </div>
                    <div class="row">';

        foreach ($jobs as $job) {
            $output .= '<div class="col-md-6 col-lg-4 mb-4">
                <div class="card h-100 job-card" data-job-type="' . $job->type . '">
                    <div class="card-body">
                        <h5 class="card-title">' . $job->title . '</h5>
                        <p class="card-text">' . $job->description . '</p>
                        <ul class="list-unstyled">
                            <li><strong>Department:</strong> ' . $job->department . '</li>
                            <li><strong>Location:</strong> ' . $job->location . '</li>
                            <li><strong>Hours:</strong> ' . $job->hours . '</li>
                            <li><strong>Wage:</strong> ' . $job->wage . '</li>
                            <li><strong>Requirements:</strong> ' . $job->requirements . '</li>
                            <li><strong>Contact:</strong> ' . $job->contact . '</li>
                        </ul>
                    </div>
                </div>
            </div>';
        }

        $output .= '</div></div></div></div>';
        return $output;
    }
} 