// Initialize Monaco Editor
require.config({ paths: { vs: 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.36.1/min/vs' }});
require(['vs/editor/editor.main'], function() {
    // Configure XML syntax highlighting
    monaco.editor.defineTheme('xmlTheme', {
        base: 'vs',
        inherit: true,
        rules: [
            { token: 'tag', foreground: '0000FF' },              // Blue for tags
            { token: 'attribute.name', foreground: 'FF0000' },   // Red for attribute names
            { token: 'attribute.value', foreground: '008000' },  // Green for attribute values
            { token: 'comment', foreground: '808080' },          // Gray for comments
            { token: 'cdata', foreground: 'B22222' }            // Dark red for CDATA
        ],
        colors: {
            'editor.background': '#FFFFFF',
            'editor.lineHighlightBackground': '#F0F0F0'
        }
    });

    // Load initial XML content
    fetch('index.xml')
        .then(response => response.text())
        .then(initialXml => {
            // Create Monaco Editor
            const editor = monaco.editor.create(document.getElementById('xmlEditor'), {
                value: initialXml,
                language: 'xml',
                theme: 'xmlTheme',
                automaticLayout: true,
                minimap: { enabled: false },
                scrollBeyondLastLine: false,
                wordWrap: 'on',
                autoClosingBrackets: 'always',
                autoClosingTags: true,
                formatOnPaste: true,
                formatOnType: true,
                folding: true,
                foldingStrategy: 'indentation'
            });

            // Update preview function
            function updatePreview() {
                const xmlContent = editor.getValue();
                console.log('Updating preview with XML content:', xmlContent);
                
                // Load XSLT
                fetch('fws_jobs.xslt')
                    .then(response => response.text())
                    .then(xsltContent => {
                        console.log('Loaded XSLT:', xsltContent);
                        
                        // Create XML and XSLT documents
                        const parser = new DOMParser();
                        const xmlDoc = parser.parseFromString(xmlContent, 'text/xml');
                        const xsltDoc = parser.parseFromString(xsltContent, 'text/xml');
                        
                        // Create and configure transformer
                        const transformer = new XSLTProcessor();
                        transformer.importStylesheet(xsltDoc);
                        transformer.setParameter(null, 'mode', 'preview');
                        
                        // Transform XML
                        const resultDoc = transformer.transformToDocument(xmlDoc);
                        console.log('Transformed document:', resultDoc);
                        
                        // Get the preview frame
                        const previewFrame = document.getElementById('previewFrame');
                        console.log('Preview frame:', previewFrame);
                        
                        // Extract the body content only
                        const bodyContent = resultDoc.querySelector('div.container-fluid');
                        console.log('Body content:', bodyContent);
                        
                        if (bodyContent) {
                            // Wait for iframe to load if it hasn't already
                            if (!previewFrame.contentWindow.updateContent) {
                                console.log('Adding load event listener to iframe');
                                previewFrame.addEventListener('load', () => {
                                    console.log('Iframe loaded, updating content');
                                    previewFrame.contentWindow.updateContent(bodyContent.outerHTML);
                                });
                            } else {
                                console.log('Updating iframe content directly');
                                previewFrame.contentWindow.updateContent(bodyContent.outerHTML);
                            }
                        } else {
                            console.error('No preview content found in transformed document:', resultDoc);
                        }
                    })
                    .catch(error => console.error('Error:', error));
            }

            // Add event listeners
            document.getElementById('updatePreview').addEventListener('click', updatePreview);

            // Initial preview update
            updatePreview();
        });

    // Add after existing editor initialization code
    function initializeEditorToggle() {
        const editorToggle = document.querySelector('.editor-toggle');
        const editorPane = document.querySelector('.editor-pane');
        const editorOverlay = document.querySelector('.editor-overlay');
        const previewPane = document.querySelector('.preview-pane');

        // Set initial state based on screen width
        function setInitialState() {
            if (window.innerWidth > 768) {
                editorPane.classList.add('active');
                editorToggle.querySelector('i').classList.remove('bi-list');
                editorToggle.querySelector('i').classList.add('bi-x-lg');
            } else {
                editorPane.classList.remove('active');
                editorToggle.querySelector('i').classList.remove('bi-x-lg');
                editorToggle.querySelector('i').classList.add('bi-list');
            }
        }

        // Set initial state on load
        setInitialState();

        function toggleEditor() {
            editorPane.classList.toggle('active');
            editorOverlay.classList.toggle('active');
            
            // Update toggle button icon
            const toggleIcon = editorToggle.querySelector('i');
            if (editorPane.classList.contains('active')) {
                toggleIcon.classList.remove('bi-list');
                toggleIcon.classList.add('bi-x-lg');
            } else {
                toggleIcon.classList.remove('bi-x-lg');
                toggleIcon.classList.add('bi-list');
            }
        }

        // Toggle editor when hamburger is clicked
        editorToggle.addEventListener('click', toggleEditor);

        // Close editor when overlay is clicked
        editorOverlay.addEventListener('click', () => {
            if (editorPane.classList.contains('active')) {
                toggleEditor();
            }
        });

        // Handle escape key
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && editorPane.classList.contains('active')) {
                toggleEditor();
            }
        });

        // Update editor layout when window resizes
        let timeout;
        window.addEventListener('resize', () => {
            clearTimeout(timeout);
            timeout = setTimeout(() => {
                setInitialState();
                editor.layout(); // Refresh Monaco editor layout
            }, 250);
        });
    }

    // Call initialization after editor is created
    initializeEditorToggle();
}); 