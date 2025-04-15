<?php
date_default_timezone_set('America/New_York');

require_once('_core/class.dmc.php');

class TimelineDMC {
    private $dmc;
    private $xml_path;

    public function __construct($data_folder = null) {
        $this->dmc = new DMC($data_folder);
        $this->xml_path = $_SERVER['DOCUMENT_ROOT'] . '/_resources/data/timeline.xml';
    }

    public function get_output($options) {
        // Check for XML file
        if (!file_exists($this->xml_path)) {
            return $this->render_error('Timeline data is unavailable.');
        }

        $xml_content = file_get_contents($this->xml_path);
        if (!$xml_content) {
            return $this->render_error('Unable to load timeline data.');
        }

        $xml = simplexml_load_string($xml_content);
        if (!$xml) {
            return $this->render_error('Error processing timeline data.');
        }

        // Add required dependencies and render timeline
        $output = $this->render_dependencies();
        $output .= $this->render_timeline($xml);
        
        return $output;
    }

    private function render_dependencies() {
        return '
        <!-- Bootstrap Icons CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
        <link href="/_resources/css/timeline.css" rel="stylesheet"/>
        ';
    }

    private function render_timeline($xml) {
        $output = '<div class="hccc-bs">'; // Bootstrap namespace wrapper
        $output .= '<div class="container py-4">';
        
        // Title
        $output .= '<h1 class="text-center my-4">HCCC: Timeline of Excellence</h1>';
        
        // Year filter controls
        $output .= $this->render_year_filters($xml);
        
        // Timeline content
        $output .= '<div id="timelineContent" class="timeline-container">';
        
        // Process each year
        foreach ($xml->year as $year) {
            $year_value = (string)$year['value'];
            
            $output .= '<div class="year-block" data-year="' . $year_value . '">';
            
            // Year divider
            $output .= '<div class="year-divider"><h3>' . $year_value . '</h3></div>';
            
            // Process each event in the year
            $output .= '<div class="row row-cols-1 row-cols-sm-1 row-cols-md-2 row-cols-lg-3 row-cols-xl-4 g-4">';
            foreach ($year->event as $event) {
                $output .= '<div class="timeline-event">';
                $output .= $this->render_event_card($event);
                $output .= '</div>'; // End timeline-event
            }
            $output .= '</div>'; // End row
            
            $output .= '</div>'; // End year-block
        }
        
        $output .= '</div>'; // End timelineContent
        
        // Add JavaScript for filtering
        $output .= $this->render_javascript();
        
        $output .= '</div></div>'; // End container and bootstrap wrapper
        
        return $output;
    }

    private function render_year_filters($xml) {
        $years = array();
        foreach ($xml->year as $year) {
            $years[] = (string)$year['value'];
        }
        
        // Sort years in descending order (most recent first)
        rsort($years);
        
        $output = '
        <div class="timeline-year-heading">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h2>Filter by Year</h2>
                </div>
                <div class="col-md-6">
                    <div class="form-group float-md-end">
                        <select class="form-select year-filter-select rounded-0" aria-label="Filter timeline by year">
                            <option value="all" selected><i class="bi bi-grid-fill"></i> All Years</option>';
                        
        foreach ($years as $year) {
            $output .= '
                            <option value="' . $year . '">' . $year . '</option>';
        }
                        
        $output .= '
                        </select>
                    </div>
                </div>
            </div>
        </div>';
        
        return $output;
    }

    private function render_event_card($event) {
        $output = '<div class="card h-100 timeline-card rounded-0">';
        
        // Event image
        if (isset($event->image) && !empty($event->image)) {
            $output .= '<img src="' . htmlspecialchars((string)$event->image) . '" class="card-img-top rounded-0" alt="' . htmlspecialchars((string)$event->title) . '">';
        } else {
            $output .= '<img src="https://placehold.co/400x300/00A79D/white?text=Event" class="card-img-top rounded-0" alt="Event">';
        }
        
        $output .= '<div class="card-body d-flex flex-column">';
        
        // Event date
        if (isset($event->date) && !empty($event->date)) {
            $output .= '<p class="timeline-date mb-1"><i class="bi bi-calendar3 me-2"></i>' . htmlspecialchars((string)$event->date) . '</p>';
        }
        
        // Event title
        $output .= '<h5 class="timeline-title mb-2">' . htmlspecialchars((string)$event->title) . '</h5>';
        
        // Short description
        if (isset($event->description) && !empty($event->description)) {
            $output .= '<p class="card-text">' . htmlspecialchars((string)$event->description) . '</p>';
        }
        
        $output .= '</div>'; // End card-body
        
        $output .= '</div>'; // End card
        return $output;
    }

    private function render_javascript() {
        return '
        <script>
        document.addEventListener("DOMContentLoaded", function() {
            // Year filtering with dropdown
            document.querySelector(".year-filter-select").addEventListener("change", function() {
                // Get the selected year value
                const yearFilter = this.value;
                
                // Filter year blocks
                document.querySelectorAll(".year-block").forEach(yearBlock => {
                    if (yearFilter === "all" || yearBlock.dataset.year === yearFilter) {
                        yearBlock.style.display = "block";
                    } else {
                        yearBlock.style.display = "none";
                    }
                });
            });
        });
        </script>';
    }

    private function render_error($message) {
        return '<div class="hccc-bs">
                <div class="container-fluid py-4">
                    <div class="alert alert-warning rounded-0">
                        ' . htmlspecialchars($message) . '
                    </div>
                </div>
            </div>';
    }
}

// Initialize and handle direct access
$timelineDMC = new TimelineDMC();

if(str_replace('\\', '/', strtolower(__FILE__)) == str_replace('\\', '/', strtolower($_SERVER['SCRIPT_FILENAME']))) {
    if(isset($_GET['datasource']) && $_GET['datasource'] != '') {
        echo $timelineDMC->get_output(['endpoint' => true]);
    }
}

function get_timeline_dmc_output($options) {
    global $timelineDMC;
    return $timelineDMC->get_output($options);
}
?> 