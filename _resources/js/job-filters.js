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

        jobCards.forEach(card => {
            const jobType = card.dataset.jobType;
            const title = card.querySelector('.card-title').textContent.toLowerCase();
            const department = card.querySelector('.card-subtitle').textContent.toLowerCase();

            // Check if card matches both filter and search criteria
            const matchesFilter = currentFilter === 'all' || jobType === currentFilter;
            const matchesSearch = title.includes(searchTerm) || department.includes(searchTerm);

            card.style.display = matchesSearch && matchesFilter ? 'block' : 'none';
        });
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