### 1. XML File Structure (`fws_jobs.xml`)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="fws_jobs.xslt"?>
<!-- This links the XML to the XSLT file for transformation -->

<job_board>
    <!-- Contains all job listings -->
    <on_campus_jobs>
        <!-- Group for on-campus positions -->
        <job>
            <!-- Individual job structure -->
            <title>Job Title</title>
            <department>Department Name</department>
            <pay_rate>Pay Amount</pay_rate>
            <supervisor>Supervisor Name</supervisor>
            <contact_email>email@example.com</contact_email>
            <locations>
                <location>Campus Location</location>
            </locations>
            <description>
                <overview>Job Overview Text</overview>
                <responsibilities>
                    <item>Responsibility 1</item>
                    <!-- More responsibilities -->
                </responsibilities>
            </description>
            <required_skills>
                <skill>Required Skill 1</skill>
                <!-- More skills -->
            </required_skills>
            <languages>
                <language>Language 1</language>
                <!-- More languages -->
            </languages>
        </job>
    </on_campus_jobs>
</job_board>
```

### 2. XSLT File Structure (`fws_jobs.xslt`)
```xslt
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Components and their purposes: -->

1. Dependencies
   <!-- Bootstrap CSS, Icons, and JavaScript -->
   <link href="bootstrap.min.css"/>
   <link href="bootstrap-icons.css"/>
   <script src="bootstrap.bundle.min.js"/>

2. Custom Styling
   <!-- CSS for job cards, modals, and layout -->
   <style>
       /* Card animations and hover effects */
       /* Color schemes and typography */
       /* Layout and spacing */
       /* Modal styling */
   </style>

3. Main Template Structure
   <!-- Container for the entire job board -->
   <div class="container-fluid">
       <!-- Search and filter controls -->
       <!-- Job listings grid -->
       <!-- Modal for job details -->
   </div>

4. JavaScript Functionality
   <!-- Search filtering -->
   <!-- Category filtering -->
   <!-- Modal interactions -->

5. Individual Templates
   <!-- Template for job cards -->
   <!-- Template for modal content -->
   <!-- Template for contact information -->
</xsl:stylesheet>
```

### Key Features:

1. **Search Functionality**
   - Real-time filtering of jobs based on search input
   - Searches through job titles and departments
   - Highlights matching terms in results

2. **Category Filtering**
   - Toggle between all jobs, on-campus, and off-campus
   - Visual indicators for active filters
   - Multiple filter combinations possible

3. **Job Cards**
   - Hover animations for better interactivity
   - Consistent layout for job information
   - Contact details in footer
   - "View Details" button for more information
   - Pay rate display with currency formatting
   - Location badges for multiple campuses

4. **Modal Details**
   - Comprehensive job information
   - Organized sections for:
     - Overview
     - Responsibilities
     - Required Skills
     - Languages
     - Contact Information
   - Icons for better visual hierarchy
   - Responsive layout for all screen sizes

5. **Responsive Design**
   - Mobile-friendly layout
   - Grid system adapts to screen size
   - Readable typography at all sizes
   - Touch-friendly interface
   - Collapsible sections on mobile

6. **Language Support**
   - Multilingual job listings
   - Language badges
   - Support for multiple languages per position
   - RTL language support

7. **Contact Information**
   - Clickable email addresses
   - Formatted phone numbers
   - Location mapping integration
   - Social media links when available

8. **Accessibility Features**
   - ARIA labels for screen readers
   - Keyboard navigation support
   - High contrast mode
   - Focus indicators
   - Alt text for icons

### Implementation Notes:

1. **File Placement**
   - Both files should be in the same directory
   - File names must match the reference in the XML stylesheet declaration
   - Case-sensitive file naming

2. **Browser Support**
   - Requires a modern browser with XSLT support
   - JavaScript must be enabled for filtering functionality
   - Fallback for older browsers

3. **Dependencies**
   - Bootstrap 5.3.2
   - Bootstrap Icons 1.11.3
   - No jQuery required
   - Modern Campus compatibility

4. **Maintenance**
   - Update Bootstrap versions as needed
   - XML structure must match XSLT expectations
   - JavaScript selectors rely on specific class names
   - Regular testing for accessibility compliance

5. **Performance Considerations**
   - Lazy loading for images
   - Optimized search functionality
   - Minified CSS and JavaScript
   - Caching strategies
