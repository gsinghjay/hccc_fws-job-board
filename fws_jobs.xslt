<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes" encoding="UTF-8"/>

<!-- Key-value parameter to control rendering -->
<xsl:param name="mode">editor</xsl:param>

<!-- Main template -->
<xsl:template match="/">
    <xsl:choose>
        <xsl:when test="$mode = 'preview'">
            <div class="container-fluid py-4">
                <!-- Search and Filter Controls -->
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
                </div>
                
                <!-- Job Listings Grid -->
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4" id="jobListings">
                    <xsl:apply-templates select="/job_board/on_campus_jobs/job" mode="listing">
                        <xsl:with-param name="job-type">on-campus</xsl:with-param>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="/job_board/off_campus_jobs/job" mode="listing">
                        <xsl:with-param name="job-type">off-campus</xsl:with-param>
                    </xsl:apply-templates>
                </div>
            </div>
        </xsl:when>
        <xsl:otherwise>
            <html>
            <head>
                <!-- Required Dependencies -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" defer="defer"></script>

                <!-- Editor Dependencies -->
                <script src="https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.36.1/min/vs/loader.min.js"></script>

                <!-- Custom CSS -->
                <link href="_resources/css/fws_jobs.css" rel="stylesheet"/>
                <link href="_resources/css/editor-layout.css" rel="stylesheet"/>

                <!-- Custom JavaScript -->
                <script src="_resources/js/job-filters.js"></script>
                <script src="_resources/js/xml-editor.js"></script>
            </head>
            <body>
                <div class="split-container">
                    <!-- Editor Pane -->
                    <div class="editor-pane">
                        <div class="editor-header">
                            <h4>XML Editor</h4>
                            <button id="updatePreview" class="btn btn-primary btn-sm">
                                <i class="bi bi-arrow-clockwise me-2"></i>Update Preview
                            </button>
                        </div>
                        <div id="xmlEditor">
                            <!-- Initial XML content will be loaded here -->
                        </div>
                    </div>

                    <!-- Resizer -->
                    <div class="resizer" id="dragMe"></div>

                    <!-- Preview Pane -->
                    <div class="preview-pane">
                        <div class="preview-header">
                            <h4>Preview</h4>
                        </div>
                        <div id="previewContent">
                            <iframe id="previewFrame" src="preview.html" style="width:100%; height:100%; border:none;">
                            </iframe>
                        </div>
                    </div>
                </div>
            </body>
            </html>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- Preview template -->
<xsl:template match="job_board" mode="preview">
    <style>
        /* Include any necessary styles for the preview */
        @import url('https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css');
        @import url('https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css');
        @import url('_resources/css/fws_jobs.css');
    </style>
    <div>
        <div class="container-fluid py-4">
            <!-- Search and Filter Controls -->
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
            </div>
            
            <!-- Job Listings Grid -->
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4" id="jobListings">
                <xsl:apply-templates select="on_campus_jobs/job" mode="listing">
                    <xsl:with-param name="job-type">on-campus</xsl:with-param>
                </xsl:apply-templates>
                <xsl:apply-templates select="off_campus_jobs/job" mode="listing">
                    <xsl:with-param name="job-type">off-campus</xsl:with-param>
                </xsl:apply-templates>
            </div>
        </div>

        <!-- Job Details Modal -->
        <div class="modal fade" id="jobModal" tabindex="-1">
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
        </div>
    </div>
</xsl:template>

<!-- Job template remains unchanged -->
<xsl:template match="job" mode="listing">
    <xsl:param name="job-type"/>
    <div class="col">
        <div class="card h-100 job-card" data-job-type="{$job-type}">
            <div class="card-body">
                <h5 class="card-title mb-3"><xsl:value-of select="title"/></h5>
                <h6 class="card-subtitle mb-3">
                    <i class="bi bi-building me-2"></i>
                    <xsl:value-of select="department|organization"/>
                </h6>
                <p class="card-text pay-rate mb-3">
                    <i class="bi bi-currency-dollar me-2"></i>
                    <xsl:value-of select="pay_rate"/>/hr
                </p>
                <xsl:if test="locations|location">
                    <p class="card-text mb-3">
                        <i class="bi bi-geo-alt me-2"></i>
                        <xsl:for-each select="locations/location|location">
                            <span class="location-badge me-2">
                                <xsl:value-of select="."/>
                            </span>
                        </xsl:for-each>
                    </p>
                </xsl:if>
                <button class="btn btn-primary w-100 view-details-btn" data-bs-toggle="modal" data-bs-target="#jobModal">
                    <i class="bi bi-info-circle me-2"></i>View Details
                </button>
            </div>
            <div class="card-footer bg-transparent">
                <small class="text-muted">
                    <i class="bi bi-envelope me-2"></i>
                    Contact: <a href="mailto:{contact_email}"><xsl:value-of select="contact_email"/></a>
                </small>
            </div>
            
            <!-- Hidden job details for modal -->
            <div class="job-details d-none">
                <xsl:if test="description/overview">
                    <div class="mb-4">
                        <h6 class="text-primary">
                            <i class="bi bi-info-circle me-2"></i>Overview
                        </h6>
                        <p><xsl:value-of select="description/overview"/></p>
                    </div>
                </xsl:if>

                <xsl:if test="description/responsibilities">
                    <div class="mb-4">
                        <h6 class="text-primary">
                            <i class="bi bi-list-task me-2"></i>Responsibilities
                        </h6>
                        <ul class="list-unstyled">
                            <xsl:for-each select="description/responsibilities/item">
                                <li class="mb-2">
                                    <i class="bi bi-check2 me-2"></i>
                                    <xsl:value-of select="."/>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </div>
                </xsl:if>

                <xsl:if test="required_skills|description/requirements">
                    <div class="mb-4">
                        <h6 class="text-primary">
                            <i class="bi bi-star me-2"></i>Required Skills
                        </h6>
                        <ul class="list-unstyled">
                            <xsl:for-each select="required_skills/skill|description/requirements/item">
                                <li class="mb-2">
                                    <i class="bi bi-check-circle me-2"></i>
                                    <xsl:value-of select="."/>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </div>
                </xsl:if>

                <xsl:if test="languages">
                    <div class="mb-4">
                        <h6 class="text-primary">
                            <i class="bi bi-translate me-2"></i>Languages
                        </h6>
                        <p>
                            <xsl:for-each select="languages/language">
                                <span class="badge bg-secondary me-2">
                                    <xsl:value-of select="."/>
                                </span>
                            </xsl:for-each>
                        </p>
                    </div>
                </xsl:if>

                <div class="contact-info">
                    <h6 class="text-primary mb-3">
                        <i class="bi bi-person-lines-fill me-2"></i>Contact Information
                    </h6>
                    <p class="mb-2">
                        <i class="bi bi-person me-2"></i>
                        <xsl:value-of select="supervisor|contact_person"/>
                    </p>
                    <p class="mb-2">
                        <i class="bi bi-envelope me-2"></i>
                        <a href="mailto:{contact_email}"><xsl:value-of select="contact_email"/></a>
                    </p>
                    <xsl:if test="locations|location">
                        <p class="mb-0">
                            <i class="bi bi-geo-alt me-2"></i>
                            <xsl:for-each select="locations/location|location">
                                <xsl:value-of select="."/>
                                <xsl:if test="position() != last()">, </xsl:if>
                            </xsl:for-each>
                        </p>
                    </xsl:if>
                </div>
            </div>
        </div>
    </div>
</xsl:template>

</xsl:stylesheet> 