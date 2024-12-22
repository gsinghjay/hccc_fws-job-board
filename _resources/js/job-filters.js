function initializeFilters() {
    // Initialize filter buttons
    const filterButtons = document.querySelectorAll('.filter-btn');
    const searchInput = document.getElementById('jobSearch');

    // Check if elements exist
    if (!filterButtons.length || !searchInput) {
        console.log('Filter elements not found, skipping initialization');
        return;
    }

    let currentFilter = 'all';

    // Function to filter and search jobs
    function filterAndSearchJobs() {
        const searchTerm = searchInput.value.toLowerCase();
        const jobCards = document.querySelectorAll('.job-card');
        let visibleCount = 0;

        jobCards.forEach(card => {
            const jobType = card.dataset.jobType;
            const title = card.querySelector('.card-title').textContent.toLowerCase();
            const department = card.querySelector('.card-subtitle').textContent.toLowerCase();

            // Check if card matches both filter and search criteria
            const matchesFilter = currentFilter === 'all' || jobType === currentFilter;
            const matchesSearch = title.includes(searchTerm) || department.includes(searchTerm);

            // Use data attributes for visibility
            if (matchesFilter && matchesSearch) {
                card.setAttribute('data-visible', 'true');
                card.closest('.col').style.order = visibleCount++;
            } else {
                card.setAttribute('data-visible', 'false');
                card.closest('.col').style.order = '9999';  // Move hidden cards to end
            }
        });

        // Update container height if needed
        const container = document.getElementById('jobListings');
        container.style.minHeight = visibleCount > 0 ? 'auto' : '200px';
    }

    // Add event listeners for filter buttons
    filterButtons.forEach(button => {
        button.addEventListener('click', function() {
            // Remove active class from all buttons
            filterButtons.forEach(btn => btn.classList.remove('active'));
            // Add active class to clicked button
            this.classList.add('active');
            
            // Update current filter
            currentFilter = this.dataset.filter;
            
            // Apply filter and search
            filterAndSearchJobs();
        });
    });

    // Add event listener for search input
    searchInput.addEventListener('input', filterAndSearchJobs);
} 