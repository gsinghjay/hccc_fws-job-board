<?php
date_default_timezone_set('America/New_York');

require_once('_core/class.dmc.php');

class FWSJobsDMC {
    private $dmc;
    private $xml_path;
    private $is_staging = false;

    public function __construct($data_folder = null) {
        $this->dmc = new DMC($data_folder);
        $this->xml_path = $_SERVER['DOCUMENT_ROOT'] . '/_resources/data/fws_jobs.xml';
        
        // Simplified environment detection
        $this->is_staging = false; // Default to production
        
        if (isset($_GET['ou_action'])) {
            $action = $_GET['ou_action'];
            $this->is_staging = in_array($action, ['prv', 'edt', 'cmp']);
        }
        
        // Debug logging
        error_log(sprintf(
            "FWS Jobs DMC:\nHost: %s\nXML Path: %s\nAction: %s\nIs Staging: %s\nFile Exists: %s",
            $_SERVER['HTTP_HOST'],
            $this->xml_path,
            $_GET['ou_action'] ?? 'none',
            $this->is_staging ? 'Yes' : 'No',
            file_exists($this->xml_path) ? 'Yes' : 'No'
        ));
    }

    public function get_output($options) {
        // Combine constructor staging flag with options
        $original_staging = $this->is_staging;
        $options_staging = isset($options['is_staging']) && $options['is_staging'] === 'true';
        $this->is_staging = $original_staging || $options_staging;
        
        error_log(sprintf(
            "FWS Jobs - Staging Flags:\nOriginal: %s\nOptions: %s\nFinal: %s",
            $original_staging ? 'Yes' : 'No',
            $options_staging ? 'Yes' : 'No',
            $this->is_staging ? 'Yes' : 'No'
        ));
        
        // Always attempt to load and process XML
        if (!file_exists($this->xml_path)) {
            error_log("FWS Jobs - XML not found: " . $this->xml_path);
            return $this->render_error('Job listing data is unavailable.');
        }

        $xml_content = file_get_contents($this->xml_path);
        if (!$xml_content) {
            error_log("FWS Jobs - Failed to read XML");
            return $this->render_error('Unable to load job listings.');
        }

        $xml = simplexml_load_string($xml_content);
        if (!$xml) {
            error_log("FWS Jobs - Failed to parse XML");
            return $this->render_error('Error processing job listings.');
        }

        // Only show staging message in preview/edit/compare modes
        if ($this->is_staging) {
            return $this->render_staging_message();
        }

        return $this->render_jobs($xml);
    }

    private function render_staging_message() {
        return '<div class="hccc-bs">
            <div class="container-fluid py-4">
                <div class="alert alert-warning">
                    <h4 class="alert-heading"><i class="fas fa-exclamation-triangle me-2"></i>Dynamic Content Preview</h4>
                    <p>This component displays dynamic Federal Work Study job listings that are only visible on the published site.</p>
                    <hr>
                    <p class="mb-0">The content is pulled from <code>_resources/data/fws_jobs.xml</code> and rendered using the DMC (Data Management Core).</p>
                </div>
            </div>
        </div>';
    }

    private function render_jobs($xml) {
        error_log("FWS Jobs - Starting job render");
        
        $output = '<div class="hccc-bs">';
        $output .= '<div class="container-fluid py-4">';

        // On-Campus Jobs Section
        if ($xml->on_campus_jobs && $xml->on_campus_jobs->job) {
            $output .= $this->render_job_section('On-Campus Opportunities', $xml->on_campus_jobs->job);
        }

        // Off-Campus Jobs Section
        if ($xml->off_campus_jobs && $xml->off_campus_jobs->job) {
            $output .= $this->render_job_section('Off-Campus Opportunities', $xml->off_campus_jobs->job);
        }

        $output .= '</div></div>';
        
        error_log("FWS Jobs - Completed job render");
        return $output;
    }

    private function render_job_section($title, $jobs) {
        $output = '<div class="row mb-5">';
        $output .= '<div class="col-12">';
        $output .= '<h2 class="mb-4">' . htmlspecialchars($title) . '</h2>';
        $output .= '<div class="row g-4">';

        foreach ($jobs as $job) {
            $output .= $this->render_job_card($job);
        }

        $output .= '</div></div></div>';
        return $output;
    }

    private function render_job_card($job) {
        $output = '<div class="col-md-6 col-lg-4">';
        $output .= '<div class="card h-100 shadow-sm">';
        $output .= '<div class="card-body">';
        
        // Title
        $output .= '<h3 class="card-title h5">' . htmlspecialchars((string)$job->title) . '</h3>';
        
        // Department/Organization
        if (isset($job->department)) {
            $output .= '<p class="mb-2"><strong>Department:</strong> ' . htmlspecialchars((string)$job->department) . '</p>';
        } elseif (isset($job->organization)) {
            $output .= '<p class="mb-2"><strong>Organization:</strong> ' . htmlspecialchars((string)$job->organization) . '</p>';
        }
        
        // Pay Rate
        if (isset($job->pay_rate)) {
            $output .= '<p class="mb-2"><strong>Pay Rate:</strong> $' . number_format((float)$job->pay_rate, 2) . '/hour</p>';
        }

        // Location
        if (isset($job->locations)) {
            $locations = [];
            foreach ($job->locations->location as $location) {
                $locations[] = htmlspecialchars((string)$location);
            }
            $output .= '<p class="mb-2"><strong>Location:</strong> ' . implode(', ', $locations) . '</p>';
        } elseif (isset($job->location)) {
            $output .= '<p class="mb-2"><strong>Location:</strong> ' . htmlspecialchars((string)$job->location) . '</p>';
        }

        $output .= '</div>';

        // Card Footer with Contact Info
        if (isset($job->contact_email)) {
            $output .= '<div class="card-footer bg-transparent">';
            $output .= '<a href="mailto:' . htmlspecialchars((string)$job->contact_email) . '" ';
            $output .= 'class="btn btn-primary btn-sm">Contact for Details</a>';
            $output .= '</div>';
        }

        $output .= '</div></div>';
        return $output;
    }

    private function render_error($message) {
        return '<div class="hccc-bs">
                <div class="container-fluid py-4">
                    <div class="alert alert-warning">
                        ' . htmlspecialchars($message) . '
                    </div>
                </div>
            </div>';
    }
}

// Initialize and handle direct access
$fwsJobsDMC = new FWSJobsDMC();

if(str_replace('\\', '/', strtolower(__FILE__)) == str_replace('\\', '/', strtolower($_SERVER['SCRIPT_FILENAME']))) {
    if(isset($_GET['datasource']) && $_GET['datasource'] != '') {
        echo $fwsJobsDMC->get_output(['endpoint' => true]);
    }
}

function get_fws_jobs_dmc_output($options) {
    global $fwsJobsDMC;
    return $fwsJobsDMC->get_output($options);
}
?> 