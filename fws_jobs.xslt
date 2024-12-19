<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes" encoding="UTF-8"/>

<xsl:template match="job_board">
    <!-- Required Dependencies -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Custom CSS -->
    <style>
    <![CDATA[
        .job-card {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            border: none;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .job-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .card-title {
            color: #2c3e50;
            font-weight: 600;
        }
        .card-subtitle {
            color: #34495e;
        }
        .badge {
            font-size: 0.85em;
            padding: 0.4em 0.8em;
            margin: 0.2em;
        }
        .badge.bg-secondary {
            background-color: #6c757d !important;
        }
        .location-badge {
            background-color: #e9ecef;
            color: #495057;
            border-radius: 16px;
            padding: 0.25em 0.75em;
            font-size: 0.9em;
        }
        .pay-rate {
            color: #28a745;
            font-weight: 500;
        }
        .filter-btn.active {
            background-color: #0d6efd;
            color: white;
        }
        .search-container {
            background-color: #f8f9fa;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 2rem;
        }
        .modal-content {
            border-radius: 12px;
        }
        .modal-header {
            background-color: #f8f9fa;
            border-radius: 12px 12px 0 0;
        }
        .job-details i {
            color: #0d6efd;
        }
        .contact-info {
            background-color: #f8f9fa;
            padding: 1rem;
            border-radius: 8px;
            margin-top: 1rem;
        }
    ]]>
    </style>

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
            <xsl:apply-templates select="on_campus_jobs/job">
                <xsl:with-param name="job-type">on-campus</xsl:with-param>
            </xsl:apply-templates>
            <xsl:apply-templates select="off_campus_jobs/job">
                <xsl:with-param name="job-type">off-campus</xsl:with-param>
            </xsl:apply-templates>
        </div>
    </div>

    <!-- Job Details Modal -->
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
    </div>

    <!-- JavaScript -->
    <script>
    <![CDATA[
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.getElementById('jobSearch');
            searchInput.addEventListener('input', filterJobs);

            document.querySelectorAll('.filter-btn').forEach(button => {
                button.addEventListener('click', function() {
                    document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));
                    this.classList.add('active');
                    filterJobs();
                });
            });

            function filterJobs() {
                const searchTerm = searchInput.value.toLowerCase();
                const activeFilter = document.querySelector('.filter-btn.active').dataset.filter;
                
                document.querySelectorAll('.job-card').forEach(card => {
                    const title = card.querySelector('.card-title').textContent.toLowerCase();
                    const dept = card.querySelector('.card-subtitle').textContent.toLowerCase();
                    const type = card.dataset.jobType;
                    
                    const matchesSearch = title.includes(searchTerm) || dept.includes(searchTerm);
                    const matchesFilter = activeFilter === 'all' || type === activeFilter;
                    
                    card.style.display = matchesSearch && matchesFilter ? 'block' : 'none';
                });
            }

            const jobModal = document.getElementById('jobModal');
            const modalTitle = jobModal.querySelector('.modal-title');
            const modalBody = jobModal.querySelector('.modal-body');

            document.querySelectorAll('.view-details-btn').forEach(button => {
                button.addEventListener('click', function() {
                    const jobCard = this.closest('.job-card');
                    modalTitle.textContent = jobCard.querySelector('.card-title').textContent;
                    modalBody.innerHTML = jobCard.querySelector('.job-details').innerHTML;
                });
            });
        });
    ]]>
    </script>
</xsl:template>

<!-- Template for individual job cards -->
<xsl:template match="job">
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