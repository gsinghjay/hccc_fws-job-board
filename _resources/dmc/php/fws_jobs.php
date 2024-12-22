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
        // Consolidate staging detection logic
        $this->is_staging = false;
        
        // Check OU action from GET parameter
        if (isset($_GET['ou_action'])) {
            $this->is_staging = in_array($_GET['ou_action'], ['prv', 'edt', 'cmp']);
        }
        
        // Check OU action from options
        if (isset($options['ou_action'])) {
            $this->is_staging = $this->is_staging || in_array($options['ou_action'], ['prv', 'edt', 'cmp']);
        }
        
        // Check explicit staging flag
        if (isset($options['is_staging']) && $options['is_staging'] === 'true') {
            $this->is_staging = true;
        }
        
        // Add debug logging
        error_log(sprintf(
            "FWS Jobs - Staging Detection:\nGET ou_action: %s\nOptions ou_action: %s\nOptions is_staging: %s\nFinal staging status: %s",
            $_GET['ou_action'] ?? 'none',
            $options['ou_action'] ?? 'none',
            $options['is_staging'] ?? 'none',
            $this->is_staging ? 'Yes' : 'No'
        ));

        // Always attempt to load XML
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

        // Show staging message in preview/edit/compare modes
        if ($this->is_staging) {
            return $this->render_staging_message();
        }

        // Add required dependencies
        $output = $this->render_dependencies();
        $output .= $this->render_jobs($xml);
        
        return $output;
    }

    private function render_dependencies() {
        return '
        <!-- Bootstrap Icons CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
        ';
    }

    private function render_staging_message() {
        return '<div class="hccc-bs">
            <div class="container-fluid py-4">
                <div class="alert alert-warning">
                    <h4 class="alert-heading"><i class="bi bi-exclamation-triangle me-2"></i>Dynamic Content Preview</h4>
                    <p>This component displays dynamic Federal Work Study job listings that are only visible on the published site.</p>
                    <hr>
                    <p class="mb-0">The content is pulled from <code>_resources/data/fws_jobs.xml</code> and rendered using the DMC (Data Management Core).</p>
                </div>
            </div>
        </div>';
    }

    private function render_jobs($xml) {
        $output = '<div class="hccc-bs">'; // Bootstrap namespace wrapper
        $output .= '<div class="container-fluid py-4">';
        
        // Search and Filter Controls
        $output .= $this->render_search_filters();
        
        // Job Listings Grid
        $output .= '<div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4" id="jobListings">';
        
        // On-Campus Jobs
        if ($xml->on_campus_jobs && $xml->on_campus_jobs->job) {
            foreach ($xml->on_campus_jobs->job as $job) {
                $output .= $this->render_job_card($job, 'on-campus');
            }
        }
        
        // Off-Campus Jobs
        if ($xml->off_campus_jobs && $xml->off_campus_jobs->job) {
            foreach ($xml->off_campus_jobs->job as $job) {
                $output .= $this->render_job_card($job, 'off-campus');
            }
        }
        
        $output .= '</div>'; // End job listings grid
        
        // Add Modal
        $output .= $this->render_job_modal();
        
        // Add JavaScript
        $output .= $this->render_javascript();
        
        $output .= '</div></div>'; // End container and bootstrap wrapper
        
        return $output;
    }

    private function render_search_filters() {
        return '
        <div class="search-container">
            <div class="row align-items-center">
                <div class="col-md-4">
                    <div class="input-group">
                        <span class="input-group-text bg-white">
                            <i class="bi bi-search"></i>
                        </span>
                        <input type="text" id="jobSearch" class="form-control" placeholder="Search jobs..."/>
                    </div>
                </div>
                <div class="col-md-8">
                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-outline-primary filter-btn active" data-filter="all">
                            <i class="bi bi-grid-fill me-2"></i>All Jobs
                        </button>
                        <button type="button" class="btn btn-outline-primary filter-btn" data-filter="on-campus">
                            <i class="bi bi-building me-2"></i>On Campus
                        </button>
                        <button type="button" class="btn btn-outline-primary filter-btn" data-filter="off-campus">
                            <i class="bi bi-geo-alt me-2"></i>Off Campus
                        </button>
                    </div>
                </div>
            </div>
        </div>';
    }

    private function render_job_card($job, $type) {
        $output = '<div class="col">';
        $output .= '<div class="card h-100 job-card" data-job-type="' . $type . '">';
        $output .= '<div class="card-body">';
        
        // Title
        $output .= '<h5 class="card-title mb-3">' . htmlspecialchars((string)$job->title) . '</h5>';
        
        // Department/Organization
        $output .= '<h6 class="card-subtitle mb-3">';
        $output .= '<i class="bi bi-building me-2"></i>';
        $output .= htmlspecialchars((string)($job->department ?? $job->organization));
        $output .= '</h6>';
        
        // Pay Rate
        if (isset($job->pay_rate)) {
            $output .= '<p class="card-text pay-rate mb-3">';
            $output .= '<i class="bi bi-currency-dollar me-2"></i>';
            $output .= '$' . number_format((float)$job->pay_rate, 2) . '/hr';
            $output .= '</p>';
        }
        
        // Locations
        if (isset($job->locations) || isset($job->location)) {
            $output .= '<p class="card-text mb-3">';
            $output .= '<i class="bi bi-geo-alt me-2"></i>';
            if (isset($job->locations)) {
                foreach ($job->locations->location as $location) {
                    $output .= '<span class="location-badge me-2">' . htmlspecialchars((string)$location) . '</span>';
                }
            } else {
                $output .= '<span class="location-badge me-2">' . htmlspecialchars((string)$job->location) . '</span>';
            }
            $output .= '</p>';
        }
        
        // View Details Button
        $output .= '<button class="btn btn-primary w-100 view-details-btn" data-bs-toggle="modal" data-bs-target="#jobModal">';
        $output .= '<i class="bi bi-info-circle me-2"></i>View Details</button>';
        
        $output .= '</div>'; // End card-body

        // Card Footer
        $output .= '<div class="card-footer bg-transparent">';
        $output .= '<small class="text-muted">';
        $output .= '<i class="bi bi-envelope me-2"></i>Contact: ';
        $output .= '<a href="mailto:' . htmlspecialchars((string)$job->contact_email) . '">';
        $output .= htmlspecialchars((string)$job->contact_email) . '</a>';
        $output .= '</small>';
        $output .= '</div>';

        // Hidden job details for modal
        $output .= $this->render_hidden_job_details($job);
        
        $output .= '</div></div>'; // End card and col
        return $output;
    }

    private function render_hidden_job_details($job) {
        $output = '<div class="job-details d-none">';
        
        // Overview
        if (isset($job->description->overview)) {
            $output .= '<div class="mb-4">';
            $output .= '<h6 class="text-primary">';
            $output .= '<i class="bi bi-info-circle me-2"></i>Overview';
            $output .= '</h6>';
            $output .= '<p>' . htmlspecialchars((string)$job->description->overview) . '</p>';
            $output .= '</div>';
        }

        // Responsibilities
        if (isset($job->description->responsibilities)) {
            $output .= '<div class="mb-4">';
            $output .= '<h6 class="text-primary">';
            $output .= '<i class="bi bi-list-task me-2"></i>Responsibilities';
            $output .= '</h6>';
            $output .= '<ul class="list-unstyled">';
            foreach ($job->description->responsibilities->item as $item) {
                $output .= '<li class="mb-2">';
                $output .= '<i class="bi bi-check2 me-2"></i>';
                $output .= htmlspecialchars((string)$item);
                $output .= '</li>';
            }
            $output .= '</ul>';
            $output .= '</div>';
        }

        // Required Skills
        if (isset($job->required_skills) || isset($job->description->requirements)) {
            $output .= '<div class="mb-4">';
            $output .= '<h6 class="text-primary">';
            $output .= '<i class="bi bi-star me-2"></i>Required Skills';
            $output .= '</h6>';
            $output .= '<ul class="list-unstyled">';
            
            $skills = isset($job->required_skills) ? $job->required_skills->skill : $job->description->requirements->item;
            foreach ($skills as $skill) {
                $output .= '<li class="mb-2">';
                $output .= '<i class="bi bi-check-circle me-2"></i>';
                $output .= htmlspecialchars((string)$skill);
                $output .= '</li>';
            }
            $output .= '</ul>';
            $output .= '</div>';
        }

        // Languages
        if (isset($job->languages)) {
            $output .= '<div class="mb-4">';
            $output .= '<h6 class="text-primary">';
            $output .= '<i class="bi bi-translate me-2"></i>Languages';
            $output .= '</h6>';
            $output .= '<p>';
            foreach ($job->languages->language as $language) {
                $output .= '<span class="badge bg-secondary me-2">';
                $output .= htmlspecialchars((string)$language);
                $output .= '</span>';
            }
            $output .= '</p>';
            $output .= '</div>';
        }

        // Contact Information
        $output .= '<div class="contact-info">';
        $output .= '<h6 class="text-primary mb-3">';
        $output .= '<i class="bi bi-person-lines-fill me-2"></i>Contact Information';
        $output .= '</h6>';
        
        $output .= '<p class="mb-2">';
        $output .= '<i class="bi bi-person me-2"></i>';
        $output .= htmlspecialchars((string)($job->supervisor ?? $job->contact_person));
        $output .= '</p>';
        
        $output .= '<p class="mb-2">';
        $output .= '<i class="bi bi-envelope me-2"></i>';
        $output .= '<a href="mailto:' . htmlspecialchars((string)$job->contact_email) . '">';
        $output .= htmlspecialchars((string)$job->contact_email) . '</a>';
        $output .= '</p>';
        
        if (isset($job->locations) || isset($job->location)) {
            $output .= '<p class="mb-0">';
            $output .= '<i class="bi bi-geo-alt me-2"></i>';
            if (isset($job->locations)) {
                $locations = [];
                foreach ($job->locations->location as $location) {
                    $locations[] = htmlspecialchars((string)$location);
                }
                $output .= implode(', ', $locations);
            } else {
                $output .= htmlspecialchars((string)$job->location);
            }
            $output .= '</p>';
        }
        
        $output .= '</div>'; // End contact-info
        $output .= '</div>'; // End job-details
        
        return $output;
    }

    private function render_job_modal() {
        return '
        <div class="modal fade" id="jobModal" tabindex="-1" aria-labelledby="jobModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="jobModalLabel"></h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <!-- Modal content will be dynamically populated -->
                    </div>
                </div>
            </div>
        </div>';
    }

    private function render_javascript() {
        return '
        <script>
        document.addEventListener("DOMContentLoaded", function() {
            const searchInput = document.getElementById("jobSearch");
            searchInput.addEventListener("input", filterJobs);

            document.querySelectorAll(".filter-btn").forEach(button => {
                button.addEventListener("click", function() {
                    document.querySelectorAll(".filter-btn").forEach(btn => btn.classList.remove("active"));
                    this.classList.add("active");
                    filterJobs();
                });
            });

            function filterJobs() {
                const searchTerm = searchInput.value.toLowerCase();
                const activeFilter = document.querySelector(".filter-btn.active").dataset.filter;
                
                document.querySelectorAll(".job-card").forEach(card => {
                    const title = card.querySelector(".card-title").textContent.toLowerCase();
                    const dept = card.querySelector(".card-subtitle").textContent.toLowerCase();
                    const type = card.dataset.jobType;
                    
                    const matchesSearch = title.includes(searchTerm) || dept.includes(searchTerm);
                    const matchesFilter = activeFilter === "all" || type === activeFilter;
                    
                    card.closest(".col").style.display = matchesSearch && matchesFilter ? "block" : "none";
                });
            }

            const jobModal = document.getElementById("jobModal");
            const modalTitle = jobModal.querySelector(".modal-title");
            const modalBody = jobModal.querySelector(".modal-body");

            document.querySelectorAll(".view-details-btn").forEach(button => {
                button.addEventListener("click", function() {
                    const jobCard = this.closest(".job-card");
                    modalTitle.textContent = jobCard.querySelector(".card-title").textContent;
                    modalBody.innerHTML = jobCard.querySelector(".job-details").innerHTML;
                });
            });
        });
        </script>';
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