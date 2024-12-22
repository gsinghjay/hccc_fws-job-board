# Testing the Modern Campus Data Management Core (DMC)
## Overview

This testing suite provides comprehensive integration tests for Modern Campus's Data Management Core (DMC), specifically focusing on event and calendar functionality. The suite is designed to test how the DMC processes XML data feeds and transforms them into usable HTML output while maintaining proper namespace handling and data integrity.

## Architecture

### Core Components

1. **Data Management Core (DMC)**
   - Located in `_resources/dmc/php/_core/class.dmc.php`
   - Provides core XML processing functionality
   - Handles data retrieval, filtering, sorting, and transformation
   - Manages XML namespaces and caching

2. **Event Handlers**
   - `EventsDMC` class: Handles general event processing
   - `CalendarEventsDMC` class: Specializes in calendar-specific event processing
   - Both extend the base DMC functionality

### Test Structure

```
tests/
├── TestCase.php                              # Base test class
└── Integration/
    └── Events/
        ├── EventsDMCTest.php                 # General events tests
        └── Calendar/
            ├── CalendarEventsDMCTest.php     # Calendar-specific tests
            └── CalendarEventsIntegrationTest.php  # End-to-end tests
```

## XML Namespace Handling

The suite works with Modern Campus's standard XML namespaces:

```xml
<rss version="2.0" 
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:cal="https://moderncampus.com/Data/cal/">
```

Key namespaces:
- `cal:` - Calendar-specific elements (startTime, endTime, etc.)
- `dc:` - Dublin Core metadata
- `atom:` - Atom feed elements

## Test Data Management

### Directory Structure
```
tests/data/
├── events/          # General event XML files
└── calendar/        # Calendar-specific XML files
```

### Mock Data Creation
The `TestCase` class provides methods for creating and managing test data:

```php
protected function createMockXMLFile($filename, $content, $subdirectory = '')
{
    // Creates test XML files with proper namespace declarations
    // Handles directory creation and file permissions
}
```

## Test Cases

### 1. Event Processing Tests (`EventsDMCTest`)

Tests basic event handling functionality:
```php
public function testEventsProcessing()
{
    $this->dmc->get_output([
        'endpoint' => true,
        'type' => 'generic_events_list',
        'datasource' => 'events',
        'data_type' => 'events',
        'xpath' => '//item'
    ]);
}
```

Key assertions:
- Event title presence
- Date formatting
- Time display
- Location information

### 2. Calendar Event Tests (`CalendarEventsDMCTest`)

Focuses on calendar-specific features:
- All-day events
- Time-specific events
- Event status
- Registration requirements

### 3. Integration Tests (`CalendarEventsIntegrationTest`)

Tests end-to-end functionality:
- XML processing
- Data transformation
- HTML output generation
- Error handling

## Error Handling

The suite tests various error conditions:

1. **Missing Files**
   ```php
   public function testEventsErrorHandling()
   {
       // Tests behavior with nonexistent XML files
   }
   ```

2. **Empty Data**
   - Tests handling of empty XML feeds
   - Verifies proper fallback behavior

3. **Malformed XML**
   - Ensures proper error messages
   - Validates output structure integrity

## DMC Integration Points

### 1. Data Directory Configuration
```php
$this->dmc = new \EventsDMC('/tests/data/events/');
```
- Uses test data directory instead of production
- Maintains isolation from live data

### 2. XML Processing
```php
$xml = simplexml_load_file($xml_path);
$xml->registerXPathNamespace('cal', 'https://moderncampus.com/Data/cal/');
```
- Handles Modern Campus XML namespace registration
- Processes RSS feed structure

### 3. Output Generation
```php
$this->dmc->get_output([
    'endpoint' => true,
    'type' => 'generic_events_list',
    // ... other options
]);
```
- Transforms XML to HTML
- Applies Modern Campus styling
- Handles date/time formatting

## Best Practices

1. **Test Data Isolation**
   - Use separate directories for different types of test data
   - Clean up test files after each test run

2. **Namespace Handling**
   - Always include proper XML namespace declarations
   - Use correct namespace prefixes in XPath queries

3. **Error Testing**
   - Test both valid and invalid scenarios
   - Verify error message content and format

4. **Output Validation**
   - Check for proper HTML structure
   - Verify date/time formatting
   - Ensure proper event ordering

## Limitations

1. Cannot modify DMC core files (`_resources/dmc/*`)
2. Must work within existing XML namespace structure
3. Limited to testing against mock data files

## Future Considerations

1. **Additional Test Coverage**
   - More edge cases
   - Performance testing
   - Security testing

2. **Enhanced Mock Data**
   - More diverse event types
   - Complex scheduling scenarios
   - Multi-language support

3. **Automated Test Data Generation**
   - Dynamic XML generation
   - Randomized test scenarios
   - Stress testing capabilities

This testing suite provides a robust framework for ensuring the reliability and functionality of the Modern Campus DMC implementation while maintaining proper separation of concerns and test isolation.
