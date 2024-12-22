<?php

class FWSJobsTest extends TestCase
{
    private $fwsJobs;
    private $mockXMLFile = 'fws_jobs.xml';
    
    protected function setUp(): void
    {
        parent::setUp();
        $this->fwsJobs = $this->createMockDMC('fws_jobs');
        
        // Create mock XML data
        $mockXML = <<<XML
<?xml version="1.0" encoding="UTF-8"?>
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
        </job>
    </on_campus_jobs>
    <off_campus_jobs>
        <job>
            <title>Marketing Intern</title>
            <organization>Tech Corp</organization>
            <pay_rate>18.00</pay_rate>
            <description>
                <overview>Marketing internship opportunity.</overview>
                <responsibilities>
                    <item>Social media management</item>
                    <item>Content creation</item>
                </responsibilities>
            </description>
            <required_skills>
                <skill>Social media expertise</skill>
                <skill>Creative writing</skill>
            </required_skills>
            <contact_email>jobs@techcorp.com</contact_email>
            <contact_person>Jane Smith</contact_person>
            <locations>
                <location>Downtown Office</location>
                <location>Remote</location>
            </locations>
            <languages>
                <language>English</language>
                <language>Spanish</language>
            </languages>
        </job>
    </off_campus_jobs>
</jobs>
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
        $output = $this->fwsJobs->get_output($options);
        $echoed = ob_get_clean();
        return $output ?: $echoed;
    }
    
    public function testJobListingOutput()
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
        $this->assertHtmlContainsElement($output, 'input', [
            'id' => 'jobSearch',
            'class' => 'form-control'
        ]);
        
        // Test job cards
        $this->assertHtmlContainsElement($output, 'div', [
            'class' => 'card h-100 job-card',
            'data-job-type' => 'on-campus'
        ]);
        $this->assertHtmlContainsElement($output, 'div', [
            'class' => 'card h-100 job-card',
            'data-job-type' => 'off-campus'
        ]);
    }
    
    public function testJobCardContent()
    {
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'job_listing',
            'datasource' => 'fws_jobs',
            'xpath' => '//job'
        ]);
        
        // Test on-campus job content
        $this->assertStringContainsString('Student Assistant', $output);
        $this->assertStringContainsString('Library', $output);
        $this->assertStringContainsString('$15.00/hr', $output);
        
        // Test off-campus job content
        $this->assertStringContainsString('Marketing Intern', $output);
        $this->assertStringContainsString('Tech Corp', $output);
        $this->assertStringContainsString('$18.00/hr', $output);
    }
    
    public function testErrorHandling()
    {
        // Remove XML file to test error handling
        $this->removeMockXMLFile($this->mockXMLFile);
        
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'job_listing',
            'datasource' => 'fws_jobs',
            'xpath' => '//job'
        ]);
        
        $this->assertStringContainsString('Job listing data is unavailable', $output);
    }
    
    public function testJobDetailsContent()
    {
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'job_listing',
            'datasource' => 'fws_jobs',
            'xpath' => '//job'
        ]);
        
        // Test job details content
        $this->assertStringContainsString('Work in the library helping students', $output);
        $this->assertStringContainsString('Assist students with research', $output);
        $this->assertStringContainsString('Good communication skills', $output);
        
        // Test contact information
        $this->assertStringContainsString('library@example.com', $output);
        $this->assertStringContainsString('John Doe', $output);
        
        // Test languages section for off-campus job
        $this->assertStringContainsString('English', $output);
        $this->assertStringContainsString('Spanish', $output);
    }
    
    public function testFilteringAndSearchFunctionality()
    {
        $output = $this->getOutput([
            'endpoint' => true,
            'type' => 'job_listing',
            'datasource' => 'fws_jobs',
            'xpath' => '//job'
        ]);
        
        // Test filter buttons
        $this->assertHtmlContainsElement($output, 'button', [
            'class' => 'btn btn-outline-primary filter-btn active',
            'data-filter' => 'all'
        ]);
        
        $this->assertHtmlContainsElement($output, 'button', [
            'class' => 'btn btn-outline-primary filter-btn',
            'data-filter' => 'on-campus'
        ]);
        
        $this->assertHtmlContainsElement($output, 'button', [
            'class' => 'btn btn-outline-primary filter-btn',
            'data-filter' => 'off-campus'
        ]);
    }
} 